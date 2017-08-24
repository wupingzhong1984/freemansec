//
//  LivePlayViewController.h
//  freemansec
//
//  Created by adamwu on 2017/7/9.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveChannelModel.h"

@protocol LivePlayViewControllerDelegate <NSObject>
-(void)didLiveAttent:(BOOL)attent;

@end

@interface LivePlayViewController : UIViewController

@property (nonatomic, strong) LiveChannelModel *liveChannelModel;
@property (nonatomic, assign) id<LivePlayViewControllerDelegate> delegate;

@end
