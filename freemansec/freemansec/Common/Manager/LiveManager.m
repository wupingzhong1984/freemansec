//
//  LiveManager.m
//  freemansec
//
//  Created by adamwu on 2017/7/17.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveManager.h"
#import "LiveHttpService.h"

@implementation LiveManager

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)getLiveBannerByLiveTypeId:(NSString*)typeId
                      completion:(LiveChannelListCompletion)completion {
    
    LiveHttpService* service = [[LiveHttpService alloc] init];
    [service getLiveBannerByLiveTypeId:typeId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

-(void)getLiveListByLiveTypeId:(NSString*)typeId
                    completion:(LiveChannelListCompletion)completion {
    
    LiveHttpService* service = [[LiveHttpService alloc] init];
    [service getLiveListByLiveTypeId:typeId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}
@end
