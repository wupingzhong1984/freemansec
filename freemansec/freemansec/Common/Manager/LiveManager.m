//
//  LiveManager.m
//  freemansec
//
//  Created by adamwu on 2017/7/17.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveManager.h"
#import "LiveHttpService.h"
#import "OfficialLiveType.h"

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

+ (NSMutableArray*)getOfficialLiveTypeList {
    
    NSMutableArray *names = [NSMutableArray arrayWithObjects:@"郭sir专区",@"皇牌节目",@"财经访谈",@"股市新闻",@"财经互动",@"其它", nil];
    NSMutableArray *ids = [NSMutableArray arrayWithObjects:@"100",@"103",@"104",@"105",@"106",@"107", nil];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0;i < names.count;i++) {
        
        OfficialLiveType *type = [[OfficialLiveType alloc] init];
        type.liveTypeId = [ids objectAtIndex:i];
        type.liveTypeName = [names objectAtIndex:i];
        [array addObject:type];
    }
    
    return array;
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
