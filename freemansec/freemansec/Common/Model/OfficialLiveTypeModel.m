//
//  OfficialLiveTypeModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/7.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "OfficialLiveTypeModel.h"

@implementation OfficialLiveTypeModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"liveTypeId": @"id",
                                            @"liveTypeName": @"liveTypeName",
                                            @"liveTypeImg": @"liveTypeImg"}];
}
@end
