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

- (void)getMyVideoListByUserId:(NSString*_Nullable)userId completion:(MyVideoListCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getMyVideoListByUserId:userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

- (void)getMyFavourListByUserId:(NSString*_Nullable)userId completion:(MyFavourListCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getMyFavourListByUserId:userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

- (void)getMyAttentionListByUserId:(NSString*_Nullable)userId completion:(MyAttentionListCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getMyAttentionListByUserId:userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

@end
