//
//  VideoPlayViewController.h
//  freemansec
//
//  Created by adamwu on 2017/8/16.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

typedef enum : NSUInteger {
    VKUserLive,
    VKOfficial
} VideoKind;

@interface VideoPlayViewController : UIViewController

@property (nonatomic,strong) VideoModel *videoModel;
@property (nonatomic,assign) VideoKind videoKind;
@end
