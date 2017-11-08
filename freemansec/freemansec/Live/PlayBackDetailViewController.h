//
//  PlayBackDetailViewController.h
//  freemansec
//
//  Created by adamwu on 2017/9/1.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayBackDetailViewController : UIViewController

@property (nonatomic,strong) NSString *playBackId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *playBackType; // type=1主播视频 0=民众官方视频
@property (nonatomic,strong) NSString *kingPlayBackType; //1001 1002 1003...
@end
