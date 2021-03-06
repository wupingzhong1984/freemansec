//
//  MsgModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MsgModel.h"

@implementation MsgModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"msgId": @"id",
                                            @"senderUser": @"sendUser",
                                            @"content": @"msgText",
                                            @"time": @"createtime",
                                            @"isRead": @"isRead"}];
}
@end
