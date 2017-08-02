//
//  MineHttpService.h
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HttpClientService.h"

@interface MineHttpService : HttpClientService

- (void)getMyVideoListByUserId:(NSString*)userId completion:(HttpClientServiceObjectBlock)complete;
- (void)getMyFavourListByUserId:(NSString*)userId completion:(HttpClientServiceObjectBlock)complete;
- (void)getMyAttentionListByUserId:(NSString*)userId completion:(HttpClientServiceObjectBlock)complete;
@end
