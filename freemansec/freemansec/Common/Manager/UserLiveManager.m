//
//  UserLiveManager.m
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserLiveManager.h"
#import "UserLiveHttpService.h"

@implementation UserLiveManager

static UserLiveManager *instance;

- (id)init
{
    self = [super init];
    
    return self;
}

+ (UserLiveManager*)sharedInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)getLivePushStreamWithLiveTitle:(NSString* _Nonnull)title completion:(UpdateMyUserLiveTitleCompletion _Nullable)completion
{
    
    //todo
    UserLiveHttpService* service = [[UserLiveHttpService alloc] init];
    [service getLivePushStreamWithLiveTitle:title userId:@"" completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            completion(obj,nil);
        }
    }];
}
@end
