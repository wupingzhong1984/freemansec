//
//  FSSessionConfig.h
//  freemansec
//
//  Created by adamwu on 2017/8/19.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSessionConfig.h"

@interface FSSessionConfig : NSObject<NIMSessionConfig>
@property (nonatomic,strong) NIMSession *session;
@end
