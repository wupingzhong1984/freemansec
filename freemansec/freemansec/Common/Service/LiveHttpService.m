//
//  LiveHttpService.m
//  freemansec
//
//  Created by adamwu on 2017/7/17.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveHttpService.h"
#import "JsonResponse.h"
#import "LiveSectionChannelModel.h"

static NSString* GetLiveBannerPath = @"ajax/GetLive.ashx";

@implementation LiveHttpService

-(void)getLiveBannerByLiveTypeId:(NSString*)typeId
                      completion:(HttpClientServiceObjectBlock)complete {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetLiveBannerPath
                     params:@{@"typeid":typeId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         complete(response, err);
                         return ;
                     }
                     
                     NSArray *list = [LiveSectionChannelModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
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
                       path:GetLiveBannerPath
                     params:@{@"typeid":typeId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         complete(response, err);
                         return ;
                     }
                     
                     NSArray *list = [LiveSectionChannelModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         complete(nil, err);
                     }else{
                         complete(list, nil); //success
                     }
                 }];
}
@end
