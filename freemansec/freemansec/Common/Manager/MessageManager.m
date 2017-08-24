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

- (void)getMsgListPageNum:(NSInteger)pageNum completion:(MsgListCompletion _Nullable)completion {
    
    MessageHttpService* service = [[MessageHttpService alloc] init];
    [service getMsgListPageNum:pageNum userId:[[MineManager sharedInstance] getMyInfo].userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}
@end
