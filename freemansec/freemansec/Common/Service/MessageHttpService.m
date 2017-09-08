//
//  MessageHttpService.m
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MessageHttpService.h"
#import "MsgModel.h"

static NSString* GetMsgListPath = @"Ajax/getMsg.ashx";
static NSString* GetNewMsgCountPath = @"Ajax/getNewMsgCount.ashx";

@implementation MessageHttpService
- (void)getMsgListLastMsgId:(NSString* _Nonnull)msgId completion:(HttpClientServiceObjectBlock _Nullable)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetMsgListPath
                     params:@{@"lastmsgid":msgId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [MsgModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}

- (void)getNewMsgCountCompletion:(HttpClientServiceObjectBlock _Nullable)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetNewMsgCountPath
                     params:nil
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     if ([response.code integerValue] == 1 || !response.data || ![(NSDictionary*)response.data objectForKey:@"msgcount"]) {
                         
                         completion(0,err);
                         return;
                     }
                     
                     NSInteger count = [[(NSDictionary*)response.data objectForKey:@"msgcount"] integerValue];
                     completion([NSNumber numberWithInteger:count], nil); //success
                 }];
}

- (void)getNewMsgListCompletion:(HttpClientServiceObjectBlock _Nullable)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetMsgListPath
                     params:nil
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [MsgModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
     
}
@end
