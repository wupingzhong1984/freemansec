//
//  CustomTabBarController.m
//  freeemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "CustomTabBarController.h"
#import "CustomNaviController.h"
#import "LiveRootViewController.h"
#import "VideoRootViewController.h"
#import "MessageRootViewController.h"
#import "MineRootViewController.h"
#import "CustomTabBar.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

//初始化子控制器
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    
    vc.tabBarItem.title = title;
    // 设置tabBar的字体颜色
    UIColor *titleHighlightedColor = [UIColor colorWithRed:50.0/255 green:160.0/255 blue:219.0/255 alpha:1];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    UIImage *img = [UIImage imageNamed:image];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.tabBarItem.image =img ;
    //设置不显示文字，将title的位置设置成无限远，就看不到了
//    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
    UIImage *selImage = [UIImage imageNamed:selectedImage];
    selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.tabBarItem.selectedImage = selImage;
    CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildVc:[[LiveRootViewController alloc] init] title:@"直播" image:@"tab_live" selectedImage:@"tab_live_p"];
    [self setupChildVc:[[VideoRootViewController alloc] init] title:@"视频" image:@"tab_live" selectedImage:@"tab_live_p"];
    [self setupChildVc:[[MessageRootViewController alloc] init] title:@"消息" image:@"tab_live" selectedImage:@"tab_live_p"];
    [self setupChildVc:[[MineRootViewController alloc] init] title:@"我的" image:@"tab_live" selectedImage:@"tab_live_p"];
    
    // 自定义tabBar ,用KVC 替换系统的tabbar
    CustomTabBar *tabbar = [[CustomTabBar alloc]init];
    
    // 利用KVC 修改系统的tabbar
    [self setValue:tabbar forKeyPath:@"tabBar"];
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
