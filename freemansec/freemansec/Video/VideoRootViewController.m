//
//  VideoRootViewController.m
//  freemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VideoRootViewController.h"

@interface VideoRootViewController ()

@end

@implementation VideoRootViewController

- (void)loadSearchPage {
    
    return;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, self.navigationController.navigationBar.maxY)];
    v.backgroundColor = [UIColor blackColor];
    
    UIView *title = [self commNaviTitle:@"热门视频" color:[UIColor whiteColor]]; //NSLocalizedString
    title.centerY = (v.height - 20)/2 + 20;
    [v addSubview:title];
    
//    UIImageView *search = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navibar_search.png"]];
//    search.centerX = v.width - 25;
//    search.centerY = title.centerY;
//    [v addSubview:search];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn addTarget:self action:@selector(loadSearchPage) forControlEvents:UIControlEventTouchUpInside];
//    btn.width = search.width + 20;
//    btn.height = search.height + 20;
//    btn.center = search.center;
//    [v addSubview:btn];
//    
    return v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p1.png"]];
    img.frame = CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenWidth/(img.width/img.height));
    [self.view addSubview:img];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
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
