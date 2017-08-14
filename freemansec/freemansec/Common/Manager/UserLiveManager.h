//
//  UserLiveManager.h
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatroomInfoModel.h"

typedef void(^CreateChatroomCompletion)(NSString*_Nullable roomId, NSError* _Nullable error);
typedef void(^GetChatroomInfoCompletion)(ChatroomInfoModel*_Nullable info, NSError* _Nullable error);
typedef void(^SendMsgCompletion)(NSError* _Nullable error);

@interface UserLiveManager : NSObject

+ (UserLiveManager* _Nonnull)sharedInstance;

- (void)createChatroom:(NSString* _Nullable)roomName announcement:(NSString* _Nullable)announcement broadCastUrl:(NSString*_Nullable)broadCasturl completion:(CreateChatroomCompletion _Nullable)completion;

- (void)getChatroomInfoNeedOnlineUserCount:(NSString*_Nullable)need completion:(GetChatroomInfoCompletion _Nullable)completion; //need: "true" or "false"

- (void)sendChatroomMsg:(NSString*_Nullable)content msgType:(NSString*_Nullable)msgType roomId:(NSString*_Nullable)roomId completion:(SendMsgCompletion _Nullable)completion;
@end
