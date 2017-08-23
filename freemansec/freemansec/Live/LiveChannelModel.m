//
//  LiveChannelModel.m
//  freemansec
//
//  Created by adamwu on 2017/7/13.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveChannelModel.h"

@implementation LiveChannelModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"liveId": @"id",
                                            @"liveName": @"liveName",
                                            @"liveImg": @"liveImg",
                                            @"liveIntroduce": @"liveIntroduce",
                                            @"liveLink": @"liveLink",
                                            @"anchorId": @"aid",
                                            @"anchorName": @"anchorName",
                                            @"anchorImg": @"anchorImg",
                                            @"anchorIntroduce": @"anchorIntroduce",
                                            @"isAttent": @"isconcerns"}];
}
@end
