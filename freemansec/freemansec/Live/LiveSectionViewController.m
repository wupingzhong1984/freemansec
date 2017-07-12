//
//  LiveSectionViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/12.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveSectionViewController.h"
#import "LivePlayViewController.h"

@interface LiveSectionViewController ()

@property (nonatomic,strong) UICollectionView *channelCollView;

@end

@implementation LiveSectionViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, self.navigationController.navigationBar.maxY)];
    v.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:[self commNaviTitle:[LIVE_SECTION_LIST objectAtIndex:_section] color:[UIColor whiteColor]]];
    
    UIImageView *search = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navibar_search.png"]];
    search.centerX = v.width - 25;
    search.centerY = (v.height - 20)/2 + 20;
    [v addSubview:search];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.width = search.width + 20;
    btn.height = search.height + 20;
    btn.center = search.center;
    btn.backgroundColor = [UIColor blackColor]; //todo
    [self.view addSubview:btn];
    
    return v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blueColor]; //todo
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
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
