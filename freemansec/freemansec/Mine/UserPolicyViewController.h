//
//  UserPolicyViewController.h
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserPolicyViewControllerDelegate <NSObject>

-(void)UserPolicyViewControllerDidAgree;

@end

@interface UserPolicyViewController : UIViewController
@property (nonatomic,assign) id<UserPolicyViewControllerDelegate> delegate;
@end
