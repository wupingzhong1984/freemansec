//
//  LiveRootViewController.m
//  freeemansec
//
//  Created by adamwu on 2017/6/29.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveRootViewController.h"
#import "LiveSearchViewController.h"
#import "UserLiveRootViewController.h"
#import "LiveKindViewController.h"

@interface LiveRootViewController ()


@end

@implementation LiveRootViewController

- (void)tabBarCenterAction {
    
    UserLiveRootViewController *vc = [[UserLiveRootViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)loadSearchPage {
    
    LiveSearchViewController *vc = [[LiveSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, 64)];
    v.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];//todo
    logoIV.x = 0;//todo
    logoIV.centerY = 42;
    [v addSubview:logoIV];
    
    UIView *bgContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, v.width - 60*2, 38)];
    bgContainer.centerX = K_UIScreenWidth/2;
    bgContainer.centerY = 42;
    bgContainer.layer.cornerRadius = 3;
    bgContainer.layer.borderWidth = 0.5;
    bgContainer.layer.borderColor = [UIColor blackColor].CGColor;
    [v addSubview:bgContainer];
    
    UILabel *keywordPlaceLbl = [[UILabel alloc] initWithFrame:CGRectMake(bgContainer.x + 10, bgContainer.y, bgContainer.width - 10 - 30 - 10, bgContainer.height)];
    keywordPlaceLbl.font = [UIFont systemFontOfSize:14];
    keywordPlaceLbl.textColor = [UIColor lightGrayColor];
    keywordPlaceLbl.text = @"请输入关键词...";
    keywordPlaceLbl.enabled = NO;
    [v addSubview:keywordPlaceLbl];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = bgContainer.frame;
    [btn addTarget:self action:@selector(loadSearchPage) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    return v;
}

//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:49])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    NSArray *titleArray = @[
                            @"分类1",
                            @"分类2",
                            @"分类3"
                            ];
    
    NSArray *classNames = @[
                            [LiveKindViewController class],
                            [LiveKindViewController class],
                            [LiveKindViewController class]
                            ];
    
    NSArray *params = @[
                        @"1",
                        @"2",
                        @"3"
                        ];
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:params];
    
    //负责所有live模块下级页面的present和push
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarCenterAction) name:@"tabBarCenterAction" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    [self selectTagByIndex:0 animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
