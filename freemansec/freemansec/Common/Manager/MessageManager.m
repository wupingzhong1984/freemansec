//
//  MessageManager.m
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MessageManager.h"
#import "MessageHttpService.h"

static MessageManager *instance;

@implementation MessageManager

- (id)init
{
    self = [super init];
    
    return self;
}

+ (MessageManager*)sharedInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)getMsgListLastMsgId:(NSString*)msgId completion:(MsgListCompletion _Nullable)completion {
    
    MessageHttpService* service = [[MessageHttpService alloc] init];
    [service getMsgListLastMsgId:msgId userId:[[MineManager sharedInstance] getMyInfo].userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}


- (void)getNewMsgCountCompletion:(NewMsgCountCompletion _Nullable)completion {
    
    MessageHttpService* service = [[MessageHttpService alloc] init];
    [service getNewMsgCountUserId:[[MineManager sharedInstance] getMyInfo].userId completion:^(id obj, NSError *err) {
        if(err || !obj){
            
            completion(0,err);
            
        } else {
            
            completion([obj integerValue],err);
        }
    }];
}

- (void)getNewMsgListCompletion:(MsgListCompletion _Nullable)completion {
    
    MessageHttpService* service = [[MessageHttpService alloc] init];
    [service getNewMsgListUserId:[[MineManager sharedInstance] getMyInfo].userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

- (void)insertMsgList:(NSArray*)msgList {
    
    if (!msgList || !msgList.count) {
        
        return;
    }
    
    for (MsgModel *model in msgList) {
        
        [[DataManager sharedInstance] insertMsg:model];
    }
    
}
- (NSMutableArray*)getLocalMsgListOrderByMsgIdDESC {
    
    return [[DataManager sharedInstance] getMsgListOrderByMsgIdDESC];
}

- (BOOL)updateAllLocalMsgReaded {
    
    return [[DataManager sharedInstance] updateAllMsgReaded];
}
@end
