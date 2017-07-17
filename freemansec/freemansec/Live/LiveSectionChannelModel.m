//
//  LiveSectionChannelModel.m
//  freemansec
//
//  Created by adamwu on 2017/7/13.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveSectionChannelModel.h"

@implementation LiveSectionChannelModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"id": @"typeId",
                                            @"liveName": @"liveName",
                                            @"liveImg": @"liveImg",
                                            @"liveIntroduce": @"liveIntroduce",
                                            @"aid": @"anchorId",
                                            @"anchorName": @"anchorName",
                                            @"anchorImg": @"anchorImg",
                                            @"anchorIntroduce": @"anchorIntroduce"}];
}
@end
