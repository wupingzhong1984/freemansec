//
//  VideoKindModel.m
//  freemansec
//
//  Created by adamwu on 2017/7/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VideoKindModel.h"

@implementation VideoKindModel
+(JSONKeyMapper*)keyMapper
{   //todo
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"kindId": @"id",
                                            @"kindName": @"kindName"}];
}
@end
