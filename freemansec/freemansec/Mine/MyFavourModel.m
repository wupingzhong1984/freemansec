//
//  MyFavourModel.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyFavourModel.h"

@implementation MyFavourModel
+(JSONKeyMapper*)keyMapper
{   //todo
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"fId": @"fId",
                                            @"img": @"img",
                                            @"title": @"title",
                                            @"anchorName": @"anchorName",
                                            @"playCount": @"playCount",
                                            @"fType": @"fType"}];
}
@end
