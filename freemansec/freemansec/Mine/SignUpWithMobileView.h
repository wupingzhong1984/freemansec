//
//  SignUpWithMobileView.h
//  freemansec
//
//  Created by adamwu on 2017/7/21.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpWithMobileView : UIView

@property (nonatomic,strong) UILabel *telCodeLbl;
@property (nonatomic,strong) UIButton *telCodeBtn;
@property (nonatomic,strong) UITextField *mobileTF;
@property (nonatomic,strong) UIButton *verifyBtn;
@property (nonatomic,strong) UITextField *verifyCodeTF;
@property (nonatomic,strong) UITextField *pwdTF;
@property (nonatomic,strong) UIImageView *agreeIV;
@property (nonatomic,assign) BOOL agree;
@property (nonatomic,strong) UIButton *signBtn;
@property (nonatomic,strong) UIButton *changeToEmailBtn;
@end
