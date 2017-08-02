//
//  NEMediaCaptureEntity.h
//  LSMediaCaptureDemo
//
//  Created by emily on 16/11/17.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nMediaLiveStreamingDefs.h"

@interface NEMediaCaptureEntity : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, assign, readwrite) LSVideoParaCtx videoParaCtx;
@property(nonatomic, assign) NSUInteger encodeType;

@end
