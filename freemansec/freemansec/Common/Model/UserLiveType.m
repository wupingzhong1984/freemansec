//
//  UserLiveType.m
//  freemansec
//
//  Created by adamwu on 2017/8/8.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserLiveType.h"

@implementation UserLiveType
+(JSONKeyMapper*)keyMapper
{
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"liveTypeId": @"id",
                                                                  @"liveTypeName": @"typename",
                                                                  
                                                                  @"liveTypeImg":@"liveTypeImg"
                                                                  }];
}
@end
