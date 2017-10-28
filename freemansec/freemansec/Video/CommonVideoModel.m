//
//  CommonVideoModel.m
//  freemansec
//
//  Created by adamwu on 2017/10/29.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "CommonVideoModel.h"

@implementation CommonVideoModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"videoId": @"id",
                                            @"videoName": @"videoname",
                                            @"headImg": @"headImg",
                                            @"nickName": @"nickname",
                                            @"playCount": @"playcount",
                                            @"liveType": @"livetype",
                                            @"addTime": @"addtime"}];
}
@end
