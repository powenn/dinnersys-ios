/*
 * Copyright 2019 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

<<<<<<< Updated upstream:Pods/FirebaseInstanceID/Firebase/InstanceID/FIRInstanceIDTokenOperation.m
#import "FIRInstanceIDTokenOperation.h"

#import <FirebaseInstallations/FirebaseInstallations.h>

#import "FIRInstanceIDCheckinPreferences.h"
#import "FIRInstanceIDLogger.h"
#import "FIRInstanceIDURLQueryItem.h"
#import "FIRInstanceIDUtilities.h"
#import "NSError+FIRInstanceID.h"

static const NSInteger kFIRInstanceIDPlatformVersionIOS = 2;
=======
#import "FirebaseMessaging/Sources/Token/FIRMessagingTokenOperation.h"

#import <GoogleUtilities/GULAppEnvironmentUtil.h>
#import "FirebaseInstallations/Source/Library/Private/FirebaseInstallationsInternal.h"
#import "FirebaseMessaging/Sources/FIRMessagingLogger.h"
#import "FirebaseMessaging/Sources/FIRMessagingUtilities.h"
#import "FirebaseMessaging/Sources/FIRMessaging_Private.h"
#import "FirebaseMessaging/Sources/NSError+FIRMessaging.h"
#import "FirebaseMessaging/Sources/Token/FIRMessagingCheckinPreferences.h"

static const NSInteger kFIRMessagingPlatformVersionIOS = 2;
>>>>>>> Stashed changes:Pods/FirebaseMessaging/FirebaseMessaging/Sources/Token/FIRMessagingTokenOperation.m

static NSString *const kFIRInstanceIDParamInstanceID = @"appid";
// Scope parameter that defines the service using the token
static NSString *const kFIRMessagingParamScope = @"X-scope";
// Defines the SDK version
static NSString *const kFIRMessagingParamFCMLibVersion = @"X-cliv";

@interface FIRMessagingTokenOperation () {
  BOOL _isFinished;
  BOOL _isExecuting;
  NSMutableArray<FIRMessagingTokenOperationCompletion> *_completionHandlers;
  FIRMessagingCheckinPreferences *_checkinPreferences;
}

@property(nonatomic, readwrite, strong) NSString *instanceID;

@property(atomic, strong, nullable) NSString *FISAuthToken;

@end

@implementation FIRMessagingTokenOperation

- (instancetype)initWithAction:(FIRMessagingTokenAction)action
           forAuthorizedEntity:(NSString *)authorizedEntity
                         scope:(NSString *)scope
                       options:(NSDictionary<NSString *, NSString *> *)options
            checkinPreferences:(FIRMessagingCheckinPreferences *)checkinPreferences
                    instanceID:(NSString *)instanceID {
  self = [super init];
  if (self) {
    _action = action;
    _authorizedEntity = [authorizedEntity copy];
    _scope = [scope copy];
    _options = [options copy];
    _checkinPreferences = checkinPreferences;
    _instanceID = instanceID;
    _completionHandlers = [[NSMutableArray alloc] init];

    _isExecuting = NO;
    _isFinished = NO;
  }
  return self;
}

- (void)dealloc {
  [_completionHandlers removeAllObjects];
}

- (void)addCompletionHandler:(FIRMessagingTokenOperationCompletion)handler {
  [_completionHandlers addObject:[handler copy]];
}

- (BOOL)isAsynchronous {
  return YES;
}

- (BOOL)isExecuting {
  return _isExecuting;
}

- (void)setExecuting:(BOOL)executing {
  [self willChangeValueForKey:@"isExecuting"];
  _isExecuting = executing;
  [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isFinished {
  return _isFinished;
}

- (void)setFinished:(BOOL)finished {
  [self willChangeValueForKey:@"isFinished"];
  _isFinished = finished;
  [self didChangeValueForKey:@"isFinished"];
}

- (void)start {
  if (self.isCancelled) {
    [self finishWithResult:FIRMessagingTokenOperationCancelled token:nil error:nil];
    return;
  }

  // Quickly validate whether or not the operation has all it needs to begin
  BOOL checkinfoAvailable = [self.checkinPreferences hasCheckinInfo];
  if (!checkinfoAvailable) {
    FIRMessagingErrorCode errorCode = kFIRMessagingErrorCodeRegistrarFailedToCheckIn;
    [self finishWithResult:FIRMessagingTokenOperationError
                     token:nil
                     error:[NSError messagingErrorWithCode:errorCode
                                             failureReason:
                                                 @"Failed to checkin before token registration."]];
    return;
  }

  [self setExecuting:YES];

  [[FIRInstallations installations]
      authTokenWithCompletion:^(FIRInstallationsAuthTokenResult *_Nullable tokenResult,
                                NSError *_Nullable error) {
        if (tokenResult.authToken.length > 0) {
          self.FISAuthToken = tokenResult.authToken;
          [self performTokenOperation];
        } else {
          [self finishWithResult:FIRMessagingTokenOperationError token:nil error:error];
        }
      }];
}

- (void)finishWithResult:(FIRMessagingTokenOperationResult)result
                   token:(nullable NSString *)token
                   error:(nullable NSError *)error {
  // Add a check to prevent this finish from being called more than once.
  if (self.isFinished) {
    return;
  }
  self.dataTask = nil;
  _result = result;
  for (FIRMessagingTokenOperationCompletion completionHandler in _completionHandlers) {
    completionHandler(result, token, error);
  }

  [self setExecuting:NO];
  [self setFinished:YES];
}

- (void)cancel {
  [super cancel];
  [self.dataTask cancel];
  [self finishWithResult:FIRMessagingTokenOperationCancelled token:nil error:nil];
}

- (void)performTokenOperation {
}

- (NSMutableURLRequest *)tokenRequest {
  NSString *authHeader =
      [FIRMessagingTokenOperation HTTPAuthHeaderFromCheckin:self.checkinPreferences];
  return [[self class] requestWithAuthHeader:authHeader FISAuthToken:self.FISAuthToken];
}

#pragma mark - Request Construction

+ (NSMutableURLRequest *)requestWithAuthHeader:(NSString *)authHeaderString
                                  FISAuthToken:(NSString *)FISAuthToken {
  NSURL *url = [NSURL URLWithString:FIRMessagingTokenRegisterServer()];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

  // Add HTTP headers
  [request setValue:authHeaderString forHTTPHeaderField:@"Authorization"];
  [request setValue:FIRMessagingAppIdentifier() forHTTPHeaderField:@"app"];
  if (FISAuthToken) {
    [request setValue:FISAuthToken forHTTPHeaderField:@"x-goog-firebase-installations-auth"];
  }
  request.HTTPMethod = @"POST";
  return request;
}

+ (NSMutableArray<FIRInstanceIDURLQueryItem *> *)standardQueryItemsWithDeviceID:(NSString *)deviceID
                                                                          scope:(NSString *)scope {
  NSMutableArray<FIRInstanceIDURLQueryItem *> *queryItems = [NSMutableArray arrayWithCapacity:8];

  // E.g. X-osv=10.2.1
<<<<<<< Updated upstream:Pods/FirebaseInstanceID/Firebase/InstanceID/FIRInstanceIDTokenOperation.m
  NSString *systemVersion = FIRInstanceIDOperatingSystemVersion();
  [queryItems addObject:[FIRInstanceIDURLQueryItem queryItemWithName:@"X-osv" value:systemVersion]];
=======
  NSString *systemVersion = [GULAppEnvironmentUtil systemVersion];
  [queryItems addObject:[NSURLQueryItem queryItemWithName:@"X-osv" value:systemVersion]];
>>>>>>> Stashed changes:Pods/FirebaseMessaging/FirebaseMessaging/Sources/Token/FIRMessagingTokenOperation.m
  // E.g. device=
  if (deviceID) {
    [queryItems addObject:[FIRInstanceIDURLQueryItem queryItemWithName:@"device" value:deviceID]];
  }
  // E.g. X-scope=fcm
  if (scope) {
<<<<<<< Updated upstream:Pods/FirebaseInstanceID/Firebase/InstanceID/FIRInstanceIDTokenOperation.m
    [queryItems addObject:[FIRInstanceIDURLQueryItem queryItemWithName:kFIRInstanceIDParamScope
                                                                 value:scope]];
  }
  // E.g. plat=2
  NSString *platform = [NSString stringWithFormat:@"%ld", (long)kFIRInstanceIDPlatformVersionIOS];
  [queryItems addObject:[FIRInstanceIDURLQueryItem queryItemWithName:@"plat" value:platform]];
  // E.g. app=com.myapp.foo
  NSString *appIdentifier = FIRInstanceIDAppIdentifier();
  [queryItems addObject:[FIRInstanceIDURLQueryItem queryItemWithName:@"app" value:appIdentifier]];
  // E.g. app_ver=1.5
  NSString *appVersion = FIRInstanceIDCurrentAppVersion();
  [queryItems addObject:[FIRInstanceIDURLQueryItem queryItemWithName:@"app_ver" value:appVersion]];
=======
    [queryItems addObject:[NSURLQueryItem queryItemWithName:kFIRMessagingParamScope value:scope]];
  }
  // E.g. plat=2
  NSString *platform = [NSString stringWithFormat:@"%ld", (long)kFIRMessagingPlatformVersionIOS];
  [queryItems addObject:[NSURLQueryItem queryItemWithName:@"plat" value:platform]];
  // E.g. app=com.myapp.foo
  NSString *appIdentifier = FIRMessagingAppIdentifier();
  [queryItems addObject:[NSURLQueryItem queryItemWithName:@"app" value:appIdentifier]];
  // E.g. app_ver=1.5
  NSString *appVersion = FIRMessagingCurrentAppVersion();
  [queryItems addObject:[NSURLQueryItem queryItemWithName:@"app_ver" value:appVersion]];
>>>>>>> Stashed changes:Pods/FirebaseMessaging/FirebaseMessaging/Sources/Token/FIRMessagingTokenOperation.m
  // E.g. X-cliv=fiid-1.2.3
  NSString *fcmLibraryVersion =
      [NSString stringWithFormat:@"fiid-%@", [FIRMessaging FIRMessagingSDKVersion]];
  if (fcmLibraryVersion.length) {
<<<<<<< Updated upstream:Pods/FirebaseInstanceID/Firebase/InstanceID/FIRInstanceIDTokenOperation.m
    FIRInstanceIDURLQueryItem *gcmLibVersion =
        [FIRInstanceIDURLQueryItem queryItemWithName:kFIRInstanceIDParamFCMLibVersion
                                               value:fcmLibraryVersion];
=======
    NSURLQueryItem *gcmLibVersion =
        [NSURLQueryItem queryItemWithName:kFIRMessagingParamFCMLibVersion value:fcmLibraryVersion];
>>>>>>> Stashed changes:Pods/FirebaseMessaging/FirebaseMessaging/Sources/Token/FIRMessagingTokenOperation.m
    [queryItems addObject:gcmLibVersion];
  }

  return queryItems;
}

<<<<<<< Updated upstream:Pods/FirebaseInstanceID/Firebase/InstanceID/FIRInstanceIDTokenOperation.m
- (NSArray<FIRInstanceIDURLQueryItem *> *)queryItemsWithInstanceID:(NSString *)instanceID {
  return @[ [FIRInstanceIDURLQueryItem queryItemWithName:kFIRInstanceIDParamInstanceID
                                                   value:instanceID] ];
}

#pragma mark - HTTP Header
=======
#pragma mark -  Header
>>>>>>> Stashed changes:Pods/FirebaseMessaging/FirebaseMessaging/Sources/Token/FIRMessagingTokenOperation.m

+ (NSString *)HTTPAuthHeaderFromCheckin:(FIRMessagingCheckinPreferences *)checkin {
  NSString *deviceID = checkin.deviceID;
  NSString *secret = checkin.secretToken;
  return [NSString stringWithFormat:@"AidLogin %@:%@", deviceID, secret];
}
@end
