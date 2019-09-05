//
//  VoiceItAPITwo.h
//  VoiceItApi2IosSDK
//
//  Created by Armaan Bindra on 3/7/17.
//  Copyright © 2017 Armaan Bindra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "MainNavigationController.h"
#import "VoiceVerificationViewController.h"
#import "FaceVerificationViewController.h"
#import "VideoVerificationViewController.h"
#import "VoiceIdentificationViewController.h"
#import "FaceIdentificationViewController.h"
#import "VideoIdentificationViewController.h"

@import MobileCoreServices;

@interface VoiceItAPITwo : NSObject
// Properties
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *apiToken;
@property (nonatomic, strong) NSString *authHeader;
@property (nonatomic, strong) NSString *boundary;
@property (nonatomic, strong) UIViewController * masterViewController;

#pragma mark - Constructor
- (id)init:(UIViewController *)masterViewController host:(NSString *)host apiKey:(NSString *)apiKey apiToken:(NSString *) apiToken;
- (id)init:(UIViewController *)masterViewController host:(NSString *)host apiKey:(NSString *)apiKey apiToken:(NSString *) apiToken styles:(NSMutableDictionary *) styles;

#pragma mark - User API Calls
- (void)getAllUsers:(void (^)(NSString *))callback;
- (void)getPhrases:(NSString *)contentLanguage callback:(void (^)(NSString *))callback;
- (void)createUser:(void (^)(NSString *))callback;
- (void)checkUserExists:(NSString *)userId callback:(void (^)(NSString *))callback;
- (void)getGroupsForUser:(NSString *)userId callback:(void (^)(NSString *))callback;
- (void)deleteUser: (NSString *)userId callback:(void (^)(NSString *))callback;

#pragma mark - Group API Calls
- (void)getAllGroups:(void (^)(NSString *))callback;
- (void)getGroup:(NSString *)groupId callback:(void (^)(NSString *))callback;
- (void)groupExists:(NSString *)groupId callback:(void (^)(NSString *))callback;
- (void)createGroup:(void (^)(NSString *))callback;
- (void)createGroup:(NSString *)description callback:(void (^)(NSString *))callback;
- (void)addUserToGroup:(NSString *)groupId userId:(NSString *)userId callback:(void (^)(NSString *))callback;
- (void)removeUserFromGroup:(NSString *)groupId userId:(NSString *)userId callback:(void (^)(NSString *))callback;
- (void)deleteGroup: (NSString *)groupId callback:(void (^)(NSString *))callback;

#pragma mark - Enrollment API Calls
- (void)getAllVoiceEnrollments:(NSString *)userId callback:(void (^)(NSString *))callback;
- (void)getAllFaceEnrollments:(NSString *)userId callback:(void (^)(NSString *))callback;
- (void)getAllVideoEnrollments:(NSString *)userId callback:(void (^)(NSString *))callback;
- (void)deleteVoiceEnrollment:(NSString *)userId voiceEnrollmentId:(NSInteger)voiceEnrollmentId callback:(void (^)(NSString *))callback;
- (void)deleteFaceEnrollment:(NSString *)userId faceEnrollmentId:(NSInteger)faceEnrollmentId callback:(void (^)(NSString *))callback;
- (void)deleteVideoEnrollment:(NSString *)userId videoEnrollmentId:(NSInteger)videoEnrollmentId callback:(void (^)(NSString *))callback;
- (void)deleteAllVoiceEnrollments: (NSString *)userId callback:(void (^)(NSString *))callback;
- (void)deleteAllFaceEnrollments: (NSString *)userId callback:(void (^)(NSString *))callback;
- (void)deleteAllVideoEnrollments: (NSString *)userId callback:(void (^)(NSString *))callback;
- (void)deleteAllEnrollments: (NSString *)userId callback:(void (^)(NSString *))callback;
- (void)createVoiceEnrollment:(NSString *)userId
              contentLanguage:(NSString*)contentLanguage
                    audioPath:(NSString*)audioPath
                       phrase:(NSString*)phrase
                     callback:(void (^)(NSString *))callback;

- (void)createFaceEnrollment:(NSString *)userId
                   videoPath:(NSString*)videoPath
                    callback:(void (^)(NSString *))callback;

- (void)createVideoEnrollment:(NSString *)userId
              contentLanguage:(NSString*)contentLanguage
                    imageData:(NSData*)imageData
                    audioPath:(NSString*)audioPath
                       phrase:(NSString*)phrase
                     callback:(void (^)(NSString *))callback;

- (void)createVideoEnrollment:(NSString *)userId
              contentLanguage:(NSString*)contentLanguage
                    videoPath:(NSString*)videoPath
                       phrase:(NSString*)phrase
                     callback:(void (^)(NSString *))callback;

#pragma mark - Verification API Calls

- (void)voiceVerification:(NSString *)userId
          contentLanguage:(NSString*)contentLanguage
                audioPath:(NSString*)audioPath
                   phrase:(NSString*)phrase
                 callback:(void (^)(NSString *))callback;

- (void)faceVerification:(NSString *)userId
               videoPath:(NSString*)videoPath
                callback:(void (^)(NSString *))callback;

- (void)faceVerification:(NSString *)userId
               imageData:(NSData*)imageData
                callback:(void (^)(NSString *))callback;

- (void)videoVerification:(NSString *)userId
          contentLanguage:(NSString*)contentLanguage
                videoPath:(NSString*)videoPath
                  phrase:(NSString*)phrase
                 callback:(void (^)(NSString *))callback;

- (void)videoVerification:(NSString *)userId
          contentLanguage:(NSString*)contentLanguage
                imageData:(NSData*)imageData
                audioPath:(NSString*)audioPath
                   phrase:(NSString*)phrase
                 callback:(void (^)(NSString *))callback;

#pragma mark - Identification API Calls
- (void)voiceIdentification:(NSString *)groupId
            contentLanguage:(NSString*)contentLanguage
                  audioPath:(NSString*)audioPath
                     phrase:(NSString*)phrase
                   callback:(void (^)(NSString *))callback;

- (void)faceIdentification:(NSString *)groupId
                 videoPath:(NSString*)videoPath
                  callback:(void (^)(NSString *))callback;

- (void)faceIdentification:(NSString *)groupId
               imageData:(NSData*)imageData
                callback:(void (^)(NSString *))callback;

- (void)videoIdentification:(NSString *)groupId
            contentLanguage:(NSString*)contentLanguage
                  videoPath:(NSString*)videoPath
                     phrase:(NSString*)phrase
                   callback:(void (^)(NSString *))callback;

- (void)videoIdentification:(NSString *)groupId
          contentLanguage:(NSString*)contentLanguage
                imageData:(NSData*)imageData
                audioPath:(NSString*)audioPath
                   phrase:(NSString*)phrase
                 callback:(void (^)(NSString *))callback;

#pragma mark - Encapsulated Enrollment Methods

- (void)encapsulatedVoiceEnrollUser:(NSString *)userId
                    contentLanguage:(NSString*)contentLanguage
                   voicePrintPhrase:(NSString*)voicePrintPhrase
           userEnrollmentsCancelled:(void (^)(void))userEnrollmentsCancelled
              userEnrollmentsPassed:(void (^)(void))userEnrollmentsPassed;

- (void)encapsulatedFaceEnrollUser:(NSString *)userId
          userEnrollmentsCancelled:(void (^)(void))userEnrollmentsCancelled
             userEnrollmentsPassed:(void (^)(void))userEnrollmentsPassed;

- (void)encapsulatedVideoEnrollUser:(NSString *)userId
                    contentLanguage:(NSString*)contentLanguage
                   voicePrintPhrase:(NSString*)voicePrintPhrase
           userEnrollmentsCancelled:(void (^)(void))userEnrollmentsCancelled
              userEnrollmentsPassed:(void (^)(void))userEnrollmentsPassed;

#pragma mark - Encapsulated Verification Methods

- (void)encapsulatedVoiceVerification:(NSString *)userId
                      contentLanguage:(NSString*)contentLanguage
                     voicePrintPhrase:(NSString*)voicePrintPhrase
            userVerificationCancelled:(void (^)(void))userVerificationCancelled
           userVerificationSuccessful:(void (^)(float, NSString *))userVerificationSuccessful
               userVerificationFailed:(void (^)(float, NSString *))userVerificationFailed;

- (void)encapsulatedVoiceVerification:(NSString *)userId
                      contentLanguage:(NSString*)contentLanguage
                     voicePrintPhrase:(NSString*)voicePrintPhrase
                      numFailsAllowed:(int)numFailsAllowed
            userVerificationCancelled:(void (^)(void))userVerificationCancelled
           userVerificationSuccessful:(void (^)(float, NSString *))userVerificationSuccessful
               userVerificationFailed:(void (^)(float, NSString *))userVerificationFailed;

- (void)encapsulatedFaceVerification:(NSString *)userId
                 doLivenessDetection:(bool)doLivenessDetection
           userVerificationCancelled:(void (^)(void))userVerificationCancelled
          userVerificationSuccessful:(void (^)(float, NSString *))userVerificationSuccessful
              userVerificationFailed:(void (^)(float, NSString *))userVerificationFailed;

- (void)encapsulatedFaceVerification:(NSString *)userId
                 doLivenessDetection:(bool)doLivenessDetection
                     numFailsAllowed:(int)numFailsAllowed
       livenessChallengeFailsAllowed:(int)livenessChallengeFailsAllowed
           userVerificationCancelled:(void (^)(void))userVerificationCancelled
          userVerificationSuccessful:(void (^)(float, NSString *))userVerificationSuccessful
              userVerificationFailed:(void (^)(float, NSString *))userVerificationFailed;

- (void)encapsulatedVideoVerification:(NSString *)userId
                      contentLanguage:(NSString*)contentLanguage
                     voicePrintPhrase:(NSString*)voicePrintPhrase
                  doLivenessDetection:(bool)doLivenessDetection
            userVerificationCancelled:(void (^)(void))userVerificationCancelled
           userVerificationSuccessful:(void (^)(float, float, NSString *))userVerificationSuccessful
               userVerificationFailed:(void (^)(float, float, NSString *))userVerificationFailed;

- (void)encapsulatedVideoVerification:(NSString *)userId
                      contentLanguage:(NSString*)contentLanguage
                     voicePrintPhrase:(NSString*)voicePrintPhrase
                  doLivenessDetection:(bool)doLivenessDetection
                      numFailsAllowed:(int)numFailsAllowed
         livenessChallengeFailsAllowed:(int)livenessChallengeFailsAllowed
            userVerificationCancelled:(void (^)(void))userVerificationCancelled
           userVerificationSuccessful:(void (^)(float, float, NSString *))userVerificationSuccessful
               userVerificationFailed:(void (^)(float, float, NSString *))userVerificationFailed;

#pragma mark - Encapsulated Identification Methods

- (void)encapsulatedVoiceIdentification:(NSString *)groupId
                        contentLanguage:(NSString*)contentLanguage
                       voicePrintPhrase:(NSString*)voicePrintPhrase
            userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
           userIdentificationSuccessful:(void (^)(float, NSString *, NSString *))userIdentificationSuccessful
               userIdentificationFailed:(void (^)(float, NSString *))userIdentificationFailed;

- (void)encapsulatedVoiceIdentification:(NSString *)groupId
                        contentLanguage:(NSString*)contentLanguage
                       voicePrintPhrase:(NSString*)voicePrintPhrase
                        numFailsAllowed:(int)numFailsAllowed
            userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
           userIdentificationSuccessful:(void (^)(float, NSString *, NSString *))userIdentificationSuccessful
               userIdentificationFailed:(void (^)(float, NSString *))userIdentificationFailed;

- (void)encapsulatedFaceIdentification:(NSString *)groupId
                   doLivenessDetection:(bool)doLivenessDetection
           userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
          userIdentificationSuccessful:(void (^)(float, NSString *, NSString *))userIdentificationSuccessful
              userIdentificationFailed:(void (^)(float, NSString *))userIdentificationFailed;

- (void)encapsulatedFaceIdentification:(NSString *)groupId
                   doLivenessDetection:(bool)doLivenessDetection
                       numFailsAllowed:(int)numFailsAllowed
         livenessChallengeFailsAllowed:(int)livenessChallengeFailsAllowed
           userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
          userIdentificationSuccessful:(void (^)(float, NSString *, NSString *))userIdentificationSuccessful
              userIdentificationFailed:(void (^)(float, NSString *))userIdentificationFailed;

- (void)encapsulatedVideoIdentification:(NSString *)groupId
                        contentLanguage:(NSString*)contentLanguage
                       voicePrintPhrase:(NSString*)voicePrintPhrase
                    doLivenessDetection:(bool)doLivenessDetection
            userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
           userIdentificationSuccessful:(void (^)(float, float, NSString *, NSString *))userIdentificationSuccessful
               userIdentificationFailed:(void (^)(float, float, NSString *))userIdentificationFailed;

- (void)encapsulatedVideoIdentification:(NSString *)groupId
                        contentLanguage:(NSString*)contentLanguage
                       voicePrintPhrase:(NSString*)voicePrintPhrase
                    doLivenessDetection:(bool)doLivenessDetection
                        numFailsAllowed:(int)numFailsAllowed
          livenessChallengeFailsAllowed:(int)livenessChallengeFailsAllowed
            userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
           userIdentificationSuccessful:(void (^)(float, float, NSString *, NSString *))userIdentificationSuccessful
               userIdentificationFailed:(void (^)(float, float, NSString *))userIdentificationFailed;

@end
