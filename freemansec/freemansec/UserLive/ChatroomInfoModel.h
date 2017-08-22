//
//  ChatroomInfoModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/14.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface ChatroomInfoModel : JSONModel
@property (nonatomic,strong) NSString<Optional>* roomId;
@property (nonatomic,strong) NSString<Optional>* valid;
@property (nonatomic,strong) NSString<Optional>* muted; //聊天室是否处于全体禁言状态，全体禁言时仅管理员和创建者可以发言
@property (nonatomic,strong) NSString<Optional>* onlineUserCount;

@property (nonatomic,strong) NSString<Optional>* announcement;
@property (nonatomic,strong) NSString<Optional>* roomName;
@property (nonatomic,strong) NSString<Optional>* broadcasturl;
@property (nonatomic,strong) NSString<Optional>* ext;
@property (nonatomic,strong) NSString<Optional>* creatorUserLoginId; //userloginid accid
@end
