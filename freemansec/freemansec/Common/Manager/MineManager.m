//
//  MineManager.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MineManager.h"
#import "MineHttpService.h"

static MineManager *instance;

@implementation MineManager

- (id)init
{
    self = [super init];
    
    return self;
}

+ (MineManager*)sharedInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)getMyVideoListCompletion:(MyVideoListCompletion _Nullable)completion {
    
    //todo
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getMyVideoListByUserId:@"" completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

- (void)getMyFavourListCompletion:(MyFavourListCompletion _Nullable)completion {
    
    //todo
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getMyFavourListByUserId:@"" completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

- (void)getMyAttentionListCompletion:(MyAttentionListCompletion _Nullable)completion {
    
    //todo
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getMyAttentionListByUserId:@"" completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

@end
