//
//  IMTokenModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/7.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "IMTokenModel.h"

@implementation IMTokenModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"token": @"token",
                                                                  @"accId": @"accid"
                                                                  }];
}
@end
