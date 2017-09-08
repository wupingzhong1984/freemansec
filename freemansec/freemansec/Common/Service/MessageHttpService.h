//
//  MessageHttpService.h
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HttpClientService.h"

@interface MessageHttpService : HttpClientService
- (void)getMsgListLastMsgId:(NSString* _Nonnull)msgId completion:(HttpClientServiceObjectBlock _Nullable)completion;

- (void)getNewMsgCountCompletion:(HttpClientServiceObjectBlock _Nullable)completion;

- (void)getNewMsgListCompletion:(HttpClientServiceObjectBlock _Nullable)completion;
@end
