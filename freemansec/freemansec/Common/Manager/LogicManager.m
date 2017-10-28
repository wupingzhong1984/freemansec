//
//  LogicManager.m
//  freemansec
//
//  Created by adamwu on 2017/7/18.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LogicManager.h"

static LogicManager *instance;
@interface LogicManager()

@property (strong, nonatomic) NSDateFormatter *cachedDateFormatter;

@end

@implementation LogicManager

- (id)init
{
    self = [super init];
    
    _cachedDateFormatter = [[NSDateFormatter alloc] init];
    
    return self;
}

+ (LogicManager *)getInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (NSString*)formatDate:(NSDate*)date format:(NSString*)format {
    
    [[LogicManager getInstance].cachedDateFormatter setDateFormat:format];
    return [[LogicManager getInstance].cachedDateFormatter stringFromDate:date];
}

+ (NSDate*)getDateByStr:(NSString*)str format:(NSString*)format {
    
    [[LogicManager getInstance].cachedDateFormatter setDateFormat:format];
    return [[LogicManager getInstance].cachedDateFormatter dateFromString:str];
}


+(BOOL)isSameLiveChannelModel:(LiveChannelModel*)model1
                        other:(LiveChannelModel*)model2 {
    
    if (![model1.liveId isEqualToString:model2.liveId])
        return NO;
    
    if (![model1.liveName isEqualToString:model2.liveName])
        return NO;
    
    if (![model1.liveImg isEqualToString:model2.liveImg])
        return NO;
    
    if (![model1.liveIntroduce isEqualToString:model2.liveIntroduce])
        return NO;
    
    if (![model1.livelink isEqualToString:model2.livelink])
        return NO;
    
    if (![model1.anchorId isEqualToString:model2.anchorId])
        return NO;
    
    if (![model1.anchorName isEqualToString:model2.anchorName])
        return NO;
    
    if (![model1.anchorImg isEqualToString:model2.anchorImg])
        return NO;
    
    if (![model1.anchorIntroduce isEqualToString:model2.anchorIntroduce])
        return NO;
    
    return YES;
}

+(NSString*)appLangCode {
    
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage containsString:@"zh-Hans"])
    {
        return @"0";
        
    } else if ([currentLanguage containsString:@"zh-Hant"] ||
               [currentLanguage containsString:@"zh-HK"] ||
               [currentLanguage containsString:@"zh-TW"])
    {
        return @"1";
        
    } else
    {
        return @"0";
    }
    
}
@end
