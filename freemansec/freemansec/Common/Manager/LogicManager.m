//
//  LogicManager.m
//  freemansec
//
//  Created by adamwu on 2017/7/18.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LogicManager.h"

@implementation LogicManager
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
@end
