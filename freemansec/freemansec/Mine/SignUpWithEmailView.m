//
//  SignUpWithEmailView.m
//  freemansec
//
//  Created by adamwu on 2017/7/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "SignUpWithEmailView.h"

@implementation SignUpWithEmailView

- (void)agreeBtnAction {
    
    _agree = !_agree;
    _agreeIV.image = [UIImage imageNamed:(_agree?@"":@"")]; //todo
}

-(id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _agree = YES;
        self.width = K_UIScreenWidth;
        
        UIView *emailBg = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.width-30, 44)];
        emailBg.backgroundColor = [UIColor whiteColor];
        emailBg.layer.cornerRadius = 4;
        emailBg.layer.borderWidth = 1;
        emailBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:emailBg];
        
        self.emailTF = [[UITextField alloc] init];
        _emailTF.frame = CGRectMake(emailBg.x + 10, (emailBg.height-20)/2 + emailBg.y, emailBg.width-20, 20);
        _emailTF.font = [UIFont systemFontOfSize:16];
        _emailTF.textColor = [UIColor darkGrayColor];
        _emailTF.placeholder = @"请输入邮箱";//NSLocalizedString
        [self addSubview:_emailTF];
        
        self.agreeIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]; //todo
        _agreeIV.x = emailBg.x;
        _agreeIV.y = emailBg.maxY + 13;
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
        _signBtn.size = emailBg.size;
        _signBtn.x = emailBg.x;
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
        
        self.changeToMobileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeToMobileBtn.size = (CGSize){change.width + 20,change.height + 20};
        _changeToMobileBtn.center = change.center;
        [self addSubview:_changeToMobileBtn];
        
        self.height = _changeToMobileBtn.maxY;
    }
    
    return self;
}

@end
