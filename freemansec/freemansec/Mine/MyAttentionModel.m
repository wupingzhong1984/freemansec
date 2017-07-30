//
//  MyAttentionModel.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyAttentionModel.h"

@implementation MyAttentionModel
+(JSONKeyMapper*)keyMapper
{   //todo
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"liveId": @"liveId",
                                            @"img": @"img",
                                            @"title": @"title",
                                            @"liveType": @"liveType",
                                            @"anchorName": @"anchorName"}];
}
@end
