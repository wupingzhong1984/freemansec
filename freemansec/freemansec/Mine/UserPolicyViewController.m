//
//  UserPolicyViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserPolicyViewController.h"

@interface UserPolicyViewController ()
<UIWebViewDelegate>

@end

@implementation UserPolicyViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)agreeAction {
    
    if (_delegate && [_delegate respondsToSelector:@selector(UserPolicyViewControllerDidAgree)]) {
        [_delegate UserPolicyViewControllerDidAgree];
    }
    
    [self back];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UILabel *title = [self commNaviTitle:NSLocalizedString(@"user policy", nil) color:UIColor_navititle];//NSLocalizedString
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
    
    //NSLocalizedString
    UILabel *agree = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"agree", nil) textColor:title.textColor font:title.font];
    [agree sizeToFit];
    agree.centerY = title.centerY;
    agree.x = v.width - 15 - agree.width;
    [v addSubview:agree];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    btn2.width = agree.width + 20;
    btn2.height = agree.height + 20;
    btn2.center = agree.center;
    [v addSubview:btn2];
    
    
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
    
    UIWebView *wView = [[UIWebView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight - naviBar.maxY)];
    wView.delegate = self;
    [self.view addSubview:wView];
    
    [wView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mzcj.dhteam.net/rule.html"]]];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
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
