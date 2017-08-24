//
//  MessageHttpService.h
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HttpClientService.h"

@interface MessageHttpService : HttpClientService
- (void)getMsgListPageNum:(NSInteger)pageNum userId:(NSString*_Nullable)userId completion:(HttpClientServiceObjectBlock _Nullable)completion;
@end
