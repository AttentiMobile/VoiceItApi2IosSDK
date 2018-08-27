//
//  VoiceItApi2IosSDK_Test.swift
//  VoiceItApi2IosSDK_Test
//
//  Created by Armaan Bindra on 8/26/18.
//  Copyright © 2018 armaanbindra. All rights reserved.s

import UIKit
import XCTest

class VoiceItApi2IosSDK_Test: VoiceItTest {
    var usersToDelete = [UserResponse]()
    var groupsToDelete = [GroupResponse]()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        print("TEARING DOWN...")
        for user in self.usersToDelete {
            self.myVoiceIt?.deleteUser(user.userId, callback: { jR in print(jR!) })
        }
        for group in self.groupsToDelete {
            self.myVoiceIt?.deleteGroup(group.groupId, callback: { jR in print(jR!) })
        }
        TestHelper.deleteTempFiles()
    }
    
    func testUsers() {
        print("TEST USER API CALLS")
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Get All Users"))
        expectations.append(XCTestExpectation(description: "Test Create User"))
        expectations.append(XCTestExpectation(description: "Test Check User Exists"))
        expectations.append(XCTestExpectation(description: "Test Get Groups For User"))
        expectations.append(XCTestExpectation(description: "Test Delete User"))
        
        print("\tTEST GET ALL USERS")
        self.myVoiceIt?.getAllUsers({
            jsonResponse in
            VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: jsonResponse!)
            expectations[0].fulfill()
        })
        
        print("\tTEST CREATE USER")
        self.myVoiceIt?.createUser({
            createUserResponse in
            let userResponse = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
            self.usersToDelete.append(userResponse!)
            XCTAssertEqual(userResponse?.responseCode, "SUCC")
            XCTAssertEqual(userResponse?.status, 201)
            expectations[1].fulfill()
            print("\tTEST CHECK USER EXISTS")
            self.myVoiceIt?.checkUserExists(userResponse?.userId, callback: {
                checkUserExistsResponse in
                VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: checkUserExistsResponse!)
                expectations[2].fulfill()
                print("\tTEST GET GROUPS FOR USER")
                self.myVoiceIt?.getGroupsForUser(userResponse?.userId, callback: {
                    getGroupsForUserResponse in
                    VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: getGroupsForUserResponse!)
                    expectations[3].fulfill()
                    print("\tTEST DELETE USER")
                    self.myVoiceIt?.deleteUser(userResponse?.userId, callback: {
                        deleteUserResponse in
                        VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: deleteUserResponse!)
                        expectations[4].fulfill()
                    })
                })
            })
      })
      wait(for: expectations, timeout: TIMEOUT)
    }
    
    func testGroups() {
        print("TEST GROUP API CALLS")
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Get All Groups"))
        expectations.append(XCTestExpectation(description: "Test Create Group"))
        expectations.append(XCTestExpectation(description: "Test Get Group"))
        expectations.append(XCTestExpectation(description: "Test Group Exists"))
        expectations.append(XCTestExpectation(description: "Test Add User To Group"))
        expectations.append(XCTestExpectation(description: "Test Remove User From Group"))
        expectations.append(XCTestExpectation(description: "Test Delete Group"))
        
        print("\tTEST GET ALL GROUPS")
        myVoiceIt?.getAllGroups({
            jsonResponse in
            VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: jsonResponse!)
            expectations[0].fulfill()
        })
        
        print("\tTEST CREATE GROUP")
        myVoiceIt?.createGroup("Test Group", callback: {
            createGroupResponse in
            let groupResponse = TestHelper.decodeGroupJSON(jsonString: createGroupResponse!)
            self.groupsToDelete.append(groupResponse!)
            XCTAssertEqual(groupResponse?.responseCode, "SUCC")
            XCTAssertEqual(groupResponse?.status, 201)
            expectations[1].fulfill()
            print("\tTEST GET GROUP")
            self.myVoiceIt?.getGroup(groupResponse?.groupId, callback: {
                getGroupResponse in
                VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: getGroupResponse!)
                expectations[2].fulfill()
                print("\tTEST GROUP EXISTS")
                self.myVoiceIt?.groupExists(groupResponse?.groupId, callback: {
                    groupExistsResponse in
                    VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: groupExistsResponse!)
                    expectations[3].fulfill()
                    self.myVoiceIt?.createUser({
                        createUserResponse in
                        let user = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
                        self.usersToDelete.append(user!)
                            print("\tTEST ADD USER TO GROUP")
                            self.myVoiceIt?.addUser(toGroup: groupResponse?.groupId, userId: user?.userId, callback: {
                                addUserResponse in
                                VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: addUserResponse!)
                                expectations[4].fulfill()
                                print("\tTEST REMOVE USER FROM GROUP")
                                self.myVoiceIt?.removeUser(fromGroup: groupResponse?.groupId, userId: user?.userId, callback: {
                                    removeUserResponse in
                                    VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: removeUserResponse!)
                                    expectations[5].fulfill()
                                    print("\tTEST DELETE GROUP")
                                    self.myVoiceIt?.deleteGroup(groupResponse?.groupId, callback: {
                                        deleteGroupResponse in
                                        VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: deleteGroupResponse!)
                                        expectations[6].fulfill()
                                    })
                                })
                            })
                        })
                    })
                })
            })
        
        wait(for: expectations, timeout: TIMEOUT)
    }
    
    func testPhrases() {
        print("TEST PHRASE API CALLS")
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Get Phrases"))
        
        print("\tTEST GET PHRASES")
        myVoiceIt?.getPhrases("en-US", callback : {
            jsonResponse in
            VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: jsonResponse!)
            expectations[0].fulfill()
        })
        
        wait(for: expectations, timeout: TIMEOUT)
    }
    
    func testGetEnrollments() {
        print("TEST GET ENROLLMENT API CALLS")
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Get Voice Enrollments"))
        expectations.append(XCTestExpectation(description: "Test Get Face Enrollments"))
        expectations.append(XCTestExpectation(description: "Test Get Video Enrollments"))
        
        self.myVoiceIt?.createUser({
            createUserResponse in
            let user = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
            self.usersToDelete.append(user!)
            print("\tTEST GET VOICE ENROLLMENTS")
            self.myVoiceIt?.getVoiceEnrollments(user?.userId, callback : {
                getVoiceEnrollmentsResponse in
                let getVoiceEnrollmentsJSON = TestHelper.decodeGetVoiceEnrollmentsJSON(jsonString: getVoiceEnrollmentsResponse!)
                XCTAssertEqual(getVoiceEnrollmentsJSON?.responseCode, "SUCC")
                XCTAssertEqual(getVoiceEnrollmentsJSON?.status, 200)
                XCTAssertGreaterThanOrEqual(getVoiceEnrollmentsJSON!.voiceEnrollments!.count, 0)
                expectations[0].fulfill()
                print("\tTEST GET FACE ENROLLMENTS")
                self.myVoiceIt?.getFaceEnrollments(user?.userId, callback : {
                    getFaceEnrollmentsResponse in
                    let getFaceEnrollmentsJSON = TestHelper.decodeGetFaceEnrollmentsJSON(jsonString: getFaceEnrollmentsResponse!)
                    XCTAssertEqual(getFaceEnrollmentsJSON?.responseCode, "SUCC")
                    XCTAssertEqual(getFaceEnrollmentsJSON?.status, 200)
                    XCTAssertGreaterThanOrEqual(getFaceEnrollmentsJSON!.faceEnrollments!.count, 0)
                    expectations[1].fulfill()
                    print("\tTEST GET VIDEO ENROLLMENTS")
                    self.myVoiceIt?.getVideoEnrollments(user?.userId, callback : {
                        getVideoEnrollmentsResponse in
                        let getVideoEnrollmentsJSON = TestHelper.decodeGetVideoEnrollmentsJSON(jsonString: getVideoEnrollmentsResponse!)
                        XCTAssertEqual(getVideoEnrollmentsJSON?.responseCode, "SUCC")
                        XCTAssertEqual(getVideoEnrollmentsJSON?.status, 200)
                        XCTAssertGreaterThanOrEqual(getVideoEnrollmentsJSON!.videoEnrollments!.count, 0)
                        expectations[2].fulfill()
                    })
                })
            })
        })
        wait(for: expectations, timeout: TIMEOUT)
    }
    
    func testCreateAndDeleteEnrollments() {
        print("TEST CREATE AND ENROLLMENT API CALLS")
        
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Create Voice Enrollment"))
        expectations.append(XCTestExpectation(description: "Test Delete Voice Enrollment"))
        expectations.append(XCTestExpectation(description: "Test Create Face Enrollment"))
        expectations.append(XCTestExpectation(description: "Test Delete Face Enrollment"))
        expectations.append(XCTestExpectation(description: "Test Create Video Enrollment"))
        expectations.append(XCTestExpectation(description: "Test Delete Video Enrollment"))
        
        self.myVoiceIt?.createUser({
            createUserResponse in
            let user = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
            self.usersToDelete.append(user!)
            print("\tTEST CREATE VOICE ENROLLMENT")
            self.setupVoiceEnrollment(userId: (user?.userId)!, fileName: "enrollmentArmaan1.wav", callback: {
                createVoiceEnrollmentResponse in
                let voiceEnrollmentResponse = TestHelper.decodeVoiceEnrollmentJSON(jsonString: createVoiceEnrollmentResponse)
                XCTAssertEqual(voiceEnrollmentResponse?.responseCode, "SUCC")
                XCTAssertEqual(voiceEnrollmentResponse?.status, 201)
                expectations[0].fulfill()
                print("\tTEST DELETE VOICE ENROLLMENT")
                self.myVoiceIt?.deleteVoiceEnrollment(user?.userId, voiceEnrollmentId: (voiceEnrollmentResponse?.id)!, callback: {
                    deleteVoiceEnrollmentResponse in
                    VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: deleteVoiceEnrollmentResponse!)
                    expectations[1].fulfill()
                    print("\tTEST CREATE FACE ENROLLMENT")
                    self.setupFaceEnrollment(userId: (user?.userId)!, fileName: "faceEnrollmentArmaan1.mp4", callback: {
                        createFaceEnrollmentResponse in
                        let faceEnrollmentResponse = TestHelper.decodeFaceEnrollmentJSON(jsonString: createFaceEnrollmentResponse)
                        XCTAssertEqual(faceEnrollmentResponse?.responseCode, "SUCC")
                        XCTAssertEqual(faceEnrollmentResponse?.status, 201)
                        expectations[2].fulfill()
                        print("\tTEST DELETE FACE ENROLLMENT")
                            self.myVoiceIt?.deleteFaceEnrollment(user?.userId, faceEnrollmentId: (faceEnrollmentResponse?.faceEnrollmentId)!, callback: {
                                deleteFaceEnrollmentResponse in
                                VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: deleteFaceEnrollmentResponse!)
                                expectations[3].fulfill()
                                print("\tTEST CREATE VIDEO ENROLLMENT")
                                self.setupVideoEnrollment(userId: (user?.userId)!, fileName: "videoEnrollmentArmaan1.mov", callback: {
                                    createVideoEnrollmentResponse in
                                    let videoEnrollmentResponse = TestHelper.decodeVideoEnrollmentJSON(jsonString: createVideoEnrollmentResponse)
                                    XCTAssertEqual(videoEnrollmentResponse?.responseCode, "SUCC")
                                    XCTAssertEqual(videoEnrollmentResponse?.status, 201)
                                    expectations[4].fulfill()
                                    print("\tTEST DELETE VIDEO ENROLLMENT")
                                    self.myVoiceIt?.deleteVideoEnrollment(user?.userId, videoEnrollmentId: (videoEnrollmentResponse?.id)!, callback: {
                                        deleteVideoEnrollmentResponse in
                                        VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: deleteVideoEnrollmentResponse!)
                                        expectations[5].fulfill()
                                    })
                                })
                            })
                        })
                    })
                })
            })
        
        wait(for: expectations, timeout: TIMEOUT)
    }
    
    func testDeleteAllEnrollments() {
        print("TEST DELETE ALL ENROLLMENT API CALLS")
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Delete All Voice Enrollments"))
        expectations.append(XCTestExpectation(description: "Test Delete All Face Enrollments"))
        expectations.append(XCTestExpectation(description: "Test Delete All Video Enrollments"))
        
        self.myVoiceIt?.createUser({
            createUserResponse in
            let user = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
            self.usersToDelete.append(user!)
            print("\tTEST DELETE ALL VOICE ENROLLMENTS")
            self.myVoiceIt?.deleteAllVoiceEnrollments(user?.userId, callback : {
                deleteVoiceEnrollmentsResponse in
                VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: deleteVoiceEnrollmentsResponse!)
                expectations[0].fulfill()
                print("\tTEST DELETE ALL FACE ENROLLMENTS")
                self.myVoiceIt?.deleteAllFaceEnrollments(user?.userId, callback : {
                    deleteFaceEnrollmentsResponse in
                    VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: deleteFaceEnrollmentsResponse!)
                    expectations[1].fulfill()
                    print("\tTEST DELETE ALL VIDEO ENROLLMENTS")
                    self.myVoiceIt?.deleteAllVideoEnrollments(user?.userId, callback : {
                        deleteVideoEnrollmentsResponse in
                        VoiceItTest.basicAssert(expectedRC: "SUCC", expectedSC: 200, jsonResponse: deleteVideoEnrollmentsResponse!)
                        expectations[2].fulfill()
                    })
                })
            })
        })
        wait(for: expectations, timeout: TIMEOUT)
    }
    
    func testVoiceVerification(){
        print("TEST VOICE VERIFICATION API CALL")
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Voice Verification"))
        self.myVoiceIt?.createUser({ createUserResponse in
            let user = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
            self.usersToDelete.append(user!)
            self.setupVoiceEnrollment(userId: (user?.userId)!, fileName: "enrollmentArmaan1.wav", callback: { _ in
                self.setupVoiceEnrollment(userId: (user?.userId)!, fileName: "enrollmentArmaan2.wav", callback: { _ in
                    self.setupVoiceEnrollment(userId: (user?.userId)!, fileName: "enrollmentArmaan3.wav", callback: { _ in
                        print("\tTEST VOICE VERIFICATION")
                        TestHelper.downloadS3File(fileName: "verificationArmaan1.wav", callback: { verificationFilePath in
                            self.myVoiceIt?.voiceVerification((user?.userId)!, contentLanguage: "en-US", audioPath: verificationFilePath, phrase: "never forget tomorrow is a new day", callback: {
                                voiceVerificationResponse in
                                let voiceVerification = TestHelper.decodeSimpleJSON(jsonString: voiceVerificationResponse!)
                                VoiceItTest.basicAssert(expectedRC: (voiceVerification?.responseCode)!, expectedSC: (voiceVerification?.status)!, jsonResponse: voiceVerificationResponse!)
                                expectations[0].fulfill()
                            })
                        })
                    })
                })
            })
        })
        
        wait(for: expectations, timeout: TIMEOUT)
    }
    
    func testFaceVerification(){
        print("TEST FACE VERIFICATION API CALL")
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Video Verification"))
        self.myVoiceIt?.createUser({ createUserResponse in
            let user = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
            self.usersToDelete.append(user!)
            self.setupFaceEnrollment(userId: (user?.userId)!, fileName: "faceEnrollmentArmaan1.mp4", callback: { _ in
                self.setupFaceEnrollment(userId: (user?.userId)!, fileName: "faceEnrollmentArmaan2.mp4", callback: { _ in
                    self.setupFaceEnrollment(userId: (user?.userId)!, fileName: "faceEnrollmentArmaan3.mp4", callback: { _ in
                        print("\tTEST FACE VERIFICATION")
                        TestHelper.downloadS3File(fileName: "faceVerificationArmaan1.mp4", callback: { verificationFilePath in
                            self.myVoiceIt?.faceVerification((user?.userId)!, videoPath: verificationFilePath, callback: {
                                faceVerificationResponse in
                                let faceVerification = TestHelper.decodeSimpleJSON(jsonString: faceVerificationResponse!)
                                VoiceItTest.basicAssert(expectedRC: (faceVerification?.responseCode)!, expectedSC: (faceVerification?.status)!, jsonResponse: faceVerificationResponse!)
                                expectations[0].fulfill()
                            })
                        })
                    })
                })
            })
        })
        
        wait(for: expectations, timeout: TIMEOUT)
    }
    
    func testVideoVerification(){
        print("TEST VIDEO VERIFICATION API CALL")
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Video Verification"))
        self.myVoiceIt?.createUser({ createUserResponse in
            let user = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
            self.usersToDelete.append(user!)
            self.setupVideoEnrollment(userId: (user?.userId)!, fileName: "videoEnrollmentArmaan1.mov", callback: { _ in
                self.setupVideoEnrollment(userId: (user?.userId)!, fileName: "videoEnrollmentArmaan2.mov", callback: { _ in
                    self.setupVideoEnrollment(userId: (user?.userId)!, fileName: "videoEnrollmentArmaan3.mov", callback: { _ in
                        print("\tTEST VIDEO VERIFICATION")
                        TestHelper.downloadS3File(fileName: "videoVerificationArmaan1.mov", callback: { verificationFilePath in
                            self.myVoiceIt?.videoVerification((user?.userId)!, contentLanguage: "en-US", videoPath: verificationFilePath, phrase: "never forget tomorrow is a new day", callback: {
                                videoVerificationResponse in
                                let videoVerification = TestHelper.decodeSimpleJSON(jsonString: videoVerificationResponse!)
                                VoiceItTest.basicAssert(expectedRC: (videoVerification?.responseCode)!, expectedSC: (videoVerification?.status)!, jsonResponse: videoVerificationResponse!)
                                expectations[0].fulfill()
                            })
                        })
                    })
                })
            })
        })
        
        wait(for: expectations, timeout: TIMEOUT)
    }
    
    func testVoiceIdentification(){
        print("TEST VOICE IDENTIFICATION API CALL")
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Voice Identification"))
        self.myVoiceIt?.createUser({ createUserResponse in
            let user1 = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
            self.usersToDelete.append(user1!)
            self.setupVoiceEnrollment(userId: (user1?.userId)!, fileName: "enrollmentArmaan1.wav", callback: { _ in
                self.setupVoiceEnrollment(userId: (user1?.userId)!, fileName: "enrollmentArmaan2.wav", callback: { _ in
                    self.setupVoiceEnrollment(userId: (user1?.userId)!, fileName: "enrollmentArmaan3.wav", callback: { _ in
                        self.myVoiceIt?.createUser({ createUserResponse in
                            let user2 = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
                            self.usersToDelete.append(user2!)
                            self.setupVoiceEnrollment(userId: (user2?.userId)!, fileName: "enrollmentStephen1.wav", callback: { _ in
                                self.setupVoiceEnrollment(userId: (user2?.userId)!, fileName: "enrollmentStephen2.wav", callback: { _ in
                                    self.setupVoiceEnrollment(userId: (user2?.userId)!, fileName: "enrollmentStephen3.wav", callback: { _ in
                                        self.myVoiceIt?.createGroup("Test Identification Group", callback: {
                                            createGroupResponse in
                                            let group = TestHelper.decodeGroupJSON(jsonString: createGroupResponse!)
                                            self.myVoiceIt?.addUser(toGroup: group?.groupId, userId: user1?.userId, callback: { _ in
                                                self.myVoiceIt?.addUser(toGroup: group?.groupId, userId: user2?.userId, callback: { _ in
                                                    print("\tTEST VOICE IDENTIFICATION")
                                                    TestHelper.downloadS3File(fileName: "verificationArmaan1.wav", callback: { identificationFilePath in
                                                        self.myVoiceIt?.voiceIdentification((group?.groupId)!, contentLanguage: "en-US", audioPath: identificationFilePath, phrase: "never forget tomorrow is a new day", callback: {
                                                            voiceIdentificationResponse in
                                                            let voiceIdentification = TestHelper.decodeUserJSON(jsonString: voiceIdentificationResponse!)
                                                            XCTAssertEqual(voiceIdentification?.responseCode, "SUCC")
                                                            XCTAssertEqual(voiceIdentification?.status, 200)
                                                            XCTAssertEqual(voiceIdentification?.userId, user1?.userId)
                                                            expectations[0].fulfill()
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
        
        wait(for: expectations, timeout: TIMEOUT)
    }
    
    func testFaceIdentification(){
        print("TEST FACE IDENTIFICATION API CALL")
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Face Identification"))
        self.myVoiceIt?.createUser({ createUserResponse in
            let user1 = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
            self.usersToDelete.append(user1!)
            self.setupFaceEnrollment(userId: (user1?.userId)!, fileName: "faceEnrollmentArmaan1.mp4", callback: { _ in
                self.setupFaceEnrollment(userId: (user1?.userId)!, fileName: "faceEnrollmentArmaan2.mp4", callback: { _ in
                    self.setupFaceEnrollment(userId: (user1?.userId)!, fileName: "faceEnrollmentArmaan3.mp4", callback: { _ in
                        self.myVoiceIt?.createUser({ createUserResponse in
                            let user2 = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
                            self.usersToDelete.append(user2!)
                            self.setupFaceEnrollment(userId: (user2?.userId)!, fileName: "videoEnrollmentStephen1.mov", callback: { _ in
                                self.setupFaceEnrollment(userId: (user2?.userId)!, fileName: "videoEnrollmentStephen2.mov", callback: { _ in
                                    self.setupFaceEnrollment(userId: (user2?.userId)!, fileName: "videoEnrollmentStephen3.mov", callback: { _ in
                                        self.myVoiceIt?.createGroup("Test Identification Group", callback: {
                                            createGroupResponse in
                                            let group = TestHelper.decodeGroupJSON(jsonString: createGroupResponse!)
                                            self.myVoiceIt?.addUser(toGroup: group?.groupId, userId: user1?.userId, callback: { _ in
                                                self.myVoiceIt?.addUser(toGroup: group?.groupId, userId: user2?.userId, callback: { _ in
                                                    print("\tTEST FACE IDENTIFICATION")
                                                    TestHelper.downloadS3File(fileName: "videoVerificationArmaan1.mov", callback: { identificationFilePath in
                                                        self.myVoiceIt?.faceIdentification((group?.groupId)!, videoPath: identificationFilePath, callback: {
                                                            faceIdentificationResponse in
                                                            let faceIdentification = TestHelper.decodeUserJSON(jsonString: faceIdentificationResponse!)
                                                            XCTAssertEqual(faceIdentification?.responseCode, "SUCC")
                                                            XCTAssertEqual(faceIdentification?.status, 200)
                                                            XCTAssertEqual(faceIdentification?.userId, user1?.userId)
                                                            expectations[0].fulfill()
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
        
        wait(for: expectations, timeout: TIMEOUT)
    }
    
    func testVideoIdentification(){
        print("TEST VIDEO IDENTIFICATION API CALL")
        // Setup Expectations
        var expectations = [XCTestExpectation]()
        expectations.append(XCTestExpectation(description: "Test Video Identification"))
        self.myVoiceIt?.createUser({ createUserResponse in
            let user1 = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
            self.usersToDelete.append(user1!)
            self.setupVideoEnrollment(userId: (user1?.userId)!, fileName: "videoEnrollmentArmaan1.mov", callback: { _ in
                self.setupVideoEnrollment(userId: (user1?.userId)!, fileName: "videoEnrollmentArmaan2.mov", callback: { _ in
                    self.setupVideoEnrollment(userId: (user1?.userId)!, fileName: "videoEnrollmentArmaan3.mov", callback: { _ in
                        self.myVoiceIt?.createUser({ createUserResponse in
                            let user2 = TestHelper.decodeUserJSON(jsonString: createUserResponse!)
                            self.usersToDelete.append(user2!)
                            self.setupVideoEnrollment(userId: (user2?.userId)!, fileName: "videoEnrollmentStephen1.mov", callback: { _ in
                                self.setupVideoEnrollment(userId: (user2?.userId)!, fileName: "videoEnrollmentStephen2.mov", callback: { _ in
                                    self.setupVideoEnrollment(userId: (user2?.userId)!, fileName: "videoEnrollmentStephen3.mov", callback: { _ in
                                        self.myVoiceIt?.createGroup("Test Identification Group", callback: {
                                            createGroupResponse in
                                            let group = TestHelper.decodeGroupJSON(jsonString: createGroupResponse!)
                                            self.myVoiceIt?.addUser(toGroup: group?.groupId, userId: user1?.userId, callback: { _ in
                                                self.myVoiceIt?.addUser(toGroup: group?.groupId, userId: user2?.userId, callback: { _ in
                                                    print("\tTEST VIDEO IDENTIFICATION")
                                                    TestHelper.downloadS3File(fileName: "videoVerificationArmaan1.mov", callback: { identificationFilePath in
                                                        self.myVoiceIt?.videoIdentification((group?.groupId)!, contentLanguage: "en-US", videoPath: identificationFilePath, phrase: "never forget tomorrow is a new day", callback: {
                                                            videoIdentificationResponse in
                                                            let videoIdentification = TestHelper.decodeUserJSON(jsonString: videoIdentificationResponse!)
                                                            XCTAssertEqual(videoIdentification?.responseCode, "SUCC")
                                                            XCTAssertEqual(videoIdentification?.status, 200)
                                                            XCTAssertEqual(videoIdentification?.userId, user1?.userId)
                                                            expectations[0].fulfill()
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
        
        wait(for: expectations, timeout: TIMEOUT)
    }
    
    // TODO: Maybe can add some of these in the future
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
