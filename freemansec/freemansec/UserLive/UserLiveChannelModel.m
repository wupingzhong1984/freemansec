//
//  UserLiveChannelModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserLiveChannelModel.h"

@implementation UserLiveChannelModel
+(JSONKeyMapper*)keyMapper
{   //todo
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"cid": @"id",
                                            @"image": @"videoImg",
                                            @"title": @"videoName",
                                            @"pushUrl": @"date",
                                            @"pullUrlHttp": @"date",
                                            @"pullUrlHLS": @"date",
                                            @"pullUrlRtmp": @"date"}];
}
@end
