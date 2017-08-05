//
//  LiveHttpService.m
//  freemansec
//
//  Created by adamwu on 2017/7/17.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveHttpService.h"
#import "LiveChannelModel.h"

static NSString* GetLiveBannerPath = @"Ajax/GetBanner.ashx";
static NSString* GetLiveListByTypePath = @"Ajax/GetLive.ashx";

@implementation LiveHttpService

-(void)getLiveBannerCompletion:(HttpClientServiceObjectBlock)complete {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetLiveBannerPath
                     params:nil
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         complete(response, err);
                         return ;
                     }
                     
                     NSArray *list = [LiveChannelModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         complete(nil, err);
                     }else{
                         complete(list, nil); //success
                     }
                 }];
}

-(void)getLiveListByLiveTypeId:(NSString*)typeId
                    completion:(HttpClientServiceObjectBlock)complete {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetLiveListByTypePath
                     params:@{@"typeid":typeId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         complete(response, err);
                         return ;
                     }
                     
                     NSArray *list = [LiveChannelModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         complete(nil, err);
                     }else{
                         complete(list, nil); //success
                     }
                 }];
}
@end
