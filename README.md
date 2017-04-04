<img src="Graphics/VoiceItHeaderImage.png" width="100%" style="width:100%">

[![Version](https://img.shields.io/cocoapods/v/VoiceItApi2IosSDK.svg?style=flat)](http://cocoapods.org/pods/VoiceItApi2IosSDK)
[![License](https://img.shields.io/cocoapods/l/VoiceItApi2IosSDK.svg?style=flat)](http://cocoapods.org/pods/VoiceItApi2IosSDK)
[![Platform](https://img.shields.io/cocoapods/p/VoiceItApi2IosSDK.svg?style=flat)](http://cocoapods.org/pods/VoiceItApi2IosSDK)

## VoiceIt API 2.0 iOS SDK

A library that gives you access to the VoiceIt's New VoiceIt API 2.0 featuring Voice + Face Verification and Identification right from your iOS app.

* [Getting Started](#getting-started)
* [Installation](#installation)
* [API Calls](#api-calls)
  * [Initialization](#initialization)
  * [User API Calls](#user-api-calls)
      * [Get All Users](#get-all-users)
      * [Create User](#create-user)
      * [Get User](#get-user)
      * [Get Groups for User](#get-groups-for-user)
      * [Delete User](#delete-user)
  * [Group API Calls](#group-api-calls)
      * [Get All Groups](#get-all-groups)
      * [Create Group](#create-group)
      * [Get Group](#get-group)
      * [Delete Group](#delete-group)
      * [Group exists](#group-exists)
      * [Add User to Group](#add-user-to-group)
      * [Remove User from Group](#remove-user-from-group)      
  * [Enrollment API Calls](#enrollment-api-calls)
      * [Get All Enrollments for User](#get-all-enrollments-for-user)
      * [Delete Enrollment for User](#delete-enrollment-for-user)
      * [Create Audio Enrollment](#create-audio-enrollment)
      * [Create Video Enrollment](#create-video-enrollment)
  * [Verification API Calls](#verification-api-calls)
      * [Audio Verification](#audio-verification)
      * [Video Verification](#video-verification)
  * [Identification API Calls](#identification-api-calls)
      * [Audio Identification](#audio-identification)
      * [Video Identification](#video-identification)

## Getting Started

Get a Developer Account at <a href="https://siv.voiceprintportal.com/getDeveloperIDTile.jsp" target="_blank">VoiceIt</a> and activate API 2.0 from the settings page, you should now be able view the API Key and Token (as shown below). Also review the HTTP Documentation at <a href="https://api.voiceit.io" target="_blank">api.voiceit.io</a>. All the documentation shows code snippets in both Swift 3 and Objective-C.

<img src="Graphics/Screenshot1.png" alt="API Key and Token" width="400px" />

## Installation

VoiceItApi2IosSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "VoiceItApi2IosSDK"
```

and then run pod install in your terminal

```bash
pod install
```

Also add the following permission keys to your <b>info.plist</b> file like shown below:

* NSCameraUsageDescription - Needed for Face Biometrics
* NSMicrophoneUsageDescription - Needed for Voice Biometrics

<img src="Graphics/Screenshot2.png" alt="API Key and Token" width="400px" style="margin:auto;display:block"/>


## API Calls

### Initialization

#### *Swift*

First import *VoiceItApi2IosSDK* into your Swift file then initialize a reference to the SDK inside a ViewController passing in a reference to the ViewController as the first argument

```swift
import VoiceItApi2IosSDK

class ViewController: UIViewController {
    var myVoiceIt:VoiceItAPITwo?

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Reference to ViewController and API Credentials */
        myVoiceIt  = VoiceItAPITwo(self, apiKey: "API_KEY_HERE", apiToken: "API_TOKEN_HERE")
    }
}
```
#### *Objective-C*

First import *VoiceItAPITwo.h* into your Objective-C file, then initialize a reference to the SDK inside a ViewController passing in a reference to the ViewController as the first argument

```objc
#import "ViewController.h"
#import "VoiceItAPITwo.h"

@interface ViewController ()
    @property VoiceItAPITwo * myVoiceIt;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* Reference to ViewController and API Credentials */
    _myVoiceIt = [[VoiceItAPITwo alloc] init:self apiKey:@"API_KEY_HERE" apiToken:@"API_TOKEN_HERE"];
}
```

### User API Calls

#### Get All Users

Get all the users associated with the apiKey
##### *Swift*
```swift
myVoiceIt?.getAllUsers({
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```
##### *Objective-C*
```objc
[_myVoiceIt getAllUsers:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Create User

Create a new user
##### *Swift*
```swift
myVoiceIt?.createUser({
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```
##### *Objective-C*
```objc
[_myVoiceIt createUser:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Get User

Check whether a user exists for the given userId(begins with 'usr_')
##### *Swift*
```swift
myVoiceIt?.getUser("USER_ID_HERE", callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```
##### *Objective-C*
```objc
[_myVoiceIt getUser:@"USER_ID_HERE" callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Get Groups for User

Get a list of groups that the user with given userId(begins with 'usr_') is a part of
##### *Swift*
```swift
myVoiceIt?.getGroupsForUser("USER_ID_HERE", callback: {
                jsonResponse in
                print("JSON RESPONSE: \(jsonResponse!)")
})
```
##### *Objective-C*
```objc
[_myVoiceIt getGroupsForUser:@"USER_ID_HERE" callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Delete User

Delete user with given userId(begins with 'usr_')
##### *Swift*
```swift
myVoiceIt?.deleteUser("USER_ID_HERE", callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```
##### *Objective-C*
```objc
[_myVoiceIt deleteUser:@"USER_ID_HERE" callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

### Group API Calls

#### Get All Groups

Get all the groups associated with the apiKey
##### *Swift*
```swift
myVoiceIt?.getAllGroups({
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```
##### *Objective-C*
```objc
[_myVoiceIt getAllGroups:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Create Group

Create a new group with the given description
##### *Swift*
```swift
myVoiceIt?.createGroup("A Sample Group Description", callback: {
    jsonResponse in
})
```
##### *Objective-C*
```objc
[_myVoiceIt createGroup:@"A Sample Group Description" callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Get Group

Returns a group for the given groupId(begins with 'grp_')
##### *Swift*
```swift
myVoiceIt?.getGroup("GROUP_ID_HERE", callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```
##### *Objective-C*
```objc
[_myVoiceIt getGroup:@"GROUP_ID_HERE" callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Delete Group

Delete group with given groupId(begins with 'grp_'), note: this call does not delete any users, but simply deletes the group and disassociates the users from the group
##### *Swift*
```swift
myVoiceIt?.deleteUser("USER_ID_HERE", callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```
##### *Objective-C*
```objc
[_myVoiceIt deleteUser:@"USER_ID_HERE" callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Group Exists

Checks if group with given groupId(begins with 'grp_') exists
##### *Swift*
```swift
myVoiceIt?.groupExists("GROUP_ID_HERE", callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```

##### *Objective-C*
```objc
[_myVoiceIt groupExists:@"GROUP_ID_HERE" callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Add User to Group

Adds user with given userId(begins with 'usr_') to group with given groupId(begins with 'grp_')
##### *Swift*
```swift
myVoiceIt?.addUser(toGroup: "GROUP_ID_HERE", userId: "USER_ID_HERE", callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```

##### *Objective-C*
```objc
[_myVoiceIt addUserToGroup:@"GROUP_ID_HERE" userId:@"USER_ID_HERE" callback:^(NSString * jsonResponse){
            NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Remove User from Group

Removes user with given userId(begins with 'usr_') from group with given groupId(begins with 'grp_')
##### *Swift*
```swift
myVoiceIt?.removeUser(fromGroup: "GROUP_ID_HERE", userId: "USER_ID_HERE", callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```

##### *Objective-C*
```objc
[_myVoiceIt removeUserFromGroup:@"GROUP_ID_HERE" userId:@"USER_ID_HERE" callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

### Enrollment API Calls

#### Get All Enrollments for User

Gets all enrollment for user with given userId(begins with 'usr_')
##### *Swift*
```swift
myVoiceIt?.getAllEnrollments(forUser: "USER_ID_HERE", callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```

##### *Objective-C*
```objc
[_myVoiceIt getAllEnrollmentsForUser:@"USER_ID_HERE" callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Delete Enrollment for User

Delete enrollment for user with given userId(begins with 'usr_') and enrollmentId(integer)
##### *Swift*
```swift
myVoiceIt?.deleteEnrollment(forUser: "USER_ID_HERE", enrollmentId: "ENROLLMENT_ID_HERE", callback: {
    jsonResponse in
})
```

##### *Objective-C*
```objc
[_myVoiceIt deleteEnrollmentForUser:@"USER_ID_HERE" enrollmentId:@"ENROLLMENT_ID_HERE" callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
}];
```

#### Create Audio Enrollment

Create audio enrollment for user with given userId(begins with 'usr_') and contentLanguage('en-US','es-ES' etc.). Note: Immediately upon calling this method it records the user saying their VoicePrint phrase for 5 seconds calling the recordingFinished callback first, then it sends the recording to be added as an enrollment and returns the result in the callback
##### *Swift*
```swift
myVoiceIt?.createAudioEnrollment("USER_ID_HERE", contentLanguage: "CONTENT_LANGUAGE_HERE", recordingFinished: {
    print("Audio Enrollment Recording Finished, now waiting for API Call to respond")
}, callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```

##### *Objective-C*
```objc
[_myVoiceIt createAudioEnrollment:@"USER_ID_HERE" contentLanguage: @"CONTENT_LANGUAGE_HERE" recordingFinished:^(void){
    NSLog(@"Audio Enrollment Recording Finished, now waiting for API Call to respond");
} callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
} ];
```

#### Create Video Enrollment

Create video enrollment for user with given userId(begins with 'usr_') and contentLanguage('en-US','es-ES' etc.). Note: Immediately upon calling this method it displays the camera and starts recording a video of the user saying their VoicePrint phrase for 5 seconds calling the recordingFinished callback first, then it sends the recording to be added as an enrollment and returns the result in the callback
##### *Swift*
```swift
myVoiceIt?.createVideoEnrollment("USER_ID_HERE", contentLanguage: "CONTENT_LANGUAGE_HERE", recordingFinished: {
    print("Video Enrollment Recording Finished, now waiting for API Call to respond")
}, callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```

##### *Objective-C*
```objc
[_myVoiceIt createVideoEnrollment:@"USER_ID_HERE" contentLanguage: @"CONTENT_LANGUAGE_HERE" recordingFinished:^(void){
    NSLog(@"Video Enrollment Recording Finished, now waiting for API Call to respond");
} callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
} ];
```

#### Audio Verification

Verify user with the given userId(begins with 'usr_') and contentLanguage('en-US','es-ES' etc.). Note: Immediately upon calling this method it records the user saying their VoicePrint phrase for 5 seconds calling the recordingFinished callback first, then it sends the recording to be verified and returns the resulting confidence in the callback
##### *Swift*
```swift
myVoiceIt?.audioVerification("USER_ID_HERE", contentLanguage: "CONTENT_LANGUAGE_HERE", recordingFinished: {
    print("Audio Verification Recording Finished, now waiting for API Call to respond")
}, callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```

##### *Objective-C*
```objc
[_myVoiceIt audioVerification:@"USER_ID_HERE" contentLanguage:@"CONTENT_LANGUAGE_HERE" recordingFinished:^(void){
    NSLog(@"Audio Verification Recording Finished, now waiting for API Call to respond");
} callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
} ];
```

#### Video Verification

Verify user with given userId(begins with 'usr_') and contentLanguage('en-US','es-ES' etc.). Note: Immediately upon calling this method it displays the camera and starts recording a video of the user saying their VoicePrint phrase for 5 seconds calling the recordingFinished callback first, then it sends the recording to be added as an enrollment and returns the result in the callback
##### *Swift*
```swift
myVoiceIt?.videoVerification("USER_ID_HERE", contentLanguage: "CONTENT_LANGUAGE_HERE", recordingFinished: {
    print("Video Verification Recording Finished, now waiting for API Call to respond")
}, callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```

##### *Objective-C*
```objc
[_myVoiceIt videoVerification:@"USER_ID_HERE" contentLanguage:@"CONTENT_LANGUAGE_HERE" recordingFinished:^(void){
    NSLog(@"Video Verification Recording Finished, now waiting for API Call to respond");
} callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
} ];
```

#### Audio Identification

Identify user inside group with the given groupId(begins with 'grp_') and contentLanguage('en-US','es-ES' etc.). Note: Immediately upon calling this method it records the user saying their VoicePrint phrase for 5 seconds calling the recordingFinished callback first, then it sends the recording to be identified and returns the found userId and confidence in the callback
##### *Swift*
```swift
myVoiceIt?.audioIdentification("GROUP_ID_HERE", contentLanguage: "CONTENT_LANGUAGE_HERE", recordingFinished: {
    print("Audio Identification Recording Finished, now waiting for API Call to respond")
}, callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```

##### *Objective-C*
```objc
[_myVoiceIt audioIdentification:@"GROUP_ID_HERE" contentLanguage:@"CONTENT_LANGUAGE_HERE" recordingFinished:^(void){
    NSLog(@"Audio Identification Recording Finished, now waiting for API Call to respond");
} callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
} ];
```

#### Video Identification

Identify user inside group with the given groupId(begins with 'grp_') and contentLanguage('en-US','es-ES' etc.). Note: Immediately upon calling this method it displays the camera and starts recording a video of the user saying their VoicePrint phrase for 5 seconds calling the recordingFinished callback first, , then it sends the recording to be identified and returns the found userId and voice and face confidence in the callback
##### *Swift*
```swift
myVoiceIt?.videoIdentification("GROUP_ID_HERE", contentLanguage: "CONTENT_LANGUAGE_HERE", recordingFinished: {
    print("Video Identification Recording Finished, now waiting for API Call to respond")
}, callback: {
    jsonResponse in
    print("JSON RESPONSE: \(jsonResponse!)")
})
```

##### *Objective-C*
```objc
[_myVoiceIt videoIdentification:@"GROUP_ID_HERE" contentLanguage:@"CONTENT_LANGUAGE_HERE" recordingFinished:^(void){
    NSLog(@"Video Identification Recording Finished, now waiting for API Call to respond");
} callback:^(NSString * jsonResponse){
    NSLog(@"JSONResponse: %@", jsonResponse);
} ];
```

## Author

armaanbindra, armaan.bindra@voiceit-tech.com

## License

VoiceItApi2IosSDK is available under the MIT license. See the LICENSE file for more info.
