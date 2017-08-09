//
//  ProvinceModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/9.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "ProvinceModel.h"

@implementation ProvinceModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"provinceId": @"provinceID",
                                                                  @"name": @"province"
                                                                  }];
}
@end
