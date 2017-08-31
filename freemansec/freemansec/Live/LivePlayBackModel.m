//
//  LivePlayBackModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/31.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LivePlayBackModel.h"

@implementation LivePlayBackModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"playbackId": @"ID",
                                            @"categoryName": @"CATEGORY",
                                            @"title": @"TITLE",
                                            @"desc": @"DESC",
                                            @"url": @"URL",
                                            @"liveImg": @"IMAGE_URL",
                                            @"createTime": @"UPLOAD_DATE",
                                            @"playCount": @"HIT_RATE"}];
}
@end
