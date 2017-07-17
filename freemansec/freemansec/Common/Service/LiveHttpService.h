//
//  LiveHttpService.h
//  freemansec
//
//  Created by adamwu on 2017/7/17.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HttpClientService.h"

@interface LiveHttpService : HttpClientService

-(void)getLiveBannerByLiveTypeId:(NSString*)typeId
                      completion:(HttpClientServiceObjectBlock)complete;

-(void)getLiveListByLiveTypeId:(NSString*)typeId
                    completion:(HttpClientServiceObjectBlock)complete;
@end
