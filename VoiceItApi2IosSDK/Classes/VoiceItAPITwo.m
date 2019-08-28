//
//  VoiceItAPITwo.m
//  VoiceItApi2IosSDK
//
//  Created by Armaan Bindra on 3/7/17.
//  Copyright © 2017 Armaan Bindra. All rights reserved.
//

#import "VoiceItAPITwo.h"
#import "Styles.h"
NSString * const host = @"http://212.117.143.178";
@implementation VoiceItAPITwo

#pragma mark - Constructor
- (id)init:(UIViewController *)masterViewController apiKey:(NSString *)apiKey apiToken:(NSString *) apiToken {
    return [self init:masterViewController apiKey:apiKey apiToken:apiToken styles:nil];
}

- (id)init:(UIViewController *)masterViewController apiKey:(NSString *)apiKey apiToken:(NSString *) apiToken styles:(NSMutableDictionary *) styles {
    self.apiKey = apiKey;
    self.apiToken = apiToken;
    self.authHeader = [self createAuthHeader];
    self.boundary = [self generateBoundaryString];
    self.masterViewController = masterViewController;
#pragma mark - Save Styles Passed to Styles Class
    [Styles set:styles];
    return self;
}

#pragma mark - Phrase API Calls

- (void)getPhrases:(NSString *)contentLanguage callback:(void (^)(NSString *))callback
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@",[self buildURL:@"phrases"], contentLanguage]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {
                   
                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   callback(result);
               }];
    [task resume];
}

#pragma mark - User API Calls

- (void)getAllUsers:(void (^)(NSString *))callback
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"users"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   // Add Call to Callback function passing in result
                   callback(result);
               }];
    [task resume];
}

- (void)checkUserExists:(NSString *)userId callback:(void (^)(NSString *))callback
{
    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Get User"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@",[self buildURL:@"users"], userId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   callback(result);
               }];
    [task resume];
}

- (void)getGroupsForUser:(NSString *)userId callback:(void (^)(NSString *))callback{
    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Get Groups for User"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@/%@",[self buildURL:@"users"], userId, @"groups"]]
                                    ];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   callback(result);
               }];
    [task resume];
}

- (void)createUser:(void (^)(NSString *))callback
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"users"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   callback(result);
               }];
    [task resume];
}

- (void)deleteUser: (NSString *)userId callback:(void (^)(NSString *))callback{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Delete User"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@",[self buildURL:@"users"], userId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   callback(result);
               }];
    [task resume];
}


#pragma mark - Group API Calls

- (void)getAllGroups:(void (^)(NSString *))callback
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"groups"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   callback(result);
               }];
    [task resume];
}

- (void)getGroup:(NSString *)groupId callback:(void (^)(NSString *))callback
{
    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Get Group"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@",[self buildURL:@"groups"], groupId]]];

    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   // Add Call to Callback function passing in result
                   callback(result);
               }];
    [task resume];
}

- (void)groupExists:(NSString *)groupId callback:(void (^)(NSString *))callback{
    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Group Exists"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@/exists",[self buildURL:@"groups"], groupId]]];

    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   // Add Call to Callback function passing in result
                   callback(result);
               }];
    [task resume];
}

- (void)createGroup:(void (^)(NSString *))callback{
    [self createGroup:@"" callback:callback];
}

- (void)createGroup:(NSString *)description callback:(void (^)(NSString *))callback
{
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"groups"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"description" : description};
    NSData *body = [self createBodyWithBoundary:self.boundary parameters:params paths:nil fieldName:nil];
    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response,
                                                                                                           NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        // Add Call to Callback function passing in result
        callback(result);
    }];

    [task resume];
}

- (void)addUserToGroup:(NSString *)groupId userId:(NSString *)userId callback:(void (^)(NSString *))callback
{
    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Add User from Group"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Add User from Group"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }


    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"groups/addUser"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"PUT"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"userId" : userId, @"groupId": groupId};
    NSData *body = [self createBodyWithBoundary:self.boundary parameters:params paths:nil fieldName:nil];
    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response,
                                                                                                           NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        // Add Call to Callback function passing in result
        callback(result);
    }];

    [task resume];
}

- (void)removeUserFromGroup:(NSString *)groupId userId:(NSString *)userId callback:(void (^)(NSString *))callback{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Remove User from Group"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Remove User from Group"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"groups/removeUser"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"PUT"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"userId" : userId, @"groupId": groupId};
    NSData *body = [self createBodyWithBoundary:self.boundary parameters:params paths:nil fieldName:nil];
    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response,
                                                                                                           NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        // Add Call to Callback function passing in result
        callback(result);
    }];

    [task resume];
}

- (void)deleteGroup: (NSString *)groupId callback:(void (^)(NSString *))callback{

    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Delete Group"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }


    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@",[self buildURL:@"groups"], groupId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   // Add Call to Callback function passing in result
                   callback(result);
               }];
    [task resume];
}

#pragma mark - Enrollment API Calls
- (void)getAllVoiceEnrollments:(NSString *)userId callback:(void (^)(NSString *))callback{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Get All Voice Enrollments"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }


    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@",[self buildURL:@"enrollments/voice"], userId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   // Add Call to Callback function passing in result
                   callback(result);
               }];
    [task resume];
}

- (void)getAllFaceEnrollments:(NSString *)userId callback:(void (^)(NSString *))callback{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Get All Face Enrollments"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }


    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@",[self buildURL:@"enrollments/face"], userId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   // Add Call to Callback function passing in result
                   callback(result);
               }];
    [task resume];
}

- (void)getAllVideoEnrollments:(NSString *)userId callback:(void (^)(NSString *))callback{
    
    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Get All Video Enrollments"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@",[self buildURL:@"enrollments/video"], userId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {
                   
                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   // Add Call to Callback function passing in result
                   callback(result);
               }];
    [task resume];
}

- (void)deleteVoiceEnrollment:(NSString *)userId voiceEnrollmentId:(NSInteger)voiceEnrollmentId callback:(void (^)(NSString *))callback{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Delete Voice Enrollment"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@/%ld",[self buildURL:@"enrollments/voice"], userId, (long) voiceEnrollmentId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   // Add Call to Callback function passing in result
                   callback(result);
               }];
    [task resume];
}

- (void)deleteFaceEnrollment:(NSString *)userId faceEnrollmentId:(NSInteger)faceEnrollmentId callback:(void (^)(NSString *))callback{
    
    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Delete Face Enrollment"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@/%ld",[self buildURL:@"enrollments/face"], userId, (long) faceEnrollmentId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {
                   
                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   // Add Call to Callback function passing in result
                   callback(result);
               }];
    [task resume];
}

- (void)deleteVideoEnrollment:(NSString *)userId videoEnrollmentId:(NSInteger)videoEnrollmentId callback:(void (^)(NSString *))callback{
    
    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Delete Video Enrollment"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@/%ld",[self buildURL:@"enrollments/video"], userId, (long) videoEnrollmentId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {
                   
                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   // Add Call to Callback function passing in result
                   callback(result);
               }];
    [task resume];
}

- (void)deleteAllEnrollments: (NSString *)userId callback:(void (^)(NSString *))callback{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Delete All Enrollments"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@/all",[self buildURL:@"enrollments"], userId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {

                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   callback(result);
               }];
    [task resume];
}

- (void)deleteAllVoiceEnrollments: (NSString *)userId callback:(void (^)(NSString *))callback{
    
    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Delete All Voice Enrollments"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@/voice",[self buildURL:@"enrollments"], userId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {
                   
                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   callback(result);
               }];
    [task resume];
}

- (void)deleteAllFaceEnrollments: (NSString *)userId callback:(void (^)(NSString *))callback{
    
    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Delete All Face Enrollments"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@/face",[self buildURL:@"enrollments"], userId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {
                   
                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   callback(result);
               }];
    [task resume];
}

- (void)deleteAllVideoEnrollments: (NSString *)userId callback:(void (^)(NSString *))callback{
    
    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Delete All Video Enrollments"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@/%@/video",[self buildURL:@"enrollments"], userId]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {
                   
                   NSString *result =
                   [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
                   callback(result);
               }];
    [task resume];
}

- (void)createVoiceEnrollment:(NSString *)userId
          contentLanguage:(NSString*)contentLanguage
                audioPath:(NSString*)audioPath
                   phrase:(NSString*)phrase
                 callback:(void (^)(NSString *))callback
{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Video Verification"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"enrollments/voice"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"contentLanguage" : contentLanguage, @"userId": userId, @"phrase" : phrase };
    NSMutableData *body = [NSMutableData data];

    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath:audioPath fieldName:@"recording"];
    [self endBody:body];

    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }

    }];

    [task resume];
}

- (void)createFaceEnrollment:(NSString *)userId
                   videoPath:(NSString*)videoPath
                    callback:(void (^)(NSString *))callback
{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Face Enrollment"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"enrollments/face"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"userId": userId};
    NSMutableData *body = [NSMutableData data];
    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath: videoPath fieldName:@"video"];
    [self endBody:body];

    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];

    [task resume];
}

- (void)createVideoEnrollment:(NSString *)userId
              contentLanguage:(NSString*)contentLanguage
                    videoPath:(NSString*)videoPath
                       phrase:(NSString*)phrase
                     callback:(void (^)(NSString *))callback {

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Video Verification"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"enrollments/video"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"contentLanguage" : contentLanguage, @"userId": userId, @"phrase" : phrase };
    NSMutableData *body = [NSMutableData data];

    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath:videoPath fieldName:@"video"];
    [self endBody:body];

    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];
    [task resume];
}

- (void)createVideoEnrollment:(NSString *)userId
              contentLanguage:(NSString*)contentLanguage
                    imageData:(NSData*)imageData
                    audioPath:(NSString*)audioPath
                       phrase:(NSString*)phrase
                     callback:(void (^)(NSString *))callback
{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Create Video Enrollment"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"enrollments/video"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"contentLanguage" : contentLanguage, @"userId": userId, @"phrase" : phrase };
    NSMutableData *body = [NSMutableData data];

    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath:audioPath fieldName:@"audio"];
    [self addImageToBody:body imageData:imageData fieldName:@"photo"];
    [self endBody:body];

    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];

    [task resume];
}

- (void)encapsulatedVoiceEnrollUser:(NSString *)userId
                    contentLanguage:(NSString*)contentLanguage
                   voicePrintPhrase:(NSString*)voicePrintPhrase
           userEnrollmentsCancelled:(void (^)(void))userEnrollmentsCancelled
              userEnrollmentsPassed:(void (^)(void))userEnrollmentsPassed{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Create Voice Enrollment"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    MainNavigationController * controller = (MainNavigationController *) [[Utilities getVoiceItStoryBoard] instantiateViewControllerWithIdentifier:@"mainNavController"];
    controller.enrollmentType = voice;
    controller.uniqueId = userId;
    controller.contentLanguage = contentLanguage;
    controller.voicePrintPhrase = voicePrintPhrase;
    controller.userEnrollmentsCancelled = userEnrollmentsCancelled;
    controller.userEnrollmentsPassed = userEnrollmentsPassed;
    controller.myVoiceIt = self;
    [[self masterViewController] presentViewController:controller animated:YES completion:nil];
}

- (void)encapsulatedFaceEnrollUser:(NSString *)userId
          userEnrollmentsCancelled:(void (^)(void))userEnrollmentsCancelled
             userEnrollmentsPassed:(void (^)(void))userEnrollmentsPassed
{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Create Face Enrollment"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    MainNavigationController * controller = (MainNavigationController *) [[Utilities getVoiceItStoryBoard] instantiateViewControllerWithIdentifier:@"mainNavController"];
    controller.enrollmentType = face;
    controller.uniqueId = userId;
    controller.userEnrollmentsCancelled = userEnrollmentsCancelled;
    controller.userEnrollmentsPassed = userEnrollmentsPassed;
    controller.myVoiceIt = self;
    [[self masterViewController] presentViewController:controller animated:YES completion:nil];
}

- (void)encapsulatedVideoEnrollUser:(NSString *)userId
                    contentLanguage:(NSString*)contentLanguage
                   voicePrintPhrase:(NSString*)voicePrintPhrase
           userEnrollmentsCancelled:(void (^)(void))userEnrollmentsCancelled
              userEnrollmentsPassed:(void (^)(void))userEnrollmentsPassed
{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Create Video Enrollment"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    MainNavigationController * controller = (MainNavigationController *) [[Utilities getVoiceItStoryBoard] instantiateViewControllerWithIdentifier:@"mainNavController"];
    controller.enrollmentType = video;
    controller.uniqueId = userId;
    controller.contentLanguage = contentLanguage;
    controller.voicePrintPhrase = voicePrintPhrase;
    controller.userEnrollmentsCancelled = userEnrollmentsCancelled;
    controller.userEnrollmentsPassed = userEnrollmentsPassed;
    controller.myVoiceIt = self;
    [[self masterViewController] presentViewController:controller animated:YES completion:nil];
}

- (void)encapsulatedVoiceVerification:(NSString *)userId
                      contentLanguage:(NSString*)contentLanguage
                     voicePrintPhrase:(NSString*)voicePrintPhrase
            userVerificationCancelled:(void (^)(void))userVerificationCancelled
           userVerificationSuccessful:(void (^)(float, NSString *))userVerificationSuccessful
               userVerificationFailed:(void (^)(float, NSString *))userVerificationFailed
{
    [self encapsulatedVoiceVerification:userId
                        contentLanguage:contentLanguage
                       voicePrintPhrase:voicePrintPhrase
                        numFailsAllowed:3
              userVerificationCancelled:userVerificationCancelled
             userVerificationSuccessful:userVerificationSuccessful
                 userVerificationFailed:userVerificationFailed
    ];
}

- (void)encapsulatedVoiceVerification:(NSString *)userId
                      contentLanguage:(NSString*)contentLanguage
                     voicePrintPhrase:(NSString*)voicePrintPhrase
                      numFailsAllowed:(int)numFailsAllowed
            userVerificationCancelled:(void (^)(void))userVerificationCancelled
           userVerificationSuccessful:(void (^)(float, NSString *))userVerificationSuccessful
               userVerificationFailed:(void (^)(float, NSString *))userVerificationFailed
{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Do Video Verification"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    VoiceVerificationViewController *verifyVoice = [[Utilities getVoiceItStoryBoard] instantiateViewControllerWithIdentifier:@"verifyVoiceVC"];
    verifyVoice.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    verifyVoice.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    verifyVoice.userToVerifyUserId = userId;
    verifyVoice.contentLanguage = contentLanguage;
    verifyVoice.thePhrase = voicePrintPhrase;
    verifyVoice.failsAllowed = numFailsAllowed;
    verifyVoice.userVerificationCancelled = userVerificationCancelled;
    verifyVoice.userVerificationSuccessful = userVerificationSuccessful;
    verifyVoice.userVerificationFailed = userVerificationFailed;
    verifyVoice.voiceItMaster = self;
    [[self masterViewController] presentViewController: verifyVoice animated:YES completion:nil];
}

- (void)encapsulatedFaceVerification:(NSString *)userId
                 doLivenessDetection:(bool)doLivenessDetection
           userVerificationCancelled:(void (^)(void))userVerificationCancelled
          userVerificationSuccessful:(void (^)(float, NSString *))userVerificationSuccessful
              userVerificationFailed:(void (^)(float, NSString *))userVerificationFailed
{
    [self encapsulatedFaceVerification:userId
                   doLivenessDetection:doLivenessDetection
                       numFailsAllowed:3
         livenessChallengeFailsAllowed:0
             userVerificationCancelled:userVerificationCancelled
            userVerificationSuccessful:userVerificationSuccessful userVerificationFailed:userVerificationFailed
     ];
}

- (void)encapsulatedFaceVerification:(NSString *)userId
                 doLivenessDetection:(bool)doLivenessDetection
                     numFailsAllowed:(int)numFailsAllowed
       livenessChallengeFailsAllowed:(int)livenessChallengeFailsAllowed
           userVerificationCancelled:(void (^)(void))userVerificationCancelled
          userVerificationSuccessful:(void (^)(float, NSString *))userVerificationSuccessful
              userVerificationFailed:(void (^)(float, NSString *))userVerificationFailed
{
    
    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Do Face Verification"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }
    
    FaceVerificationViewController *faceVerificationVC = [[Utilities getVoiceItStoryBoard] instantiateViewControllerWithIdentifier:@"faceVerificationVC"];
    faceVerificationVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    faceVerificationVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    faceVerificationVC.userToVerifyUserId = userId;
    faceVerificationVC.userVerificationCancelled = userVerificationCancelled;
    faceVerificationVC.userVerificationSuccessful = userVerificationSuccessful;
    faceVerificationVC.userVerificationFailed = userVerificationFailed;
    faceVerificationVC.voiceItMaster = self;
    faceVerificationVC.doLivenessDetection = doLivenessDetection;
    faceVerificationVC.failsAllowed = numFailsAllowed;
    faceVerificationVC.numberOfLivenessFailsAllowed = livenessChallengeFailsAllowed;
    [[self masterViewController] presentViewController: faceVerificationVC animated:YES completion:nil];
}

- (void)encapsulatedFaceIdentification:(NSString *)groupId
                   doLivenessDetection:(bool)doLivenessDetection
           userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
          userIdentificationSuccessful:(void (^)(float, NSString *, NSString *))userIdentificationSuccessful
              userIdentificationFailed:(void (^)(float, NSString *))userIdentificationFailed
{
        [self encapsulatedFaceIdentification:groupId
                         doLivenessDetection:doLivenessDetection
                             numFailsAllowed:3
               livenessChallengeFailsAllowed:0
                 userIdentificationCancelled: userIdentificationCancelled
                userIdentificationSuccessful:userIdentificationSuccessful userIdentificationFailed:userIdentificationFailed
        ];
}

- (void)encapsulatedFaceIdentification:(NSString *)groupId
                   doLivenessDetection:(bool)doLivenessDetection
                       numFailsAllowed:(int)numFailsAllowed
         livenessChallengeFailsAllowed:(int)livenessChallengeFailsAllowed
           userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
          userIdentificationSuccessful:(void (^)(float, NSString *, NSString *))userIdentificationSuccessful
              userIdentificationFailed:(void (^)(float, NSString *))userIdentificationFailed
{
    
    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Encapsulated Video Identification"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }
    
    FaceIdentificationViewController *faceIdentificationVC = [[Utilities getVoiceItStoryBoard] instantiateViewControllerWithIdentifier:@"faceIdentificationVC"];
    faceIdentificationVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    faceIdentificationVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    faceIdentificationVC.groupToIdentifyGroupId = groupId;
    faceIdentificationVC.userIdentificationCancelled = userIdentificationCancelled;
    faceIdentificationVC.userIdentificationSuccessful = userIdentificationSuccessful;
    faceIdentificationVC.userIdentificationFailed = userIdentificationFailed;
    faceIdentificationVC.voiceItMaster = self;
    faceIdentificationVC.doLivenessDetection = doLivenessDetection;
    faceIdentificationVC.failsAllowed = numFailsAllowed;
    faceIdentificationVC.numberOfLivenessFailsAllowed = livenessChallengeFailsAllowed;
    [[self masterViewController] presentViewController: faceIdentificationVC animated:YES completion:nil];
}

- (void)encapsulatedVideoVerification:(NSString *)userId
                      contentLanguage:(NSString*)contentLanguage
                     voicePrintPhrase:(NSString*)voicePrintPhrase
                  doLivenessDetection:(bool)doLivenessDetection
            userVerificationCancelled:(void (^)(void))userVerificationCancelled
           userVerificationSuccessful:(void (^)(float, float, NSString *))userVerificationSuccessful
               userVerificationFailed:(void (^)(float, float, NSString *))userVerificationFailed
{
    [self encapsulatedVideoVerification:userId
                        contentLanguage:contentLanguage
                       voicePrintPhrase:voicePrintPhrase
                    doLivenessDetection:doLivenessDetection
                        numFailsAllowed:3
          livenessChallengeFailsAllowed:0 userVerificationCancelled:userVerificationCancelled
             userVerificationSuccessful:userVerificationSuccessful userVerificationFailed:userVerificationFailed
    ];
}

- (void)encapsulatedVideoVerification:(NSString *)userId
                      contentLanguage:(NSString*)contentLanguage
                     voicePrintPhrase:(NSString*)voicePrintPhrase
                  doLivenessDetection:(bool)doLivenessDetection
                      numFailsAllowed:(int)numFailsAllowed
        livenessChallengeFailsAllowed:(int)livenessChallengeFailsAllowed
            userVerificationCancelled:(void (^)(void))userVerificationCancelled
           userVerificationSuccessful:(void (^)(float, float, NSString *))userVerificationSuccessful
               userVerificationFailed:(void (^)(float, float, NSString *))userVerificationFailed
{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Do Video Verification"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    VideoVerificationViewController *verifyVC = [[Utilities getVoiceItStoryBoard] instantiateViewControllerWithIdentifier:@"videoVerifyVC"];
    verifyVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    verifyVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    verifyVC.userToVerifyUserId = userId;
    verifyVC.contentLanguage = contentLanguage;
    verifyVC.thePhrase = voicePrintPhrase;
    verifyVC.userVerificationCancelled = userVerificationCancelled;
    verifyVC.userVerificationSuccessful = userVerificationSuccessful;
    verifyVC.userVerificationFailed = userVerificationFailed;
    verifyVC.doLivenessDetection = doLivenessDetection;
    verifyVC.failsAllowed = numFailsAllowed;
    verifyVC.numberOfLivenessFailsAllowed = livenessChallengeFailsAllowed;
    verifyVC.voiceItMaster = self;
    [[self masterViewController] presentViewController: verifyVC animated:YES completion:nil];
}

- (void)encapsulatedVideoIdentification:(NSString *)groupId
                        contentLanguage:(NSString*)contentLanguage
                       voicePrintPhrase:(NSString*)voicePrintPhrase
                    doLivenessDetection:(bool)doLivenessDetection
            userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
           userIdentificationSuccessful:(void (^)(float, float, NSString *, NSString *))userIdentificationSuccessful
               userIdentificationFailed:(void (^)(float, float, NSString *))userIdentificationFailed
{
    [self encapsulatedVideoIdentification:groupId
                          contentLanguage:contentLanguage
                         voicePrintPhrase:voicePrintPhrase
                      doLivenessDetection:doLivenessDetection
                          numFailsAllowed:3
            livenessChallengeFailsAllowed:0
              userIdentificationCancelled:userIdentificationCancelled
             userIdentificationSuccessful:userIdentificationSuccessful userIdentificationFailed:userIdentificationFailed
    ];
}

- (void)encapsulatedVideoIdentification:(NSString *)groupId
                        contentLanguage:(NSString*)contentLanguage
                       voicePrintPhrase:(NSString*)voicePrintPhrase
                    doLivenessDetection:(bool)doLivenessDetection
                        numFailsAllowed:(int)numFailsAllowed
          livenessChallengeFailsAllowed:(int)livenessChallengeFailsAllowed
            userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
           userIdentificationSuccessful:(void (^)(float, float, NSString *, NSString *))userIdentificationSuccessful
               userIdentificationFailed:(void (^)(float, float, NSString *))userIdentificationFailed
{
    
    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Encapsulated Video Identification"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }
    
    VideoIdentificationViewController *identifyVC = [[Utilities getVoiceItStoryBoard] instantiateViewControllerWithIdentifier:@"videoIdentifyVC"];
    identifyVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    identifyVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    identifyVC.groupToIdentifyGroupId = groupId;
    identifyVC.contentLanguage = contentLanguage;
    identifyVC.thePhrase = voicePrintPhrase;
    identifyVC.userIdentificationCancelled = userIdentificationCancelled;
    identifyVC.userIdentificationSuccessful = userIdentificationSuccessful;
    identifyVC.userIdentificationFailed = userIdentificationFailed;
    identifyVC.doLivenessDetection = doLivenessDetection;
    identifyVC.failsAllowed = numFailsAllowed;
    identifyVC.numberOfLivenessFailsAllowed = livenessChallengeFailsAllowed;
    identifyVC.voiceItMaster = self;
    [[self masterViewController] presentViewController: identifyVC animated:YES completion:nil];
}

- (void)encapsulatedVoiceIdentification:(NSString *)groupId
                        contentLanguage:(NSString*)contentLanguage
                       voicePrintPhrase:(NSString*)voicePrintPhrase
            userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
           userIdentificationSuccessful:(void (^)(float, NSString *, NSString *))userIdentificationSuccessful
               userIdentificationFailed:(void (^)(float, NSString *))userIdentificationFailed
{
    [self encapsulatedVoiceIdentification:groupId
                          contentLanguage:contentLanguage
                         voicePrintPhrase:voicePrintPhrase
              userIdentificationCancelled:userIdentificationCancelled
             userIdentificationSuccessful:userIdentificationSuccessful
                 userIdentificationFailed:userIdentificationFailed
    ];
}

- (void)encapsulatedVoiceIdentification:(NSString *)groupId
                        contentLanguage:(NSString*)contentLanguage
                       voicePrintPhrase:(NSString*)voicePrintPhrase
                        numFailsAllowed:(int)numFailsAllowed
            userIdentificationCancelled:(void (^)(void))userIdentificationCancelled
           userIdentificationSuccessful:(void (^)(float, NSString *, NSString *))userIdentificationSuccessful
               userIdentificationFailed:(void (^)(float, NSString *))userIdentificationFailed
{
    
    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Encapsulated Voice Identification"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }
    
    VoiceIdentificationViewController *identifyVC = [[Utilities getVoiceItStoryBoard] instantiateViewControllerWithIdentifier:@"identifyVoiceVC"];
    identifyVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    identifyVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    identifyVC.groupToIdentifyGroupId = groupId;
    identifyVC.contentLanguage = contentLanguage;
    identifyVC.thePhrase = voicePrintPhrase;
    identifyVC.failsAllowed = numFailsAllowed;
    identifyVC.userIdentificationCancelled = userIdentificationCancelled;
    identifyVC.userIdentificationSuccessful = userIdentificationSuccessful;
    identifyVC.userIdentificationFailed = userIdentificationFailed;
    identifyVC.voiceItMaster = self;
    [[self masterViewController] presentViewController: identifyVC animated:YES completion:nil];
}

#pragma mark - Verification API Calls

- (void)voiceVerification:(NSString *)userId
          contentLanguage:(NSString*)contentLanguage
                audioPath:(NSString*)audioPath
                   phrase:(NSString*)phrase
                 callback:(void (^)(NSString *))callback
{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Video Verification"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"verification/voice"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"contentLanguage" : contentLanguage, @"userId": userId, @"phrase" : phrase };
    NSMutableData *body = [NSMutableData data];

    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath:audioPath fieldName:@"recording"];
    [self endBody:body];

    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];

        if(callback){
            callback(result);
        }
    }];

    [task resume];
}

- (void)faceVerification:(NSString *)userId
               videoPath:(NSString*)videoPath
                callback:(void (^)(NSString *))callback
{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Face Verification"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"verification/face"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"userId": userId};
    NSMutableData *body = [NSMutableData data];
    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath: videoPath fieldName:@"video"];
    [self endBody:body];

    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];

    [task resume];
}

- (void)faceVerification:(NSString *)userId
               imageData:(NSData*)imageData
                callback:(void (^)(NSString *))callback
{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Face Verification"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"verification/face"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"userId": userId};
    NSMutableData *body = [NSMutableData data];
    [self addParamsToBody:body parameters:params];
    [self addImageToBody:body imageData:imageData fieldName:@"photo"];
    [self endBody:body];

    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];

    [task resume];
}

- (void)videoVerification:(NSString *)userId
          contentLanguage:(NSString*)contentLanguage
                imageData:(NSData*)imageData
                audioPath:(NSString*)audioPath
                   phrase:(NSString*)phrase
                 callback:(void (^)(NSString *))callback
{

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Video Verification"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"verification/video"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"contentLanguage" : contentLanguage, @"userId": userId, @"phrase" : phrase };
    NSMutableData *body = [NSMutableData data];

    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath:audioPath fieldName:@"audio"];
    [self addImageToBody:body imageData:imageData fieldName:@"photo"];
    [self endBody:body];

    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];
    [task resume];
}

- (void)videoVerification:(NSString *)userId
          contentLanguage:(NSString*)contentLanguage
                videoPath:(NSString*)videoPath
                   phrase:(NSString*)phrase
                 callback:(void (^)(NSString *))callback {

    if([userId isEqualToString:@""] || ![[self getFirst:userId numChars:4] isEqualToString:@"usr_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Video Verification"
                                       reason:@"Invalid userId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"verification/video"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];

    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"contentLanguage" : contentLanguage, @"userId": userId, @"phrase" : phrase };
    NSMutableData *body = [NSMutableData data];

    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath:videoPath fieldName:@"video"];
    [self endBody:body];

    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];
    [task resume];
}

#pragma mark - Identification API Calls
- (void)voiceIdentification:(NSString *)groupId
            contentLanguage:(NSString*)contentLanguage
                  audioPath:(NSString*)audioPath
                     phrase:(NSString*)phrase
                   callback:(void (^)(NSString *))callback
{

    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Voice Identification"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"identification/voice"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"contentLanguage" : contentLanguage, @"groupId": groupId, @"phrase" : phrase };
    NSMutableData *body = [NSMutableData data];

    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath:audioPath fieldName:@"recording"];
    [self endBody:body];

    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];

    [task resume];
}

- (void)faceIdentification:(NSString *)groupId
                 imageData:(NSData*)imageData
                  callback:(void (^)(NSString *))callback{
    
    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Face Identification"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"identification/face"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"groupId": groupId};
    NSMutableData *body = [NSMutableData data];
    [self addParamsToBody:body parameters:params];
    [self addImageToBody:body imageData:imageData fieldName:@"photo"];
    [self endBody:body];
    
    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];
    
    [task resume];
}

- (void)faceIdentification:(NSString *)groupId
                  videoPath:(NSString*)videoPath
                   callback:(void (^)(NSString *))callback
{
    
    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Face Identification"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"identification/face"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"groupId": groupId};
    NSMutableData *body = [NSMutableData data];
    
    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath:videoPath fieldName:@"video"];
    [self endBody:body];
    
    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];
    
    [task resume];
}

- (void)videoIdentification:(NSString *)groupId
            contentLanguage:(NSString*)contentLanguage
                  videoPath:(NSString*)videoPath
                     phrase:(NSString*)phrase
                   callback:(void (^)(NSString *))callback
{

    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Video Identification"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"identification/video"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];

    NSDictionary *params = @{@"contentLanguage" : contentLanguage, @"groupId": groupId, @"phrase" : phrase };
    NSMutableData *body = [NSMutableData data];

    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath:videoPath fieldName:@"video"];
    [self endBody:body];

    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];

    [task resume];
}

- (void)videoIdentification:(NSString *)groupId
            contentLanguage:(NSString*)contentLanguage
                  imageData:(NSData*)imageData
                  audioPath:(NSString*)audioPath
                     phrase:(NSString*)phrase
                   callback:(void (^)(NSString *))callback{
    
    if([groupId isEqualToString:@""] || ![[self getFirst:groupId numChars:4] isEqualToString:@"grp_"]){
        @throw [NSException exceptionWithName:@"Cannot Call Video Identification"
                                       reason:@"Invalid groupId passed"
                                     userInfo:nil];
        return;
    }
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", self.boundary];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[[NSURL alloc] initWithString:[self buildURL:@"identification/video"]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"41" forHTTPHeaderField:@"platformId"];
    [request addValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"contentLanguage" : contentLanguage, @"groupId": groupId, @"phrase" : phrase };
    NSMutableData *body = [NSMutableData data];
    
    [self addParamsToBody:body parameters:params];
    [self addFileToBody:body filePath:audioPath fieldName:@"audio"];
    [self addImageToBody:body imageData:imageData fieldName:@"photo"];
    [self endBody:body];
    
    NSURLSessionDataTask *task =  [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result =
        [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
        if(callback){
            callback(result);
        }
    }];
    [task resume];
}

#pragma mark - Utilities
-(NSString*)getFirst:(NSString *)str numChars:(int)numChars{
    return [str substringWithRange:NSMakeRange(0, numChars)];
}

-(NSString*)buildURL:(NSString*)endpoint
{
    return [[NSString alloc] initWithFormat:@"%@%@", host, endpoint];
}

-(NSString*)createAuthHeader
{
    // Create NSData object
    NSData *nsdata = [[NSString stringWithFormat:@"%@:%@", self.apiKey, self.apiToken]
                      dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];

    return [NSString stringWithFormat:@"Basic %@", base64Encoded];
}

- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

- (void)addParamsToBody:(NSMutableData *)httpBody parameters:(NSDictionary *)parameters {
    // add params (all params are strings)
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
}

-(void)addFileToBody:(NSMutableData *)httpBody filePath:(NSString *)filePath fieldName:(NSString *)fieldName{
    NSString *filename  = [filePath lastPathComponent];
    NSData   *data      = [NSData dataWithContentsOfFile:filePath];
    NSString *mimetype  = [self mimeTypeForPath:filePath];

    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:data];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)addImageToBody:(NSMutableData *)httpBody imageData:(NSData *)imageData fieldName:(NSString *)fieldName{
    NSString *filename  = @"frame.jpg";
    NSString *mimetype  = @"image/jpeg";
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:imageData];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)endBody:(NSMutableData *)body{
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName
{
    NSMutableData *httpBody = [NSMutableData data];

    // add params (all params are strings)

    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];

    // add audio data

    for (NSString *path in paths) {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];

        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    return httpBody;
}

- (NSString *)mimeTypeForPath:(NSString *)path
{
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    CFRelease(UTI);
    return mimetype;
}
@end
