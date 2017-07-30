//
//  VideoManager.m
//  freemansec
//
//  Created by adamwu on 2017/7/23.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VideoManager.h"

static VideoManager *instance;

@implementation VideoManager

- (id)init
{
    self = [super init];
    
    return self;
}

+ (VideoManager*)sharedInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (BOOL)videoKindNeedUpdate {
    
    NSDate *lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"videokindlastupdatetime"];
    if (!lastUpdateTime || [[NSDate date] timeIntervalSinceDate:lastUpdateTime] > 3600) {
        
        return YES;
    }
    
    return NO;
}

+ (void)updateVideoKindLastUpdateTime:(NSDate*_Nullable)time {
    
        [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"videokindlastupdatetime"];
}
@end
