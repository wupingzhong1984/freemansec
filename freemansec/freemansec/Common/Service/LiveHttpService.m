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
#import "ChatroomInfoModel.h"
#import "LiveDetailNTModel.h"

static NSString* GetLiveBannerPath = @"Ajax/GetBanner.ashx";
static NSString* GetLiveListByTypePath = @"Ajax/GetLive.ashx";
static NSString* GetLiveSearchHotWordsPath = @"Ajax/GetLive.ashx"; //todo
static NSString* QueryLivePath = @"Ajax/QueryLiveInfo.ashx";
static NSString* GetLiveDetailPath = @"Ajax/QueryLiveToCid.ashx";
static NSString* GetChatroomByUserLiveIdPath = @"Ajax/getChatrommByUser.ashx";

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

- (void)queryLiveByWord:(NSString *)word pageNum:(NSInteger)num completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:QueryLivePath
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
- (void)queryLiveByType:(NSString*)typeId pageNum:(NSInteger)num completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:QueryLivePath
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

- (void)queryLiveDetailByCId:(NSString*)cid completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetLiveDetailPath
                     params:@{@"cid":cid}
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
                     }
                     
                     LiveDetailNTModel* model = [[LiveDetailNTModel alloc] initWithDictionary:(NSDictionary*)response.data error:&err];
                     if(model == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(model, nil); //success
                     }
                 }];
}

- (void)getChatroomByUserLiveId:(NSString*)liveId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetChatroomByUserLiveIdPath
                     params:@{@"liveid":liveId}
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
                     }
                     
                     ChatroomInfoModel* model = [[ChatroomInfoModel alloc] initWithDictionary:(NSDictionary*)response.data error:&err];
                     if(model == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(model, nil); //success
                     }
                 }];
}
@end
