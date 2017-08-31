//
//  MessageManager.h
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MsgListCompletion)(NSArray* _Nullable msgList, NSError* _Nullable error);
typedef void(^NewMsgCountCompletion)(NSInteger count, NSError* _Nullable error);

@interface MessageManager : NSObject
+ (MessageManager* _Nonnull)sharedInstance;
- (void)getMsgListLastMsgId:(NSString* _Nonnull)msgId completion:(MsgListCompletion _Nullable)completion;
- (void)getNewMsgCountCompletion:(NewMsgCountCompletion _Nullable)completion;
- (void)getNewMsgListCompletion:(MsgListCompletion _Nullable)completion;

- (void)insertMsgList:(NSArray*_Nullable)msgList;
- (NSMutableArray*_Nullable)getLocalMsgListOrderByMsgIdDESC;
- (BOOL)updateAllLocalMsgReaded;
@end
