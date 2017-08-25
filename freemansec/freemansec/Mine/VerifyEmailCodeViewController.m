//
//  VerifyEmailCodeViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VerifyEmailCodeViewController.h"

@interface VerifyEmailCodeViewController ()
<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,strong) UITextField *verifyCodeTF;
@property (nonatomic,strong) UITextField *pwdTF;
@end

@implementation VerifyEmailCodeViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submit {
    
    [_verifyCodeTF resignFirstResponder];
    [_pwdTF resignFirstResponder];
    
    NSMutableString *error = [NSMutableString string];
    
    if (!_verifyCodeTF.text.length) {
        
        [error appendString:@"请输入验证码。"];
    }
    
    if (_pwdTF.text.length < 6 || _pwdTF.text.length > 16) {
        
        [error appendString:@"请正确输入密码。"];
    }
    
    if (!error.length) {
        
        [[MineManager sharedInstance]
         registerUserAreaCode:nil
         phone:nil
         verifyCode:_verifyCodeTF.text
         pwd:_pwdTF.text
         email:_email completion:^(MyInfoModel* _Nullable myInfo, NSError * _Nullable error) {
             
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

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:@"邮箱注册" color:UIColor_navititle];//NSLocalizedString
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

- (void)setupSubviews {
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emailverify_notice_bg.png"]];
    bg.y = 15;
    bg.x = (K_UIScreenWidth - bg.width)/2;
    [_contentView addSubview:bg];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emailverify_icon_notice.png"]];
    icon.center = (CGPoint){bg.x + 22,bg.centerY};
    [_contentView addSubview:icon];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(bg.x+43, 0, bg.width - 43 - 17, 0)];
    title.textColor = [UIColor blackColor];
    //NSLocalizedString
    title.numberOfLines = 0;
    [Utility formatLabel:title text:@"提示：相关验证码信息已发送至您的邮箱，验证码有效期为15分钟。" font:[UIFont systemFontOfSize:16] lineSpacing:4];
    title.centerY = icon.centerY;
    [_contentView addSubview:title];
    
    UIView *verifyCodeBg = [[UIView alloc] initWithFrame:CGRectMake(15, 90, _contentView.width - 30, 44)];
    verifyCodeBg.backgroundColor = [UIColor whiteColor];
    verifyCodeBg.layer.cornerRadius = 4;
    verifyCodeBg.layer.borderWidth = 1;
    verifyCodeBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:verifyCodeBg];
    
    self.verifyCodeTF = [[UITextField alloc] init];
    _verifyCodeTF.frame = CGRectMake(verifyCodeBg.x + 10, (verifyCodeBg.height-20)/2 + verifyCodeBg.y, verifyCodeBg.width-20, 20);
    _verifyCodeTF.font = [UIFont systemFontOfSize:16];
    _verifyCodeTF.textColor = [UIColor darkGrayColor];
    _verifyCodeTF.placeholder = @"请输入验证码";//NSLocalizedString
    _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    [_contentView addSubview:_verifyCodeTF];
    
    UIView *pwdBg = [[UIView alloc] initWithFrame:CGRectMake(verifyCodeBg.x, verifyCodeBg.maxY + 10, verifyCodeBg.width, verifyCodeBg.height)];
    pwdBg.backgroundColor = [UIColor whiteColor];
    pwdBg.layer.cornerRadius = 4;
    pwdBg.layer.borderWidth = 1;
    pwdBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:pwdBg];
    
    self.pwdTF = [[UITextField alloc] init];
    _pwdTF.frame = CGRectMake(pwdBg.x + 10, (pwdBg.height-20)/2 + pwdBg.y, pwdBg.width-20, 20);
    _pwdTF.font = [UIFont systemFontOfSize:16];
    _pwdTF.textColor = [UIColor darkGrayColor];
    _pwdTF.placeholder = @"请输入6-16位登录密码";//NSLocalizedString
    _pwdTF.secureTextEntry = YES;
    [_contentView addSubview:_pwdTF];

    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(pwdBg.x, pwdBg.maxY + 50, pwdBg.width, 40);
    submit.backgroundColor = UIColor_82b432;
    submit.layer.cornerRadius = 4;
    [submit setTitle:@"提交" forState:UIControlStateNormal];//NSLocalizedString
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:16];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:submit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    [self setupSubviews];
    
    [[MineManager sharedInstance] getEmailVerifyCode:_email completion:^(NSString * _Nullable verify, NSError * _Nullable error) {
        if(error) {
            
           [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        }
    }];
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
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_verifyCodeTF resignFirstResponder];
    [_pwdTF resignFirstResponder];
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
