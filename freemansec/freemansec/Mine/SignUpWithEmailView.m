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
    _agreeIV.image = [UIImage imageNamed:(_agree?@"checkbox_1.png":@"checkbox_0.png")];
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
        _emailTF.placeholder = NSLocalizedString(@"please input email", nil);//NSLocalizedString
        _emailTF.keyboardType = UIKeyboardTypeEmailAddress;
        [self addSubview:_emailTF];
        
        self.agreeIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox_1.png"]];
        _agreeIV.x = emailBg.x;
        _agreeIV.y = emailBg.maxY + 13;
        [self addSubview:_agreeIV];
        
        UILabel *agreem = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"I have read policy", nil) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15]];
        [agreem sizeToFit];
        agreem.x = _agreeIV.maxX + 5;
        agreem.centerY = _agreeIV.centerY;
        [self addSubview:agreem];
        
        self.agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreementBtn.size = (CGSize){agreem.width,agreem.height + 20};
        _agreementBtn.center = agreem.center;
        [self addSubview:_agreementBtn];
        
        UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        agreeBtn.size = (CGSize){_agreeIV.width + 20,_agreeIV.height + 20};
        agreeBtn.center = _agreeIV.center;
        [agreeBtn addTarget:self action:@selector(agreeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:agreeBtn];
        
        self.signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signBtn.frame = CGRectMake(emailBg.x, _agreeIV.maxY + 25, emailBg.width, 40);
        _signBtn.backgroundColor = UIColor_82b432;
        _signBtn.layer.cornerRadius = 4;
        [_signBtn setTitle:NSLocalizedString(@"sign", nil) forState:UIControlStateNormal];//NSLocalizedString
        [_signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_signBtn];
        
        UILabel *change = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"sign by phone", nil) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15]];
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
