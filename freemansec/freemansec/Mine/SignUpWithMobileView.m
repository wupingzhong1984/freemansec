//
//  SignUpWithMobileView.m
//  freemansec
//
//  Created by adamwu on 2017/7/21.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "SignUpWithMobileView.h"



@implementation SignUpWithMobileView

- (void)agreeBtnAction {
    
    _agree = !_agree;
    _agreeIV.image = [UIImage imageNamed:(_agree?@"":@"")]; //todo
}

-(id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _agree = YES;
        self.width = K_UIScreenWidth;
        
        //code
        UIView *codeBg = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 73, 44)];
        codeBg.backgroundColor = [UIColor whiteColor];
        codeBg.layer.cornerRadius = 4;
        codeBg.layer.borderWidth = 1;
        codeBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:codeBg];
        
        self.telCodeLbl = [[UILabel alloc] initWithFrame:CGRectMake(codeBg.x, codeBg.y, 47, codeBg.height)];
        _telCodeLbl.numberOfLines = 1;
        _telCodeLbl.textAlignment = NSTextAlignmentRight;
        _telCodeLbl.textColor = [UIColor darkGrayColor];
        _telCodeLbl.font = [UIFont systemFontOfSize:16];
        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *languageName = [appLanguages objectAtIndex:0];
        _telCodeLbl.text = ([languageName isEqualToString:@"zh-Hans"]?@"+86":@"+852");
        [self addSubview:_telCodeLbl];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]; //todo
        icon.centerX = (codeBg.maxX - _telCodeLbl.maxX)/2 + _telCodeLbl.maxX;
        icon.centerY = codeBg.centerY;
        [self addSubview:icon];
        
        self.telCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _telCodeBtn.frame = codeBg.frame;
        [self addSubview:_telCodeBtn];
        
        UIView *mobileBg = [[UIView alloc] initWithFrame:CGRectMake(codeBg.maxX + 10, codeBg.y, self.width - 15 - (codeBg.maxX + 10), codeBg.height)];
        mobileBg.backgroundColor = [UIColor whiteColor];
        mobileBg.layer.cornerRadius = 4;
        mobileBg.layer.borderWidth = 1;
        mobileBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:mobileBg];
        
        self.verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyBtn.backgroundColor = [UIColor blueColor]; //todo
        _verifyBtn.layer.cornerRadius = 4;
        _verifyBtn.size = (CGSize){60,32};
        _verifyBtn.centerY = mobileBg.centerY;
        _verifyBtn.x = mobileBg.maxX - 5 - _verifyBtn.width;
        [_verifyBtn setTitle:@"验证码" forState:UIControlStateNormal]; //NSLocalizedString
        [_verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_verifyBtn];
        
        self.mobileTF = [[UITextField alloc] init];
        _mobileTF.frame = CGRectMake(mobileBg.x + 10, (mobileBg.height-20)/2 + mobileBg.y, _verifyBtn.x - 10 - (mobileBg.x + 10), 20);
        _mobileTF.font = [UIFont systemFontOfSize:16];
        _mobileTF.textColor = [UIColor darkGrayColor];
        _mobileTF.placeholder = @"请输入手机号";//NSLocalizedString
        _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_mobileTF];
        
        UIView *verifyCodeBg = [[UIView alloc] initWithFrame:CGRectMake(codeBg.x, codeBg.maxY + 10, self.width - codeBg.x*2, codeBg.height)];
        verifyCodeBg.backgroundColor = [UIColor whiteColor];
        verifyCodeBg.layer.cornerRadius = 4;
        verifyCodeBg.layer.borderWidth = 1;
        verifyCodeBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:verifyCodeBg];
        
        self.verifyCodeTF = [[UITextField alloc] init];
        _verifyCodeTF.frame = CGRectMake(verifyCodeBg.x + 10, (verifyCodeBg.height-20)/2 + verifyCodeBg.y, verifyCodeBg.width-20, 20);
        _verifyCodeTF.font = [UIFont systemFontOfSize:16];
        _verifyCodeTF.textColor = [UIColor darkGrayColor];
        _verifyCodeTF.placeholder = @"请输入验证码";//NSLocalizedString
        _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_verifyCodeTF];
        
        UIView *pwdBg = [[UIView alloc] initWithFrame:CGRectMake(verifyCodeBg.x, verifyCodeBg.maxY + 10, verifyCodeBg.width, codeBg.height)];
        pwdBg.backgroundColor = [UIColor whiteColor];
        pwdBg.layer.cornerRadius = 4;
        pwdBg.layer.borderWidth = 1;
        pwdBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:pwdBg];
        
        self.pwdTF = [[UITextField alloc] init];
        _pwdTF.frame = CGRectMake(pwdBg.x + 10, (pwdBg.height-20)/2 + pwdBg.y, pwdBg.width-20, 20);
        _pwdTF.font = [UIFont systemFontOfSize:16];
        _pwdTF.textColor = [UIColor darkGrayColor];
        _pwdTF.placeholder = @"请输入6-16位登录密码";//NSLocalizedString
        _pwdTF.secureTextEntry = YES;
        [self addSubview:_pwdTF];
        
        self.agreeIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]; //todo
        _agreeIV.x = pwdBg.x;
        _agreeIV.y = pwdBg.maxY + 13;
        [self addSubview:_agreeIV];
        
        UILabel *agreem = [UILabel createLabelWithFrame:CGRectZero text:@"我已阅读并同意<条例>" textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15]];
        [agreem sizeToFit];
        agreem.x = _agreeIV.maxX + 5;
        agreem.centerY = _agreeIV.centerY;
        [self addSubview:agreem];
        
        UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        agreeBtn.size = (CGSize){_agreeIV.width + 20,_agreeIV.height + 20};
        agreeBtn.center = _agreeIV.center;
        [agreeBtn addTarget:self action:@selector(agreeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:agreeBtn];
        
        self.signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signBtn.size = pwdBg.size;
        _signBtn.x = pwdBg.x;
        _signBtn.y = _agreeIV.maxY + 25;
        _signBtn.backgroundColor = [UIColor blueColor];//todo
        _signBtn.layer.cornerRadius = 4;
        [_signBtn setTitle:@"注册" forState:UIControlStateNormal];//NSLocalizedString
        [_signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; //todo
        _signBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_signBtn];
        
        UILabel *change = [UILabel createLabelWithFrame:CGRectZero text:@"用邮箱注册" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15]];
        [change sizeToFit];//NSLocalizedString
        change.x = _signBtn.maxX - change.width;
        change.y = _signBtn.maxY + 15;
        [self addSubview:change];
        
        self.changeToEmailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeToEmailBtn.size = (CGSize){change.width + 20,change.height + 20};
        _changeToEmailBtn.center = change.center;
        [self addSubview:_changeToEmailBtn];
        
        self.height = _changeToEmailBtn.maxY;
    }
    
    return self;
}

@end
