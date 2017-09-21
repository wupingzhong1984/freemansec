//
//  OfficalVideoModel.m
//  freemansec
//
//  Created by adamwu on 2017/9/20.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "OfficalVideoModel.h"

@implementation OfficalVideoModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"videoId": @"ID",
                                            @"videoCategory": @"CATEGORY",
                                            @"videoName": @"TITLE",
                                            @"desc": @"DESC",
                                            @"origUrl": @"URL",
                                            @"snapshotUrl": @"IMAGE_URL",
                                            @"createTime": @"UPLOAD_DATE",
                                            @"playCount": @"HIT_RATE"}];
}
@end
