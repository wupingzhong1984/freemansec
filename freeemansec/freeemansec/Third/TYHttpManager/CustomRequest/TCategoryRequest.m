//
//  TCategoryRequest.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TCategoryRequest.h"

@implementation TCategoryRequest

+ (instancetype)requestWithGender:(NSString *)gender generation:(NSString *)generation
{
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的数据是一个字典
    [params setObject:@"30" forKey:@"requestType"];
    [params setObject:@"" forKey:@"deviceId"];
    [params setObject:@"APP_IOS" forKey:@"sysCode"];
//    [params setObject:@"oyuxGv6Gj6fy5GMNIy9SOlZU6ecU" forKey:@"userId"];
    
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    
    [arguments setObject:@"SH" forKey:@"cityCode"];
        [arguments setObject:[NSNumber numberWithInt:1] forKey:@"pageNo"];
        [arguments setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    
    [params setObject:arguments forKey:@"arguments"];
    
    TCategoryRequest *request = [TCategoryRequest requestWithModelClass:[NSObject class]];
    // 可以在appdeleagte 里 设置 TYRequstConfigure baseURL
    request.URLString = @"http://jietuapp.com:8080/app-wg/gateway";
    request.parameters = params;
    request.method = TYRequestMethodPost;
    return request;
}

@end
