//
//  VideoHttpService.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VideoHttpService.h"
#import "VideoModel.h"

static NSString* GetVideoListPath = @"Ajax/queryVideo.ashx";
static NSString* AddVideoPlayCountPath = @"Ajax/addvideocount.ashx";

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
@end
