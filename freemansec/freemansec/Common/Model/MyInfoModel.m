//
//  MyInfoModel.m
//  freemansec
//
//  Created by adamwu on 2017/8/6.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyInfoModel.h"

@implementation MyInfoModel
+(JSONKeyMapper*)keyMapper
{   //todo
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{
                                            @"userLoginId": @"userLoginId",
                                            @"userId":@"id",
                                            @"nickName": @"nickName",
                                            @"phone": @"phone",
                                            @"email": @"email",
                                            @"realNameVerifyState": @"state",
                                            @"headImg": @"headImg",
                                            @"sex": @"sex",
                                            @"registerType": @"register",
                                            @"province": @"province",
                                            @"city": @"city",
                                            @"area": @"area",
                                            @"liveId": @"aid",
                                            @"liveLink": @"liveLink",
                                            @"liveTitle": @"liveName",
                                            @"liveImg": @"liveImg",
                                            @"liveTypeId": @"liveTypeId",
                                            @"pushUrl": @"pushUrl",
                                            @"rtmpPullUrl": @"rtmpPullUrl",
                                            @"hlsPullUrl": @"hlsPullUrl",
                                            @"httpPullUrl": @"httpPullUrl"
                                            }];
}
@end
