//
//  VideoHttpService.h
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HttpClientService.h"

@interface VideoHttpService : HttpClientService

//- (void)getVideoKindCompletion:(HttpClientServiceObjectBlock)completion;
//
//- (void)getVideoListByKindId:(NSString*)kindId completion:(HttpClientServiceObjectBlock)completion;

- (void)getVideoListPageNum:(NSString*)pageNum pageSize:(NSString*)pageSize status:(NSString*)status type:(NSString*)type completion:(HttpClientServiceObjectBlock)completion;

- (void)addVideoPlayCount:(NSString*)videoId completion:(HttpClientServiceObjectBlock)completion;
@end
