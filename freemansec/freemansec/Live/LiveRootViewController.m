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
#import "CustomNaviController.h"
#import "LiveManager.h"
#import "LiveBannerCollectionViewCell.h"

@interface LiveRootViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *bannerList;
@property (nonatomic,strong) UICollectionView *bannerView;
@property (nonatomic,strong) UIScrollView *contentView;

@end

@implementation LiveRootViewController

- (NSMutableArray*)bannerList {
    
    if (!_bannerList) {
        
        _bannerList = [[NSMutableArray alloc] init];
    }
    
    return _bannerList;
}

- (void)tabBarCenterAction {
    
    return;//todo
    
    UserLiveRootViewController *vc = [[UserLiveRootViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)loadSearchPage {
    
    return;//todo
    
    LiveSearchViewController *vc = [[LiveSearchViewController alloc] init];
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
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(K_UIScreenWidth, K_UIScreenWidth*3/4);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.bannerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, K_UIScreenWidth*3/4) collectionViewLayout:layout];
    _bannerView.backgroundColor = [UIColor whiteColor];
    _bannerView.delegate = self;
    _bannerView.dataSource = self;
    _bannerView.showsHorizontalScrollIndicator = NO;
    _bannerView.showsVerticalScrollIndicator = NO;
    [_bannerView registerClass:[LiveBannerCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [_contentView addSubview:_bannerView];
    
    UIImageView *sectionBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"liveroot_section_bg.png"]];
    sectionBg.y = _bannerView.maxY - 10;
    sectionBg.centerX = _contentView.width/2;
    [_contentView addSubview:sectionBg];
    
    CGFloat centerX = sectionBg.x + 60 + 10;
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
            
            centerX = sectionBg.x + 60 + 10;
            centerY += 95;
            
        } else {
            
            centerX += 114;
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
    
    if ([LiveManager liveBannerNeedUpdate]) {
        
        [[LiveManager sharedInstance] getLiveBannerCompletion:^(NSArray * _Nullable channelList, NSError * _Nullable error) {
            
            if (error) {
                
            } else {
                
                if (channelList.count > 0) {
                    
                    [self.bannerList removeAllObjects];
                    [self.bannerList addObjectsFromArray:channelList];
                    [_bannerView reloadData];
                    [LiveManager updateLiveBannerLastUpdateTime:[NSDate date]];
                }
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.bannerList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LiveBannerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.channelModel = [self.bannerList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LivePlayViewController *vc = [[LivePlayViewController alloc] init];
    vc.liveChannelModel = [self.bannerList objectAtIndex:indexPath.row];
    [self.tabBarController presentViewController:[[CustomNaviController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
