//
//  LiveProgramModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/31.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveProgramModel.h"

@implementation LiveProgramModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"programId": @"ID",
                                            @"weekDay": @"WEEKDAY",
                                            @"startTime": @"START_TIME",
                                            @"endTime": @"END_TIME",
                                            @"categoryName": @"CATEGORY",
                                            @"title": @"TITLE",
                                            @"desc": @"DESC",
                                            @"anchorName": @"SPEAKER",
                                            @"liveImg": @"IMAGE_URL",
                                            @"liveLink": @"LINK",
                                            @"status": @"PLAY_STATUS"}];
}

@end
