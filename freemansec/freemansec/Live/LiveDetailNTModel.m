//
//  LiveDetailNTModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/26.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveDetailNTModel.h"

@implementation LiveDetailNTModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"needRecord": @"needRecord",
                                            @"uid": @"uid",
                                            @"duration": @"duration",
                                            @"status": @"status",
                                            @"name": @"name",
                                            @"filename": @"filename",
                                            @"format": @"format",
                                            @"type": @"type",
                                            @"ctime": @"ctime",
                                            @"cid": @"cid",
                                            @"recordStatus": @"recordStatus"}];
}

@end
