//
//  LoginViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/20.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface LoginViewController ()
<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,strong) UITextField *uNameTF;
@property (nonatomic,strong) UITextField *pwdTF;
@end

@implementation LoginViewController

- (void)back {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpAction {
    
    SignUpViewController *vc = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:nil];
}

- (void)loginAction {
    
    
}

- (void)forgetPwdAction {
    
    
}

- (void)loginByQQ {
    
    
}

- (void)loginByWX {
    
    
}

- (void)loginByFB {
    
    
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = [UIColor blackColor];
    
    UIView *title = [self commNaviTitle:@"登录" color:[UIColor whiteColor]];//NSLocalizedString
    title.centerY = (v.height - 20)/2 + 20;
    [v addSubview:title];
    
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_back_white.png"]];
    back.centerX = 25;
    back.centerY = (v.height - 20)/2 + 20;
    [v addSubview:back];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.width = back.width + 20;
    btn.height = back.height + 20;
    btn.center = back.center;
    [v addSubview:btn];
    
    return v;
}

- (void)loadSubViews {
    
    UIView *tfBg = [[UIView alloc] initWithFrame:CGRectMake(15, 60, (K_UIScreenWidth-30)/2, 88)];
    tfBg.backgroundColor = [UIColor whiteColor];
    tfBg.layer.cornerRadius = 4;
    tfBg.layer.borderWidth = 1;
    tfBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:tfBg];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(tfBg.x, tfBg.centerY, tfBg.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:line];
    
    UIImageView *uNameImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];//todo
    uNameImg.center = (CGPoint){tfBg.x + 22, tfBg.y + tfBg.height/4};
    [_contentView addSubview:uNameImg];
    
    UIImageView *pwdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];//todo
    pwdImg.center = (CGPoint){uNameImg.centerX, uNameImg.centerY + tfBg.height/2};
    [_contentView addSubview:pwdImg];
    
    self.uNameTF = [[UITextField alloc] init];
    _uNameTF.frame = CGRectMake(uNameImg.centerX + 22, (tfBg.height/2-20)/2+tfBg.y, tfBg.maxX - 20 - (uNameImg.centerX + 22), 20);
    _uNameTF.font = [UIFont systemFontOfSize:16];
    _uNameTF.textColor = [UIColor darkGrayColor];
    _uNameTF.placeholder = @"请输入手机号或电子邮箱";//NSLocalizedString
    [_contentView addSubview:_uNameTF];
    
    self.pwdTF = [[UITextField alloc] init];
    _pwdTF.frame = CGRectMake(pwdImg.centerX + 22, (tfBg.height/2-20)/2+tfBg.y+tfBg.height/2, tfBg.maxX - 20 - (pwdImg.centerX + 22), 20);
    _pwdTF.font = [UIFont systemFontOfSize:16];
    _pwdTF.textColor = [UIColor darkGrayColor];
    _pwdTF.placeholder = @"请输入登录密码";//NSLocalizedString
    _pwdTF.secureTextEntry = YES;
    [_contentView addSubview:_pwdTF];
    
    UIButton *sign = [UIButton buttonWithType:UIButtonTypeCustom];
    sign.frame = CGRectMake(tfBg.x, tfBg.maxY + 22, (tfBg.width-15)/2, 40);
    sign.backgroundColor = [UIColor whiteColor];
    sign.layer.cornerRadius = 4;
    sign.layer.borderWidth = 1;
    sign.layer.borderColor = [UIColor blueColor].CGColor; //todo
    [sign setTitle:@"注册" forState:UIControlStateNormal];//NSLocalizedString
    [sign setTitleColor:[UIColor blueColor] forState:UIControlStateNormal]; //todo
    sign.titleLabel.font = [UIFont systemFontOfSize:16];
    [sign addTarget:self action:@selector(signUpAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:sign];
    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.frame = CGRectMake(tfBg.maxX - sign.width, sign.y, sign.width, sign.height);
    login.backgroundColor = [UIColor blueColor];//todo
    login.layer.cornerRadius = 4;
    [login setTitle:@"登录" forState:UIControlStateNormal];//NSLocalizedString
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; //todo
    login.titleLabel.font = [UIFont systemFontOfSize:16];
    [login addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:login];
    
    UILabel *forget = [UILabel createLabelWithFrame:CGRectZero text:@"忘记密码？" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16]];
    [forget sizeToFit];
    forget.x = tfBg.maxX - forget.width;
    forget.y = login.maxY + 25;
    [_contentView addSubview:forget];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.width = forget.width + 20;
    forgetBtn.height = forget.height + 20;
    forgetBtn.center = forget.center;
    [forgetBtn addTarget:self action:@selector(forgetPwdAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:forgetBtn];
    
    UILabel *other = [UILabel createLabelWithFrame:CGRectZero text:@"您还可以通过以下方式登录" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]]; //NSLocalizedString
    [other sizeToFit];
    other.centerX = _contentView.width/2;
    other.y = forget.maxY + 44;
    [_contentView addSubview:other];
    
    UIImage *wxImg = [UIImage imageNamed:@""]; //todo
    UIButton *wx = [UIButton buttonWithType:UIButtonTypeCustom];
    wx.clipsToBounds = YES;
    wx.size = wxImg.size;
    [wx setImage:wxImg forState:UIControlStateNormal];
    [wx addTarget:self action:@selector(loginByWX) forControlEvents:UIControlEventTouchUpInside];
    wx.y = other.maxY + 17;
    wx.centerX = other.centerX;
    [_contentView addSubview:wx];
    
    UIImage *qqImg = [UIImage imageNamed:@""]; //todo
    UIButton *qq = [UIButton buttonWithType:UIButtonTypeCustom];
    qq.clipsToBounds = YES;
    qq.size = wx.size;
    [qq setImage:qqImg forState:UIControlStateNormal];
    [qq addTarget:self action:@selector(loginByQQ) forControlEvents:UIControlEventTouchUpInside];
    qq.y = wx.centerX - 20;
    qq.centerX = other.centerX-200;
    [_contentView addSubview:qq];
    
    UIImage *fbImg = [UIImage imageNamed:@""]; //todo
    UIButton *fb = [UIButton buttonWithType:UIButtonTypeCustom];
    fb.clipsToBounds = YES;
    fb.size = wx.size;
    [fb setImage:fbImg forState:UIControlStateNormal];
    [fb addTarget:self action:@selector(loginByFB) forControlEvents:UIControlEventTouchUpInside];
    fb.y = wx.centerX - 20;
    fb.centerX = other.centerX+200;
    [_contentView addSubview:fb];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor]; //todo
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight-naviBar.maxY)];
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.delegate = self;
    _contentView.size = (CGSize){_contentView.width,_contentView.height+1};
    [self.view addSubview:_contentView];
    
    [self loadSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_uNameTF resignFirstResponder];
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
