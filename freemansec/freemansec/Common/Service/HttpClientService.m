//
//  HttpClientService.m
//  freemansec
//
//  Created by adamwu on 2017/7/13.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HttpClientService.h"
#import "JsonResponse.h"
#import "Error.h"

NSString* const LogicErrorDomain = @"freemansec.logic.error.domain";


@implementation HttpClientService

-(void) httpRequestMethod:(HttpReuqestMethod)method
                     path:(NSString*)path
                   params:(NSDictionary*)params
               completion:(HttpClientServiceObjectBlock)completion{

    NSString* url = [NSString stringWithFormat:@"%@/%@", BASE_URL, path];
    
    NNSLog(@"request:%@?%@", url,params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (method == HttpReuqestMethodGet) {
        
        [manager GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //test
            NNSLog(@"result:%@", responseObject);
            
            NSError* error = nil;
            
            JsonResponse* res = [[JsonResponse alloc] initWithDictionary:responseObject error:&error];
            
            if(error != nil){
                
                NSData* errData = [[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
                
                if(errData){
                    NSString* strData = [[NSString alloc] initWithData:errData encoding:NSUTF8StringEncoding];
                    NSLog(@"%@", strData);
                    NSLog(@"%@", error.localizedDescription);
                }
                else{
                    NSLog(@"%@", error);
                }
                
                completion(nil, error);
                return;
            }
            
            if(res == nil) {
                error = [NSError errorWithDomain:SystemErrorDomain
                                            code:SystemErrorWrongApiData
                                        userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(SystemErrorMessageWrongApiData, @"")}];
                completion(nil, error);
                return ;
                
            }
            
            if(![res.code isEqualToString:@"0"] && ![res.code isEqualToString:@"200"]) {
                error = [NSError errorWithDomain:LogicErrorDomain
                                            code:[res.code intValue]
                                        userInfo:@{NSLocalizedDescriptionKey:res.message}];
                completion(nil, error);
                return;
            }
            
            completion(res,nil);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@", error);
            completion(nil,error);
        }];
        
    } else if (method == HttpReuqestMethodPost) {
        
        [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //test
            NSLog(@"result:%@", responseObject);
            
            NSError* error = nil;
            
            JsonResponse* res = [[JsonResponse alloc] initWithDictionary:responseObject error:&error];
            
            if(error != nil){
                
                NSData* errData = [[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
                
                if(errData){
                    NSString* strData = [[NSString alloc] initWithData:errData encoding:NSUTF8StringEncoding];
                    NSLog(@"%@", strData);
                    NSLog(@"%@", error.localizedDescription);
                }
                else{
                    NSLog(@"%@", error);
                }
                
                completion(nil, error);
                return;
            }
            
            if(res == nil) {
                error = [NSError errorWithDomain:SystemErrorDomain
                                            code:SystemErrorWrongApiData
                                        userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(SystemErrorMessageWrongApiData, @"")}];
                completion(nil, error);
                return ;
                
            }
            
            if(![res.code isEqualToString:@"0"]) {
                error = [NSError errorWithDomain:LogicErrorDomain
                                            code:[res.code intValue]
                                        userInfo:@{NSLocalizedDescriptionKey:res.message}];
                completion(nil, error);
                return;
            }
            
            completion(res,nil);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            completion(nil, error);
        }];
        
    } else if (method == HttpReuqestMethodPut) {
        
        [manager PUT:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    } else if (method == HttpReuqestMethodDelete) {
        [manager DELETE:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
}

@end
