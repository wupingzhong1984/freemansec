//
//  UserLiveHttpService.h
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HttpClientService.h"

@interface UserLiveHttpService : HttpClientService

- (void)getLivePushStreamWithLiveTitle:(NSString*)title userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)complete;
@end
