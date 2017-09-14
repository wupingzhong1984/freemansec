//
//  CustomTabBarController.m
//  freemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "CustomTabBarController.h"
#import "CustomNaviController.h"
#import "LiveRootViewController.h"
#import "VideoRoot2ViewController.h"
#import "MessageRootViewController.h"
#import "MineRootViewController.h"
#import "CustomTabBar.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

//初始化子控制器
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    
    [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    vc.tabBarItem.title = title;
    // 设置tabBar的字体颜色
    UIColor *titleHighlightedColor = [UIColor colorWithRed:117.0/255 green:210.0/255 blue:110.0/255 alpha:1];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLocalizedString
    [self setupChildVc:[[LiveRootViewController alloc] init] title:NSLocalizedString(@"Live", nil) image:@"tab_img_0.png" selectedImage:@"tab_img_0_h.png"];
    [self setupChildVc:[[VideoRoot2ViewController alloc] init] title:NSLocalizedString(@"hot video", nil) image:@"tab_img_1.png" selectedImage:@"tab_img_1_h.png"];
    [self setupChildVc:[[MessageRootViewController alloc] init] title:NSLocalizedString(@"message", nil) image:@"tab_img_2.png" selectedImage:@"tab_img_2_h.png"];
    [self setupChildVc:[[MineRootViewController alloc] init] title:NSLocalizedString(@"mine", nil) image:@"tab_img_3.png" selectedImage:@"tab_img_3_h.png"];
    
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
