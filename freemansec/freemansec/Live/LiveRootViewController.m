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
#import "LiveSectionViewController.h"
#import "LivePlayViewController.h"

@interface LiveRootViewController ()

@property (nonatomic,strong) UIScrollView *contentView;

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

- (void)playBannerLive {
    
    LivePlayViewController *vc = [[LivePlayViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)liveSectionClicked:(id)sender {
    
    int section = (int)((UIButton*)sender).tag - 100;
    LiveSectionViewController *vc = [[LiveSectionViewController alloc] init];
    vc.section = section;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, self.navigationController.navigationBar.maxY)];
    v.backgroundColor = [UIColor blackColor];
    
    UIImageView *logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_navi_logo.png"]];//todo
    logoIV.centerX = v.width/2;
    logoIV.centerY = (v.height - 20)/2 + 20;
    [v addSubview:logoIV];
    
    UIImageView *search = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navibar_search.png"]];
    search.centerX = v.width - 25;
    search.centerY = logoIV.centerY;
    [v addSubview:search];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(loadSearchPage) forControlEvents:UIControlEventTouchUpInside];
    btn.width = search.width + 20;
    btn.height = search.height + 20;
    btn.center = search.center;
    [v addSubview:btn];
    
    return v;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.maxY, K_UIScreenWidth, K_UIScreenHeight - self.navigationController.navigationBar.maxY - self.tabBarController.tabBar.height)];
    [self.view addSubview:_contentView];
    
    UIImageView *bannerIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"liveroot_banner.png"]];
    bannerIV.size = CGSizeMake(K_UIScreenWidth, K_UIScreenWidth/(bannerIV.width/bannerIV.height));
    [_contentView addSubview:bannerIV];
    
    UIImage *playIcon = [UIImage imageNamed:@"banner_play.png"];
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn addTarget:self action:@selector(playBannerLive) forControlEvents:UIControlEventTouchUpInside];
    [playBtn setImage:playIcon forState:UIControlStateNormal];
    playBtn.size = playIcon.size;
    playBtn.centerX = bannerIV.x + bannerIV.width/2;
    playBtn.centerY = 170;
    [_contentView addSubview:playBtn];
    
    UIImageView *sectionBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"liveroot_section_bg.png"]];
    sectionBg.backgroundColor = [UIColor redColor];
    sectionBg.y = bannerIV.maxY + 10;
    sectionBg.centerX = _contentView.width/2;
    [_contentView addSubview:sectionBg];
    
    CGFloat centerX = 66;
    CGFloat centerY = sectionBg.y + 61;
    UIImageView *sectionIV;
    UILabel *title;
    UIButton *btn;
    for (int i = 0; i < 6; i++) {
        
        sectionIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"live_section_%d.png",i]]];
        sectionIV.centerX = centerX;
        sectionIV.centerY = centerY;
        [_contentView addSubview:sectionIV];
        
        title = [UILabel createLabelWithFrame:CGRectZero text:[LIVE_SECTION_LIST objectAtIndex:i] textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:12]];
        [title sizeToFit];
        title.centerX = sectionIV.centerX;
        title.y = sectionIV.centerY + 34;
        [_contentView addSubview:title];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(liveSectionClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = sectionIV.frame;
        btn.tag = i + 100;
        [_contentView addSubview:btn];
        
        if ((i+1)%3==0) {
            
            centerX = 66;
            centerY += 95;
            
        } else {
            
            centerX += 121;
        }
    }
    
    //tabbar中间按钮相应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarCenterAction) name:@"tabBarCenterAction" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
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

@end
