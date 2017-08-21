//
//  LiveRootViewController.m
//  freemansec
//
//  Created by adamwu on 2017/6/29.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveRootViewController.h"
#import "LiveSearchViewController.h"
#import "UserLiveRootViewController.h"
#import "CustomNaviController.h"
#import "OfficialLiveViewController.h"

@interface LiveRootViewController ()

@property (nonatomic,strong)NSMutableArray *kindNameArray;
@property (nonatomic,strong)NSMutableArray *classNameArray;
@property (nonatomic,strong)NSMutableArray *kindIdArray;

@end

@implementation LiveRootViewController

- (NSMutableArray*)kindNameArray {
    
    if (!_kindNameArray) {
        _kindNameArray = [[NSMutableArray alloc] init];
    }
    
    return _kindNameArray;
}

- (NSMutableArray*)classNameArray {
    
    if (!_classNameArray) {
        _classNameArray = [[NSMutableArray alloc] init];
    }
    
    return _classNameArray;
}

- (NSMutableArray*)kindIdArray {
    
    if (!_kindIdArray) {
        _kindIdArray = [[NSMutableArray alloc] init];
    }
    
    return _kindIdArray;
}

- (void)tabBarCenterAction {
    
    NSString *state = [[MineManager sharedInstance] getMyInfo].realNameVerifyState;
    if (state && [state isEqualToString:@"1"]) { //已实名认证
        
        if ([[MineManager sharedInstance] getMyInfo].cId.length > 0) { //申请主播
            
            UserLiveRootViewController *vc = [[UserLiveRootViewController alloc]init];
            //[self.navigationController pushViewController:vc animated:YES];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        } else {
            //NSLocalizedString
            [self presentViewController:[Utility createNoticeAlertWithContent:@"请先完成主播申请。" okBtnTitle:nil] animated:YES completion:nil];
        }
    } else {
        
        if ([state isEqualToString:@"3"]) {
            //NSLocalizedString
            [self presentViewController:[Utility createNoticeAlertWithContent:@"您的实名认证未通过审核，请重新提交实名的并申请主播。" okBtnTitle:nil] animated:YES completion:nil];
        } else {
        
            //NSLocalizedString
            [self presentViewController:[Utility createNoticeAlertWithContent:@"请先完成实名认证并申请主播。" okBtnTitle:nil] animated:YES completion:nil];
        }
    }
    
}

- (void)loadSearchPage {
    
    LiveSearchViewController *vc = [[LiveSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)naviBarView {
    
    
    UIImageView *logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_navi_logo.png"]];
    logoIV.x = 15;
    logoIV.centerY = (64 - 20)/2 + 20;
    [self.view addSubview:logoIV];
    
    UIImageView *search = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navibar_search.png"]];
    search.centerX = K_UIScreenWidth - 25;
    search.centerY = logoIV.centerY;
    [self.view addSubview:search];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(loadSearchPage) forControlEvents:UIControlEventTouchUpInside];
    btn.width = search.width + 20;
    btn.height = search.height + 20;
    btn.center = search.center;
    [self.view addSubview:btn];

//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64-0.5, K_UIScreenWidth, 0.5)];
//    line.backgroundColor = UIColor_line_d2d2d2;
//    [self.view addSubview:line];
    
}

- (instancetype)init
{
    if (self = [super initWithTagViewHeight:44])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tabCollViewRect = CGRectMake(60, 20, K_UIScreenWidth-120, 44);
    
    NSArray *titleArray = @[
                            @"分类1",
                            @"分类2",
                            @"分类3",
                            @"分类4"
                            ];
    
    NSArray *classNames = @[
                            [OfficialLiveViewController class],
                            [OfficialLiveViewController class],[OfficialLiveViewController class],
                            [OfficialLiveViewController class]
                            ];
    
    NSArray *params = @[
                        @"1",
                        @"2",
                        @"2",
                        @"3"
                        ];
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:params];
    
    
    
    [self naviBarView];

    
        //tabbar中间按钮相应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarCenterAction) name:@"tabBarCenterAction" object:nil];
    
    //test facebook
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
