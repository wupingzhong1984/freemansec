//
//  LiveHttpService.m
//  freemansec
//
//  Created by adamwu on 2017/7/17.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveHttpService.h"
#import "LiveChannelModel.h"
#import "LiveSearchResultModel.h"
#import "LiveHotWordModel.h"

static NSString* GetLiveBannerPath = @"Ajax/GetBanner.ashx";
static NSString* GetLiveListByTypePath = @"Ajax/GetLive.ashx";
static NSString* GetLiveSearchHotWordsPath = @"Ajax/GetLive.ashx"; //todo
static NSString* QuaryLivePath = @"Ajax/QueryLiveInfo.ashx";

@implementation LiveHttpService

-(void)getLiveBannerCompletion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetLiveBannerPath
                     params:nil
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [LiveChannelModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}

-(void)getLiveListByLiveTypeId:(NSString*)typeId
                    completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetLiveListByTypePath
                     params:@{@"typeid":typeId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [LiveChannelModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}

-(void)getLiveSearchHotWordsCompletion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetLiveSearchHotWordsPath
                     params:nil
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [LiveHotWordModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}

- (void)quaryLiveByWord:(NSString *)word pageNum:(NSInteger)num completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:QuaryLivePath
                     params:@{@"pnum":[NSString stringWithFormat:@"%d",(int)num],
                              @"livename":word}
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [LiveSearchResultModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}
- (void)quaryLiveByType:(NSString*)typeId pageNum:(NSInteger)num completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:QuaryLivePath
                     params:@{@"pnum":[NSString stringWithFormat:@"%d",(int)num],
                              @"livetypeid":typeId}
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [LiveSearchResultModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}

@end
