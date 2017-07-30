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
{   //todo
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"videoId": @"id",
                                            @"videoImg": @"videoImg",
                                            @"videoName": @"videoName",
                                            @"authorName": @"authorName",
                                            @"playCount": @"playCount"}];
}
@end
