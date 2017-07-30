//
//  JsonResponse.m
//  freemansec
//
//  Created by adamwu on 2017/7/13.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JsonResponse.h"

@implementation JsonResponse

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                       @"code": @"code",
                                                       @"message": @"msg",
                                                       @"data": @"data"
                                                       }];
}
@end
