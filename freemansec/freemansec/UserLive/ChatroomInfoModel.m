//
//  ChatroomInfoModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/14.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "ChatroomInfoModel.h"

@implementation ChatroomInfoModel
+(JSONKeyMapper*)keyMapper
{   
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"roomId": @"roomid",
                                            @"valid": @"valid",
                                            @"muted": @"muted",
                                            @"onlineUserCount": @"onlineusercount",
                                            @"announcement": @"announcement",
                                            @"roomName": @"name",
                                            @"broadcasturl": @"broadcasturl",
                                            @"ext": @"ext",
                                            @"creatorUserLoginId": @"creator"}];
}
@end
