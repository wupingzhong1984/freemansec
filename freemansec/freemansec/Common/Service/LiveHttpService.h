//
//  LiveHttpService.h
//  freemansec
//
//  Created by adamwu on 2017/7/17.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HttpClientService.h"

@interface LiveHttpService : HttpClientService

-(void)getLiveBannerCompletion:(HttpClientServiceObjectBlock)completion;

-(void)getLiveListByLiveTypeId:(NSString*)typeId
                    completion:(HttpClientServiceObjectBlock)completion;

-(void)getLiveSearchHotWordsCompletion:(HttpClientServiceObjectBlock)completion;
- (void)queryLiveByWord:(NSString *)word pageNum:(NSInteger)num completion:(HttpClientServiceObjectBlock)completion;
- (void)queryLiveByType:(NSString*)typeId pageNum:(NSInteger)num completion:(HttpClientServiceObjectBlock)completion;
- (void)queryLiveDetailByCId:(NSString*)cid completion:(HttpClientServiceObjectBlock)completion;
- (void)getChatroomByUserLiveId:(NSString*)liveId completion:(HttpClientServiceObjectBlock)completion;

- (void)getLiveProgramListCompletion:(HttpClientServiceObjectBlock)completion;
- (void)getLivePlayBackListByTypeId:(NSString*)typId completion:(HttpClientServiceObjectBlock)completion;

- (void)getKingProgramLiveTypeListCompletion:(HttpClientServiceObjectBlock)completion;
@end
