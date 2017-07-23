//
//  SignUpWithEmailView.h
//  freemansec
//
//  Created by adamwu on 2017/7/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpWithEmailView : UIView

@property (nonatomic,strong) UITextField *emailTF;
@property (nonatomic,strong) UIImageView *agreeIV;
@property (nonatomic,assign) BOOL agree;
@property (nonatomic,strong) UIButton *signBtn;
@property (nonatomic,strong) UIButton *changeToMobileBtn;

@end
