//
//  ConsumeRecordModel.m
//  freemansec
//
//  Created by adamwu on 2017/11/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "ConsumeRecordModel.h"

@implementation ConsumeRecordModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"typeStr": @"consumptiontypes",
                                            @"typeId": @"typeid",
                                            @"amount": @"consumptionamount",
                                            @"addTime": @"addtime",
                                            @"desc": @"describtion"}];
}
@end
