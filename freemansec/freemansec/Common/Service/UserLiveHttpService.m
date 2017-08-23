//
//  UserLiveHttpService.m
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserLiveHttpService.h"

static NSString* CreateChatRoomPath = @"Ajax/CreateChatroom.ashx";
static NSString* GetChatRoomInfoPath = @"Ajax/GetChatroom.ashx";
static NSString* SendMsgPath = @"Ajax/sendMsg.ashx";
static NSString* StartLivePath = @"Ajax/openLive.ashx";
static NSString* CloseLivePath = @"Ajax/closeLive.ashx";

@implementation UserLiveHttpService

- (void)createChatroom:(NSString* _Nullable)roomName announcement:(NSString* _Nullable)announcement broadCastUrl:(NSString*_Nullable)broadCasturl accId:(NSString*_Nullable)accId completion:(HttpClientServiceObjectBlock _Nullable)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:CreateChatRoomPath
                     params:@{@"creator":accId,
                              @"name":roomName,
                              @"announcement":announcement,
                              @"broadcasturl":broadCasturl,
                              @"ext":@"",
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
                     }
                     
                     NSString *roomId = [(NSDictionary*)response.data objectForKey:@"roomid"];
                     if(roomId == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(roomId, nil); //success
                     }
                 }];

}

- (void)getChatroomInfoNeedOnlineUserCount:(NSString*_Nullable)need accId:(NSString*_Nullable)accId completion:(HttpClientServiceObjectBlock _Nullable)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetChatRoomInfoPath
                     params:@{@"accid":accId,
                              @"needOnlineUserCount":need
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
                     }
                     
                     ChatroomInfoModel* model = [[ChatroomInfoModel alloc] initWithDictionary:(NSDictionary*)response.data error:&err];
                     if(model == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(model, nil); //success
                     }
                 }];
}

- (void)sendChatroomMsg:(NSString*_Nullable)content msgType:(NSString*_Nullable)msgType roomId:(NSString*_Nullable)roomId msgId:(NSString*_Nullable)msgId accId:(NSString*_Nullable)accId completion:(HttpClientServiceObjectBlock _Nullable)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:SendMsgPath
                     params:@{@"roomid":roomId,
                              @"msgId":msgId,
                              @"fromAccid":accId,
                              @"msgType":msgType,
                              @"attach":content
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}

- (void)startLivePushByCid:(NSString*_Nullable)cid title:(NSString*)title completion:(HttpClientServiceObjectBlock _Nullable)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:StartLivePath
                     params:@{@"cid":cid,
                              @"title":title
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}

- (void)closeLivePushByCid:(NSString*_Nullable)cid completion:(HttpClientServiceObjectBlock _Nullable)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:CloseLivePath
                     params:@{@"cid":cid
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}
@end
