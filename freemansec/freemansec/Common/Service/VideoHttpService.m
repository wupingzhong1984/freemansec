//
//  VideoHttpService.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VideoHttpService.h"
#import "VideoModel.h"
#import "CommonVideoModel.h"

static NSString* GetVideoListPath = @"Ajax/queryVideo.ashx";
static NSString* AddVideoPlayCountPath = @"Ajax/addvideocount.ashx";
static NSString* GetVideoListPath2 = @"Ajax/getVedioListByUser.ashx";

@implementation VideoHttpService
- (void)getVideoListPageNum:(NSString*)pageNum completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetVideoListPath
                     params:@{@"pnum":pageNum}
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [VideoModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}

- (void)addVideoPlayCount:(NSString*)videoId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:AddVideoPlayCountPath
                     params:@{@"vid":videoId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response,err);
                 }];
}

- (void)getVideoListByType:(NSString*)type typeId:(NSString*)typeId user:(NSString*)user completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetVideoListPath2
                     params:([type isEqualToString:@"0"]?
                             @{@"type":@"0",@"typeid":typeId}:
                             @{@"type":@"1",@"cid":user})
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [CommonVideoModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];

}
@end
