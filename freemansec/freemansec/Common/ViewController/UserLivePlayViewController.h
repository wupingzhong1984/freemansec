//
//  UserLivePlayViewController.h
//  freemansec
//
//  Created by adamwu on 2017/8/14.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveSearchResultModel.h"

@protocol UserLivePlayViewControllerDelegate <NSObject>
-(void)didLiveAttent:(BOOL)attent;

@end

@interface UserLivePlayViewController : UIViewController

@property (nonatomic,strong) LiveSearchResultModel *userLiveChannelModel;
@property (nonatomic, assign) id<UserLivePlayViewControllerDelegate> delegate;
@end
