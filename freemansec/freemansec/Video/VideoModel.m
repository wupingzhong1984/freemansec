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
                                            @"videoId": @"vid",
                                            @"cId": @"cid",
                                            @"playCount": @"playcount",
                                            @"type": @"type",
                                            @"origVideoKey": @"orig_video_key",
                                            @"videoName": @"video_name",
                                            @"createTime": @"createtime",
                                            @"origUrl": @"origUrl",
                                            @"snapshotUrl": @"snapshotUrl",
                                            @"authorName": @"nickName",
                                            @"headImg": @"headImg",
                                            @"isFavour": @"iscollect"}];
}
@end
