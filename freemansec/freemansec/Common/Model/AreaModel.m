//
//  AreaModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/9.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"areaId": @"areaID",
                                                                  @"name": @"area"
                                                                  }];
}
@end
