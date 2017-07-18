//
//  LiveSectionViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/12.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveSectionViewController.h"
#import "CustomNaviController.h"
#import "LivePlayViewController.h"
#import "LiveSectionChannelCollectionViewCell.h"
#import "LiveManager.h"

@interface LiveSectionViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *channelList;
@property (nonatomic,strong) UICollectionView *channelCollView;

@end

@implementation LiveSectionViewController

- (NSMutableArray*)channelList {
    
    if (!_channelList) {
        
        _channelList = [[NSMutableArray alloc] init];
    }
    
    return _channelList;
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, self.navigationController.navigationBar.maxY)];
    v.backgroundColor = [UIColor blackColor];
    
    [v addSubview:[self commNaviTitle:[LIVE_SECTION_LIST objectAtIndex:_section] color:[UIColor whiteColor]]];
    
    UIImageView *search = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_back_white.png"]];
    search.centerX = 25;
    search.centerY = (v.height - 20)/2 + 20;
    [v addSubview:search];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
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
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 20;
    layout.headerReferenceSize = CGSizeMake(0,0);
    layout.footerReferenceSize = CGSizeMake(0,0);
    CGFloat itemWidth = (K_UIScreenWidth-28-20)/2;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth*3/4 + 16);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [layout setHeaderReferenceSize:CGSizeMake(K_UIScreenWidth, 14)];
    [layout setFooterReferenceSize:CGSizeMake(K_UIScreenWidth, 14)];
    self.channelCollView = [[UICollectionView alloc] initWithFrame:CGRectMake(14, naviBar.maxY, K_UIScreenWidth-28, K_UIScreenHeight - naviBar.maxY) collectionViewLayout:layout];
    _channelCollView.backgroundColor = [UIColor whiteColor];
    _channelCollView.delegate = self;
    _channelCollView.dataSource = self;
    _channelCollView.showsHorizontalScrollIndicator = NO;
    _channelCollView.showsVerticalScrollIndicator = NO;
    [_channelCollView registerClass:[LiveSectionChannelCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_channelCollView];
    
    [[LiveManager sharedInstance] getLiveListByLiveTypeId:[LiveManager getLiveTypeIdBySectionIndex:_section] completion:^(NSArray * _Nullable channelList, NSError * _Nullable error) {
        
        if (error) {
            
        } else {
            
            if (channelList.count > 0) {
                
                [self.channelList removeAllObjects];
                [self.channelList addObjectsFromArray:channelList];
                [_channelCollView reloadData];
                [LiveManager updateLiveBannerLastUpdateTime:[NSDate date]];
            }
        }
    }];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.channelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LiveSectionChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.channelModel = [_channelList objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LivePlayViewController *vc = [[LivePlayViewController alloc] init];
    vc.liveChannelModel = [_channelList objectAtIndex:indexPath.row];
    [self.tabBarController presentViewController:[[CustomNaviController alloc] initWithRootViewController:vc] animated:YES completion:nil];
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
