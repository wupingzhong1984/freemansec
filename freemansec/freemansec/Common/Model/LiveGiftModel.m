//
//  LiveGiftModel.m
//  freemansec
//
//  Created by adamwu on 2017/11/23.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveGiftModel.h"

@implementation LiveGiftModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"giftId": @"id",
                                            @"giftName": @"giftname",
                                            @"giftImg": @"giftimg",
                                            @"coin": @"coin"
                                            }];
}
@end
