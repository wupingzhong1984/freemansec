//
//  MessageManager.h
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MsgListCompletion)(NSArray* _Nullable msgList, NSError* _Nullable error);

@interface MessageManager : NSObject
+ (MessageManager* _Nonnull)sharedInstance;
- (void)getMsgListPageNum:(NSInteger)pageNum completion:(MsgListCompletion _Nullable)completion;
@end
