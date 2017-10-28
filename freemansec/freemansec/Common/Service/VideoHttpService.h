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

- (void)getVideoListPageNum:(NSString*)pageNum completion:(HttpClientServiceObjectBlock)completion;

- (void)addVideoPlayCount:(NSString*)videoId completion:(HttpClientServiceObjectBlock)completion;

- (void)getVideoListByType:(NSString*)type typeId:(NSString*)typeId user:(NSString*)user completion:(HttpClientServiceObjectBlock)completion;

@end
