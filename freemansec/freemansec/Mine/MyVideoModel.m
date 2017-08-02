//
//  MyVideoModel.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyVideoModel.h"

@implementation MyVideoModel
+(JSONKeyMapper*)keyMapper
{   //todo
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"vid": @"id",
                                            @"img": @"videoImg",
                                            @"title": @"videoName",
                                            @"date": @"date",
                                            @"playCount": @"playCount"}];
}
@end
