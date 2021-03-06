//
//  SignUpViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/20.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpWithMobileView.h"
#import "SignUpWithEmailView.h"
#import "SetTelCodeViewController.h"
#import "VerifyEmailCodeViewController.h"
#import "UserPolicyViewController.h"

typedef enum {
    SignUpTypeMobile,
    SignUpTypeEmail,
} SignUpType;

@interface SignUpViewController ()
<UIScrollViewDelegate,
SetTelCodeViewControllerDelegate,
UserPolicyViewControllerDelegate>

@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,assign) SignUpType signUpType;
@property (nonatomic,strong) SignUpWithMobileView *mobileSignView;
@property (nonatomic,strong) SignUpWithEmailView *emailSignView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int second;
@end

@implementation SignUpViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)agreementAction {
    
    UserPolicyViewController *vc = [[UserPolicyViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)mobileTelCodeBtnAction {
    
    SetTelCodeViewController *vc = [[SetTelCodeViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)mobileVerifyBtnAction {
    
    if (!_mobileSignView.mobileTF.text.length) {
        
        //NSLocalizedString
        [self presentViewController:[Utility createNoticeAlertWithContent:NSLocalizedString(@"please input phone num", nil) okBtnTitle:nil] animated:YES completion:nil];
        
    } else {
        
        _second = 60;
        _mobileSignView.verifyBtn.enabled = NO;
        [_mobileSignView.verifyBtn setTitle:[NSString stringWithFormat:@"%dS",_second] forState:UIControlStateDisabled];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            _second--;
            NNSLog(@"%d",_second);
            if (_second > 0) {
                
                [_mobileSignView.verifyBtn setTitle:[NSString stringWithFormat:@"%dS",_second] forState:UIControlStateDisabled];
            } else {
                
                [self.timer invalidate];
                self.timer = nil;
                _mobileSignView.verifyBtn.enabled = YES;
                [_mobileSignView.verifyBtn setTitle:NSLocalizedString(@"verify code", nil) forState:UIControlStateNormal];
            }
            
        }];
        
        [[MineManager sharedInstance] getPhoneVerifyCode:_mobileSignView.telCodeLbl.text phone:_mobileSignView.mobileTF.text completion:^(NSString * _Nullable verify, NSError * _Nullable error) {
            
            if(error) {
                [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            }
        }];
    }
}

-(void)mobileSignBtnAction {
    
    [_mobileSignView.mobileTF resignFirstResponder];
    [_mobileSignView.verifyCodeTF resignFirstResponder];
    [_mobileSignView.pwdTF resignFirstResponder];
    
    
    //NSLocalizedString
    NSMutableString *error = [NSMutableString string];
    
    if (!_mobileSignView.mobileTF.text.length) {
        
        [error appendString:NSLocalizedString(@"please input phone num point", nil)];
    }
    
    if (!_mobileSignView.verifyCodeTF.text.length) {
        
        [error appendString:NSLocalizedString(@"please input verify code point", nil)];
    }
    
    if (_mobileSignView.pwdTF.text.length < 6 || _mobileSignView.pwdTF.text.length > 16) {
        
        [error appendString:NSLocalizedString(@"please input correct pwd", nil)];
    }
    
    if (!_mobileSignView.agree) {
        
        [error appendString:NSLocalizedString(@"please read policy", nil)];
    }
    
    
    if (!error.length) {
        
        [[MineManager sharedInstance]
         registerUserAreaCode:_mobileSignView.telCodeLbl.text
         phone:_mobileSignView.mobileTF.text
         verifyCode:_mobileSignView.verifyCodeTF.text
         pwd:_mobileSignView.pwdTF.text
         email:nil completion:^(MyInfoModel* _Nullable myInfo, NSError * _Nullable error) {
             
             if (error) {
                 [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
             } else {
                 
                 [[MineManager sharedInstance]getIMToken:myInfo.userLoginId completion:^(IMTokenModel * _Nullable tokenInfo, NSError * _Nullable error) {
                     if (error) {
                         [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
                     } else {
                         
                         [[MineManager sharedInstance] updateMyInfo:myInfo];
                         [[MineManager sharedInstance] updateIMToken:tokenInfo];
                         [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                     }
                 }];
             }
         }];
        
    } else {
        
        [self presentViewController:[Utility createNoticeAlertWithContent:error okBtnTitle:nil] animated:YES completion:nil];
    }
}

-(void)mobileChangeToEmailBtnAction {
    
    [_mobileSignView.mobileTF resignFirstResponder];
    [_mobileSignView.verifyCodeTF resignFirstResponder];
    [_mobileSignView.pwdTF resignFirstResponder];
    [_mobileSignView removeFromSuperview];
    self.mobileSignView = nil;
    
    [_contentView addSubview:self.emailSignView];
}

-(SignUpWithMobileView*)mobileSignView {
    
    if (!_mobileSignView) {
        _mobileSignView = [[SignUpWithMobileView alloc] init];
        _mobileSignView.y = 60;
        
        [_mobileSignView.telCodeBtn addTarget:self action:@selector(mobileTelCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_mobileSignView.verifyBtn addTarget:self action:@selector(mobileVerifyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_mobileSignView.signBtn addTarget:self action:@selector(mobileSignBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_mobileSignView.changeToEmailBtn addTarget:self action:@selector(mobileChangeToEmailBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_mobileSignView.agreementBtn addTarget:self action:@selector(agreementAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mobileSignView;
}

- (void)emailSignBtnAction {
    
    [_emailSignView.emailTF resignFirstResponder];
    
    //NSLocalizedString
    NSMutableString *error = [NSMutableString string];
    
    if (![Utility validateEmail:_emailSignView.emailTF.text]) {
        
        [error appendString:NSLocalizedString(@"please input correct email", nil)];
    }
    
    if (!_emailSignView.agree) {
        
        [error appendString:NSLocalizedString(@"please read policy", nil)];
    }
    
    if (!error.length) {
        
        //sign by email
        VerifyEmailCodeViewController *vc = [[VerifyEmailCodeViewController alloc] init];
        vc.email = _emailSignView.emailTF.text;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        [self presentViewController:[Utility createNoticeAlertWithContent:error okBtnTitle:nil] animated:YES completion:nil];
    }
}

- (void)emailChangeToMobileBtnAction {
    
    [_emailSignView.emailTF resignFirstResponder];
    [_emailSignView removeFromSuperview];
    self.emailSignView = nil;
    
    [_contentView addSubview:self.mobileSignView];
}

-(SignUpWithEmailView*)emailSignView {
    
    if (!_emailSignView) {
        _emailSignView = [[SignUpWithEmailView alloc] init];
        _emailSignView.y = 70;
        
        [_emailSignView.signBtn addTarget:self action:@selector(emailSignBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_emailSignView.changeToMobileBtn addTarget:self action:@selector(emailChangeToMobileBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_emailSignView.agreementBtn addTarget:self action:@selector(agreementAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _emailSignView;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:NSLocalizedString(@"sign", nil) color:UIColor_navititle];//NSLocalizedString
    title.centerY = (v.height - 20)/2 + 20;
    [v addSubview:title];
    
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_back_gray.png"]];
    back.centerX = 25;
    back.centerY = (v.height - 20)/2 + 20;
    [v addSubview:back];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.width = back.width + 20;
    btn.height = back.height + 20;
    btn.center = back.center;
    [v addSubview:btn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, v.height-0.5, v.width, 0.5)];
    line.backgroundColor = UIColor_line_d2d2d2;
    [v addSubview:line];
    
    return v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _signUpType = SignUpTypeMobile;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight-naviBar.maxY)];
    _contentView.delegate = self;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.size = (CGSize){_contentView.width,_contentView.height+1};
    [self.view addSubview:_contentView];
    
    [_contentView addSubview:self.mobileSignView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_mobileSignView) {
        
        [_mobileSignView.mobileTF resignFirstResponder];
        [_mobileSignView.verifyCodeTF resignFirstResponder];
        [_mobileSignView.pwdTF resignFirstResponder];
        
    } else {
        
        [_emailSignView.emailTF resignFirstResponder];
    }
}


- (void)SetTelCodeViewControllerTelCode:(NSString*)code {
    
    if (_mobileSignView) {
        _mobileSignView.telCodeLbl.text = code;
    }
}

- (void)UserPolicyViewControllerDidAgree {
    
    _mobileSignView.agree = YES;
    _emailSignView.agree = YES;
    [_mobileSignView.agreeIV setImage:[UIImage imageNamed:@"checkbox_1.png"]];
    [_emailSignView.agreeIV setImage:[UIImage imageNamed:@"checkbox_1.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
