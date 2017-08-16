//
//  VideoModel.m
//  freemansec
//
//  Created by adamwu on 2017/7/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
+(JSONKeyMapper*)keyMapper
{   
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"videoId": @"id",
                                            @"videoName": @"videoName",
                                            @"desc": @"description",
                                            @"duration": @"duration",
                                            @"snapshotUrl": @"snapshotUrl",
                                            @"videoOrigUrl": @"origUrl",
                                            @"createTime": @"createTime",
                                            @"authorName": @"userName",
                                            @"headImg": @"headimg",
                                            @"playCount": @"playcount"}];
}
@end
