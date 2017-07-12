//
//  TYResponseObject.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYResponseObject.h"
#import "TYJSONModel.h"

@interface TYResponseObject ()
@property (nonatomic, assign) Class modelClass;
@end

@implementation TYResponseObject

- (instancetype)initWithModelClass:(Class)modelClass
{
    if (self = [super init]) {
        _modelClass = modelClass;
    }
    return self;
}

- (BOOL)isValidResponse:(id)response request:(TYHttpRequest *)request error:(NSError *__autoreleasing *)error
{
    if (!response) {
        return NO;
    }
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)request.dataTask.response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    
    // StatusCode
    if (responseStatusCode < 200 || responseStatusCode > 299) {
        *error = [NSError errorWithDomain:@"invalid http request" code: responseStatusCode userInfo:nil];
        return NO;
    }
    
    // 根据 response 结构 应该为字典
    if (![response isKindOfClass:[NSDictionary class]]) {
        *error = [NSError errorWithDomain:@"response is invalide, is not NSDictionary" code:-1  userInfo:nil];
        return NO;
    }
    
    // 获取自定义的状态码
    //    NSInteger status = [[response objectForKey:@"code"] integerValue];
    //    if (status != TYStauteSuccessCode) {
    //        _status = status;
    //        _msg = [response objectForKey:@"message"];
    //        *error = [NSError errorWithDomain:NSURLErrorDomain code:_status  userInfo:nil];
    //        return NO;
    //    }
    
    //lulu diy check
    NSLog(@"response :%@",response);
    
    NSInteger fault = [[response objectForKey:@"fault"] integerValue];
    if (fault != 0) {
        
//        _status = [[response objectForKey:@"errorCode"] integerValue];
//        NSString *msg = [response objectForKey:@"errorMessage"];
//        _msg = msg?msg:@"";
//        *error = [NSError errorWithDomain:_msg code:_status  userInfo:nil];
        return NO;
    }
    
    return YES;
}

- (id)parseResponse:(id)response request:(TYHttpRequest *)request
{
    _status = [[response objectForKey:@"fault"] integerValue];
    _msg = @"";
    _data = response;
//    _pgIndex = [[response objectForKey:@"pgIndex"] integerValue];
//    _pgSize = [[response objectForKey:@"pgSize"] integerValue];
//    _count = [[response objectForKey:@"count"] integerValue];
    
//    if (_modelClass) {
//        if ([json isKindOfClass:[NSDictionary class]]) {
//            _json = [[self modelClass] ty_ModelWithDictonary:json];
//        }else if ([json isKindOfClass:[NSArray class]]) {
//            _json = [[self modelClass] ty_modelArrayWithDictionaryArray:json];
//        }
//    }else {
//        _json = json;
//    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nstatus:%d\nmsg:%@\n",(int)_status,_msg];
}

//- (void)dealloc
//{
//    NSLog(@"%@%s",NSStringFromClass([self class]),__func__);
//}

@end
