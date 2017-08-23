//
//  UserLiveHttpService.h
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HttpClientService.h"

@interface UserLiveHttpService : HttpClientService

- (void)createChatroom:(NSString* _Nullable)roomName announcement:(NSString* _Nullable)announcement broadCastUrl:(NSString*_Nullable)broadCasturl accId:(NSString*_Nullable)accId completion:(HttpClientServiceObjectBlock _Nullable)completion;

- (void)getChatroomInfoNeedOnlineUserCount:(NSString*_Nullable)need accId:(NSString*_Nullable)accId completion:(HttpClientServiceObjectBlock _Nullable)completion;

- (void)sendChatroomMsg:(NSString*_Nullable)content msgType:(NSString*_Nullable)msgType roomId:(NSString*_Nullable)roomId msgId:(NSString*_Nullable)msgId accId:(NSString*_Nullable)accId completion:(HttpClientServiceObjectBlock _Nullable)completion;

- (void)startLivePushByCid:(NSString*_Nullable)cid title:(NSString*_Nullable)title completion:(HttpClientServiceObjectBlock _Nullable)completion;
- (void)closeLivePushByCid:(NSString*_Nullable)cid completion:(HttpClientServiceObjectBlock _Nullable)completion;
@end
