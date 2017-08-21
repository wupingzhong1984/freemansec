//
//  ForgetPwdViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "ResetMobilePwdViewController.h"
#import "ResetEmailPwdViewController.h"

@interface ForgetPwdViewController ()

@end

@implementation ForgetPwdViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadResetMobilePwdVC {
    
    ResetMobilePwdViewController *vc = [[ResetMobilePwdViewController alloc] init];
    vc.resetPwdKind = _resetPwdKind;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadResetEmailPwdVC {
    
    ResetEmailPwdViewController *vc = [[ResetEmailPwdViewController alloc] init];
    vc.resetPwdKind = _resetPwdKind;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:(_resetPwdKind == RPKResetPwd?@"重设密码":@"忘记密码") color:UIColor_navititle];//NSLocalizedString
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(15, naviBar.maxY+ 38, K_UIScreenWidth - 30, 50)];
    bg1.backgroundColor = [UIColor whiteColor];
    bg1.layer.borderWidth = 0.5;
    bg1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:bg1];
    
    UIImageView *left1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forgetpwd_email.png"]];
    left1.frame = CGRectMake(bg1.x, bg1.y, bg1.height, bg1.height);
    [self.view addSubview:left1];
    
    UILabel *title1 = [UILabel createLabelWithFrame:CGRectZero text:(_resetPwdKind == RPKResetPwd?@"通过邮箱重设":@"邮箱找回") textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:16]];//NSLocalizedString
    [title1 sizeToFit];
    title1.x = 85;
    title1.centerY = left1.centerY;
    [self.view addSubview:title1];
    
    UIImageView *right1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_cell_right.png"]];
    right1.center = CGPointMake(K_UIScreenWidth - 31, title1.centerY);
    [self.view addSubview:right1];
    
    UIView *bg2 = [[UIView alloc] initWithFrame:CGRectMake(bg1.x, bg1.maxY+ 18, bg1.width, bg1.height)];
    bg2.backgroundColor = [UIColor whiteColor];
    bg2.layer.borderWidth = 0.5;
    bg2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:bg2];
    
    UIImageView *left2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forgetpwd_phone.png"]];
    left2.frame = CGRectMake(bg2.x, bg2.y, bg2.height, bg2.height);
    [self.view addSubview:left2];
    
    UILabel *title2 = [UILabel createLabelWithFrame:CGRectZero text:(_resetPwdKind == RPKResetPwd?@"通过手机号重设":@"手机号找回") textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:16]];//NSLocalizedString
    [title2 sizeToFit];
    title2.x = 85;
    title2.centerY = left2.centerY;
    [self.view addSubview:title2];
    
    UIImageView *right2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_cell_right.png"]];
    right2.center = CGPointMake(K_UIScreenWidth - 31, title2.centerY);
    [self.view addSubview:right2];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = bg1.frame;
    [btn1 addTarget:self action:@selector(loadResetEmailPwdVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = bg2.frame;
    [btn2 addTarget:self action:@selector(loadResetMobilePwdVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
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
