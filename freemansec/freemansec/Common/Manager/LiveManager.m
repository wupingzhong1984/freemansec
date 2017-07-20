//
//  LiveManager.m
//  freemansec
//
//  Created by adamwu on 2017/7/17.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveManager.h"
#import "LiveHttpService.h"

static LiveManager *instance;

@implementation LiveManager

- (id)init
{
    self = [super init];
    
    return self;
}

+ (LiveManager*)sharedInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (BOOL)liveBannerNeedUpdate {
    
    NSDate *lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"livebannerlastupdatetime"];
    if (!lastUpdateTime || [[NSDate date] timeIntervalSinceDate:lastUpdateTime] > 3600) {
        
        return YES;
    }
    
    return NO;
}

+ (void)updateLiveBannerLastUpdateTime:(NSDate*)time {
    
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"livebannerlastupdatetime"];
}

+ (NSString*)getLiveTypeIdByTypeIndex:(int)type {
    
    switch (type) {
        case 0:
            return @"100";
            break;
        case 1:
            return @"103";
            break;
        case 2:
            return @"104";
            break;
        case 3:
            return @"105";
            break;
        case 4:
            return @"106";
            break;
        default:
            return @"107";
            break;
    }
}

-(void)getLiveBannerCompletion:(LiveChannelListCompletion)completion {
    
    LiveHttpService* service = [[LiveHttpService alloc] init];
    [service getLiveBannerCompletion:^(id obj, NSError *err) {
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
