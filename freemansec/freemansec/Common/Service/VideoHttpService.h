//
//  VideoHttpService.h
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HttpClientService.h"

@interface VideoHttpService : HttpClientService

- (void)getVideoKindCompletion:(HttpClientServiceObjectBlock)completion;

- (void)getVideoListByKindId:(NSString*)kindId completion:(HttpClientServiceObjectBlock)completion;
@end
