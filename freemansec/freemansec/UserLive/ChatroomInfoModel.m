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
{   //todo
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"roomId": @"roomid",
                                            @"valid": @"Valid",
                                            @"muted": @"muted",
                                            @"onlineUserCount": @"onlineusercount"}];
}
@end
