//
//  CityModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/9.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"cityId": @"cityID",
                                                                  @"name": @"city"
                                                                  }];
}
@end
