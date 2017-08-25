//
//  LiveSearchResultModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/13.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveSearchResultModel.h"

@implementation LiveSearchResultModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"liveId": @"id",
                                            @"liveTypeId": @"liveTypeId",
                                            @"liveTypeName": @"liveTypeName",
                                            @"liveName": @"liveName",
                                            @"liveImg": @"liveImg",
                                            @"liveIntroduce": @"liveIntroduce",
                                            @"livelink": @"liveLink",
                                            @"anchorId": @"liveAnchor",
                                            @"nickName": @"nickName",
                                            @"headImg": @"headImg",
                                            @"cid": @"cid",
                                            @"httpPullUrl": @"httpPullUrl",
                                            @"hlsPullUrl": @"hlsPullUrl",
                                            @"rtmpPullUrl": @"rtmpPullUrl",
                                            @"pushUrl": @"pushUrl",
                                            @"addTime": @"addtime",
                                            @"isDelete": @"isdel",
                                            @"state":@"state",
                                            @"isAttent": @"isconcerns"}];
}

@end
