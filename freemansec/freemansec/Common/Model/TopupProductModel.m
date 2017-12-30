//
//  TopupProductModel.m
//  freemansec
//
//  Created by adamwu on 2017/11/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "TopupProductModel.h"

@implementation TopupProductModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"productId": @"id",
                                            @"productName": @"productname",
                                            @"cost": @"cost",
                                            @"costDesc": @"costDesc",
                                            @"iApAppleId": @"iapappleid"
                                            }];
}
@end
