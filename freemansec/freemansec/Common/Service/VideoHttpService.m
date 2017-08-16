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
- (void)getVideoListPageNum:(NSString*)pageNum pageSize:(NSString*)pageSize status:(NSString*)status type:(NSString*)type completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetVideoListPath
                     params:@{@"currentPage":pageNum,
                              @"pageSize":pageSize,
                              @"status":status,
                              @"type":type
                                  }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *videoList = (NSArray*)[(NSDictionary*)response.data objectForKey:@"list"];
                     if (!videoList || videoList.count == 0) {
                         
                         completion(nil,nil);
                         return;
                     }
                     
                     NSArray *list = [VideoModel arrayOfModelsFromDictionaries:videoList error:&err];
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
