<<<<<<< Updated upstream
# Firebase iOS Open Source Development
 [![Actions Status][gh-auth-badge]][gh-actions]
 [![Actions Status][gh-core-badge]][gh-actions]
 [![Actions Status][gh-datatransport-badge]][gh-actions]
 [![Actions Status][gh-dynamiclinks-badge]][gh-actions]
 [![Actions Status][gh-firebasepod-badge]][gh-actions]
 [![Actions Status][gh-firestore-badge]][gh-actions]
 [![Actions Status][gh-interop-badge]][gh-actions]
 [![Actions Status][gh-messaging-badge]][gh-actions]
 [![Actions Status][gh-storage-badge]][gh-actions]
 [![Actions Status][gh-symbolcollision-badge]][gh-actions]
 [![Actions Status][gh-zip-badge]][gh-actions]
 [![Travis](https://travis-ci.org/firebase/firebase-ios-sdk.svg?branch=master)](https://travis-ci.org/firebase/firebase-ios-sdk)

This repository contains all Firebase iOS SDK source except FirebaseAnalytics,
FirebasePerformance, and FirebaseML.

The repository also includes GoogleUtilities source. The
[GoogleUtilities](GoogleUtilities/README.md) pod is
a set of utilities used by Firebase and other Google products.

Firebase is an app development platform with tools to help you build, grow and
monetize your app. More information about Firebase can be found at
[https://firebase.google.com](https://firebase.google.com).

## Installation

See the three subsections for details about three different installation methods.
1. [Standard pod install](README.md#standard-pod-install)
1. [Installing from the GitHub repo](README.md#installing-from-github)
1. [Experimental Carthage](README.md#carthage-ios-only)

### Standard pod install

Go to
[https://firebase.google.com/docs/ios/setup](https://firebase.google.com/docs/ios/setup).

### Installing from GitHub

For releases starting with 5.0.0, the source for each release is also deployed
to CocoaPods master and available via standard
[CocoaPods Podfile syntax](https://guides.cocoapods.org/syntax/podfile.html#pod).

These instructions can be used to access the Firebase repo at other branches,
tags, or commits.

#### Background

See
[the Podfile Syntax Reference](https://guides.cocoapods.org/syntax/podfile.html#pod)
for instructions and options about overriding pod source locations.

#### Accessing Firebase Source Snapshots

All of the official releases are tagged in this repo and available via CocoaPods. To access a local
source snapshot or unreleased branch, use Podfile directives like the following:

To access FirebaseFirestore via a branch:
```
pod 'FirebaseCore', :git => 'https://github.com/firebase/firebase-ios-sdk.git', :branch => 'master'
pod 'FirebaseFirestore', :git => 'https://github.com/firebase/firebase-ios-sdk.git', :branch => 'master'
```

To access FirebaseMessaging via a checked out version of the firebase-ios-sdk repo do:

```
pod 'FirebaseCore', :path => '/path/to/firebase-ios-sdk'
pod 'FirebaseMessaging', :path => '/path/to/firebase-ios-sdk'
```

### Carthage (iOS only)

Instructions for the experimental Carthage distribution are at
[Carthage](Carthage.md).

### Rome

Instructions for installing binary frameworks via
[Rome](https://github.com/CocoaPods/Rome) are at [Rome](Rome.md).

### Using Firebase from a Framework or a library

[Using Firebase from a Framework or a library](docs/firebase_in_libraries.md)
=======
[![Version](https://img.shields.io/cocoapods/v/GoogleUtilities.svg?style=flat)](https://cocoapods.org/pods/GoogleUtilities)
[![License](https://img.shields.io/cocoapods/l/GoogleUtilities.svg?style=flat)](https://cocoapods.org/pods/GoogleUtilities)
[![Platform](https://img.shields.io/cocoapods/p/GoogleUtilities.svg?style=flat)](https://cocoapods.org/pods/GoogleUtilities)

[![Actions Status][gh-google-utilities-badge]][gh-actions]

# GoogleUtilities

GoogleUtilities provides a set of utilities for Firebase and other Google SDKs for Apple platform
development.

The utilities are not directly supported for non-Google library usage.

## Integration Testing
These instructions apply to minor and patch version updates. Major versions need
a customized adaptation.

After the CI is green:
* Update the version in the podspec to match the latest entry in the [CHANGELOG.md](CHANGELOG.md)
* Checkout the `main` branch and ensure it is up to date
  ```console
  git checkout main
  git pull
  ```
* Add the CocoaPods tag (`{version}` will be the latest version in the [podspec](GoogleUtilities.podspec#L3))
  ```console
  git tag CocoaPods-{version}
  git push origin CocoaPods-{version}
  ```
* Push the podspec to the designated repo
  * If this version of GoogleUtilities is intended to launch **before or with** the next Firebase release:
    <details>
    <summary>Push to <b>SpecsStaging</b></summary>

    ```console
    pod repo push --skip-tests staging GoogleUtilities.podspec
    ```

    If the command fails with `Unable to find the 'staging' repo.`, add the staging repo with:
    ```console
    pod repo add staging git@github.com:firebase/SpecsStaging.git
    ```
    </details>
  * Otherwise:
    <details>
    <summary>Push to <b>SpecsDev</b></summary>

    ```console
    pod repo push --skip-tests dev GoogleUtilities.podspec
    ```

    If the command fails with `Unable to find the 'dev' repo.`, add the dev repo with:
    ```console
    pod repo add dev git@github.com:firebase/SpecsDev.git
    ```
    </details>
* Run Firebase CI by waiting until next nightly or adding a PR that touches `Gemfile`.
* On google3, run copybara using the command below. Then, start a global TAP on the generated CL. Deflake as needed.
  ```console
  third_party/firebase/ios/Releases/run_copy_bara.py --directory GoogleUtilities --branch main
  ```

## Publishing
The release process is as follows:
1. [Tag and release for Swift PM](#swift-package-manager)
2. [Publish to CocoaPods](#cocoapods)
3. [Perform post release cleanup](#post-release-cleanup)

### Swift Package Manager
  By creating and [pushing a tag](https://github.com/google/GoogleUtilities/tags)
  for Swift PM, the newly tagged version will be immediately released for public use.
  Given this, please verify the intended time of release for Swift PM.
  * Add a version tag for Swift PM
  ```console
  git tag {version}
  git push origin {version}
  ```
  *Note: Ensure that any inflight PRs that depend on the new `GoogleUtilities` version are updated to point to the
  newly tagged version rather than a checksum.*

### CocoaPods
* Publish the newly versioned pod to CocoaPods

  It's recommended to point to the `GoogleUtilities.podspec` in `staging` to make sure the correct spec is being published.
  ```console
  pod trunk push ~/.cocoapods/repos/staging/GoogleUtilities/7.4.0/GoogleUtilities.podspec
  ```
  *Note: In some cases, it may be acceptable to `pod trunk push` with the `--skip-tests` flag. Please double check with
  the maintainers before doing so.*

  The pod push was successful if the above command logs: `🚀  GoogleUtilities ({version}) successfully published`.
  In addition, a new commit that publishes the new version (co-authored by [CocoaPodsAtGoogle](https://github.com/CocoaPodsAtGoogle))
  should appear in the [CocoaPods specs repo](https://github.com/CocoaPods/Specs). Last, the latest version should be displayed
  on [GoogleUtilities's CocoaPods page](https://cocoapods.org/pods/GoogleUtilities).

  *Don't forget to perform the [post release cleanup](#post-release-cleanup)!*

### Post Release Cleanup
* Clean up [SpecsStaging](https://github.com/firebase/SpecsStaging):
  ```console
  cd ~/path/to/SpecsStaging/
  git checkout master
  git pull
  git rm -rf GoogleUtilities/
  git commit -m "Post GoogleUtilities {version} release cleanup"
  git push
  ```
>>>>>>> Stashed changes

## Development

To develop in this repository, ensure that you have at least the following software:

<<<<<<< Updated upstream
  * Xcode 10.1 (or later)
  * CocoaPods 1.7.2 (or later)
=======
  * Xcode 12.0 (or later)
  * CocoaPods 1.10.0 (or later)
>>>>>>> Stashed changes
  * [CocoaPods generate](https://github.com/square/cocoapods-generate)

For the pod that you want to develop:

`pod gen GoogleUtilities.podspec --local-sources=./ --auto-open --platforms=ios`

Note: If the CocoaPods cache is out of date, you may need to run
`pod repo update` before the `pod gen` command.

Note: Set the `--platforms` option to `macos` or `tvos` to develop/test for
those platforms. Since 10.2, Xcode does not properly handle multi-platform
CocoaPods workspaces.

### Development for Catalyst
* `pod gen GoogleUtilities.podspec --local-sources=./ --auto-open --platforms=ios`
* Check the Mac box in the App-iOS Build Settings
* Sign the App in the Settings Signing & Capabilities tab
* Click Pods in the Project Manager
* Add Signing to the iOS host app and unit test targets
* Select the Unit-unit scheme
* Run it to build and test

<<<<<<< Updated upstream
### Adding a New Firebase Pod

See [AddNewPod.md](AddNewPod.md).
=======
Alternatively disable signing in each target:
* Go to Build Settings tab
* Click `+`
* Select `Add User-Defined Setting`
* Add `CODE_SIGNING_REQUIRED` setting with a value of `NO`
>>>>>>> Stashed changes

### Code Formatting

To ensure that the code is formatted consistently, run the script
[./scripts/style.sh](https://github.com/firebase/firebase-ios-sdk/blob/master/scripts/style.sh)
before creating a PR.

Travis will verify that any code changes are done in a style compliant way. Install
`clang-format` and `swiftformat`.
These commands will get the right versions:

<<<<<<< Updated upstream
```
brew upgrade https://raw.githubusercontent.com/Homebrew/homebrew-core/c6f1cbd/Formula/clang-format.rb
brew upgrade https://raw.githubusercontent.com/Homebrew/homebrew-core/c13eda8/Formula/swiftformat.rb
=======
```console
brew install clang-format@12
brew install mint
>>>>>>> Stashed changes
```

Note: if you already have a newer version of these installed you may need to
`brew switch` to this version.

To update this section, find the versions of clang-format and swiftformat.rb to
match the versions in the CI failure logs
[here](https://github.com/Homebrew/homebrew-core/tree/master/Formula).

### Running Unit Tests

Select a scheme and press Command-u to build a component and run its unit tests.

<<<<<<< Updated upstream
#### Viewing Code Coverage (Deprecated)

First, make sure that [xcov](https://github.com/nakiostudio/xcov) is installed with `gem install xcov`.

After running the `AllUnitTests_iOS` scheme in Xcode, execute
`xcov --workspace Firebase.xcworkspace --scheme AllUnitTests_iOS --output_directory xcov_output`
at Example/ in the terminal. This will aggregate the coverage, and you can run `open xcov_output/index.html` to see the results.

### Running Sample Apps
In order to run the sample apps and integration tests, you'll need valid
`GoogleService-Info.plist` files for those samples. The Firebase Xcode project contains dummy plist
files without real values, but can be replaced with real plist files. To get your own
`GoogleService-Info.plist` files:

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new Firebase project, if you don't already have one
3. For each sample app you want to test, create a new Firebase app with the sample app's bundle
identifier (e.g. `com.google.Database-Example`)
4. Download the resulting `GoogleService-Info.plist` and replace the appropriate dummy plist file
(e.g. in [Example/Database/App/](Example/Database/App/));

Some sample apps like Firebase Messaging ([Example/Messaging/App](Example/Messaging/App)) require
special Apple capabilities, and you will have to change the sample app to use a unique bundle
identifier that you can control in your own Apple Developer account.

## Specific Component Instructions
See the sections below for any special instructions for those components.

### Firebase Auth

If you're doing specific Firebase Auth development, see
[the Auth Sample README](FirebaseAuth/Tests/Sample/README.md) for instructions about
building and running the FirebaseAuth pod along with various samples and tests.

### Firebase Database

To run the Database Integration tests, make your database authentication rules
[public](https://firebase.google.com/docs/database/security/quickstart).

### Firebase Storage

To run the Storage Integration tests, follow the instructions in
[FIRStorageIntegrationTests.m](FirebaseStorage/Tests/Integration/FIRStorageIntegrationTests.m).

#### Push Notifications

Push notifications can only be delivered to specially provisioned App IDs in the developer portal.
In order to actually test receiving push notifications, you will need to:

1. Change the bundle identifier of the sample app to something you own in your Apple Developer
account, and enable that App ID for push notifications.
2. You'll also need to
[upload your APNs Provider Authentication Key or certificate to the Firebase Console](https://firebase.google.com/docs/cloud-messaging/ios/certs)
at **Project Settings > Cloud Messaging > [Your Firebase App]**.
3. Ensure your iOS device is added to your Apple Developer portal as a test device.

#### iOS Simulator

The iOS Simulator cannot register for remote notifications, and will not receive push notifications.
In order to receive push notifications, you'll have to follow the steps above and run the app on a
physical device.

## Community Supported Efforts

We've seen an amazing amount of interest and contributions to improve the Firebase SDKs, and we are
very grateful!  We'd like to empower as many developers as we can to be able to use Firebase and
participate in the Firebase community.

### tvOS, macOS, watchOS and Catalyst
Thanks to contributions from the community, many of Firebase SDKs now compile, run unit tests, and work on
tvOS, macOS, watchOS and Catalyst.

For tvOS, checkout the [Sample](Example/tvOSSample).
For watchOS, currently only Messaging and Storage (and their dependencies) have limited support. Checkout the
[Independent Watch App Sample](Example/watchOSSample).

Keep in mind that macOS, tvOS, watchOS and Catalyst are not officially supported by Firebase, and this
repository is actively developed primarily for iOS. While we can catch basic unit test issues with
Travis, there may be some changes where the SDK no longer works as expected on macOS, tvOS or watchOS. If you
encounter this, please [file an issue](https://github.com/firebase/firebase-ios-sdk/issues).

During app setup in the console, you may get to a step that mentions something like "Checking if the app
has communicated with our servers". This relies on Analytics and will not work on macOS/tvOS/watchOS/Catalyst.
**It's safe to ignore the message and continue**, the rest of the SDKs will work as expected.

To install, add a subset of the following to the Podfile:

```
pod 'Firebase/ABTesting'     # No watchOS support yet
pod 'Firebase/Auth'          # No watchOS support yet
pod 'Firebase/Crashlytics'   # No watchOS support yet
pod 'Firebase/Database'      # No watchOS support yet
pod 'Firebase/Firestore'     # No watchOS support yet
pod 'Firebase/Functions'     # No watchOS support yet
pod 'Firebase/Messaging'
pod 'Firebase/RemoteConfig'  # No watchOS support yet
pod 'Firebase/Storage'
```

#### Additional Catalyst Notes

* FirebaseAuth and FirebaseMessaging require adding `Keychain Sharing Capability`
to Build Settings.
* FirebaseFirestore requires signing the
[gRPC Resource target](https://github.com/firebase/firebase-ios-sdk/issues/3500#issuecomment-518741681).

## Roadmap

See [Roadmap](ROADMAP.md) for more about the Firebase iOS SDK Open Source
plans and directions.

=======
>>>>>>> Stashed changes
## Contributing

See [Contributing](CONTRIBUTING.md).

## License

The contents of this repository is licensed under the
[Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

[gh-actions]: https://github.com/firebase/firebase-ios-sdk/actions
<<<<<<< Updated upstream
[gh-auth-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/auth/badge.svg
[gh-core-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/core/badge.svg
[gh-datatransport-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/datatransport/badge.svg
[gh-dynamiclinks-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/dynamiclinks/badge.svg
[gh-firebasepod-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/firebasepod/badge.svg
[gh-firestore-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/firestore/badge.svg
[gh-interop-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/interop/badge.svg
[gh-messaging-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/messaging/badge.svg
[gh-storage-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/storage/badge.svg
[gh-symbolcollision-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/symbolcollision/badge.svg
[gh-zip-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/zip/badge.svg
=======
[gh-google-utilities-badge]: https://github.com/firebase/firebase-ios-sdk/workflows/google-utilities/badge.svg
>>>>>>> Stashed changes
