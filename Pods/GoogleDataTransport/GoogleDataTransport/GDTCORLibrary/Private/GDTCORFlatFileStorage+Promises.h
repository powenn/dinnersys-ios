/*
<<<<<<< Updated upstream:Pods/FirebaseMessaging/FirebaseMessaging/Sources/FIRMessagingDelayedMessageQueue.h
 * Copyright 2017 Google
=======
 * Copyright 2020 Google LLC
>>>>>>> Stashed changes:Pods/GoogleDataTransport/GoogleDataTransport/GDTCORLibrary/Private/GDTCORFlatFileStorage+Promises.h
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

#import "GoogleDataTransport/GDTCORLibrary/Private/GDTCORFlatFileStorage.h"

<<<<<<< Updated upstream:Pods/FirebaseMessaging/FirebaseMessaging/Sources/FIRMessagingDelayedMessageQueue.h
@class GtalkDataMessageStanza;
@class FIRMessagingRmqManager;
=======
@class FBLPromise<ValueType>;
>>>>>>> Stashed changes:Pods/GoogleDataTransport/GoogleDataTransport/GDTCORLibrary/Private/GDTCORFlatFileStorage+Promises.h

@protocol FIRMessagingRmqScanner;

<<<<<<< Updated upstream:Pods/FirebaseMessaging/FirebaseMessaging/Sources/FIRMessagingDelayedMessageQueue.h
typedef void (^FIRMessagingSendDelayedMessagesHandler)(NSArray *messages);

@interface FIRMessagingDelayedMessageQueue : NSObject
=======
/// The category extends `GDTCORFlatFileStorage` API with `GDTCORStoragePromiseProtocol` methods.
@interface GDTCORFlatFileStorage (Promises) <GDTCORStoragePromiseProtocol>
>>>>>>> Stashed changes:Pods/GoogleDataTransport/GoogleDataTransport/GDTCORLibrary/Private/GDTCORFlatFileStorage+Promises.h

- (instancetype)initWithRmqScanner:(id<FIRMessagingRmqScanner>)rmqScanner
        sendDelayedMessagesHandler:
            (FIRMessagingSendDelayedMessagesHandler)sendDelayedMessagesHandler;

- (BOOL)queueMessage:(GtalkDataMessageStanza *)message;

- (NSArray *)removeDelayedMessages;

@end
