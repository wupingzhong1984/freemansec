//
//  LogicManager.h
//  freemansec
//
//  Created by adamwu on 2017/7/18.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveChannelModel.h"

@interface LogicManager : NSObject

+(BOOL)isSameLiveChannelModel:(LiveChannelModel*)model1
                        other:(LiveChannelModel*)model2;

@end
