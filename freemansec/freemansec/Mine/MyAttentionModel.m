//
//  MyAttentionModel.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyAttentionModel.h"

@implementation MyAttentionModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"cId": @"cid",
                                            @"liveId": @"liveid",
                                            @"liveTypeName": @"liveTypeName",
                                            @"liveTypeId": @"liveTypeId",
                                            @"liveTitle": @"liveName",
                                            @"liveImg": @"liveImg",
                                            @"introduce": @"liveIntroduce",
                                            @"nickName": @"nickName",
                                            @"headImg": @"headImg"}];
}
@end
