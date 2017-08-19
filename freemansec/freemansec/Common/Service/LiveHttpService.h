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
- (void)quaryLiveByWord:(NSString *)word pageNum:(NSInteger)num completion:(HttpClientServiceObjectBlock)completion;
@end
