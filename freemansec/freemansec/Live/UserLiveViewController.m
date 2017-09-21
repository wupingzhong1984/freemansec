//
//  UserLiveViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserLiveViewController.h"
#import "UserLivePlayViewController.h"
#import "LivePlayViewController.h"
#import "MJRefresh.h"
#import "LiveSearchResultModel.h"
#import "LiveSearchResultCollectionViewCell.h"
#import "PlayBackDetailViewController.h"

@interface UserLiveViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,
UserLivePlayViewControllerDelegate,
LivePlayViewControllerDelegate> {
    
}

@property (nonatomic,strong) UICollectionView *collView;
@property (nonatomic,strong) NSString *pageNum;
@property (nonatomic,strong) NSMutableArray *liveList;
@property (nonatomic,assign) NSInteger lastSelectIndex;
@property (nonatomic,strong) NodataView *nodataView;
@end

@implementation UserLiveViewController

- (NSMutableArray*)liveList {
    
    if (!_liveList) {
        _liveList = [[NSMutableArray alloc] init];
    }
    
    return _liveList;
}

- (UIView*)nodataView {
    
    if (!_nodataView) {
        _nodataView = [[NodataView alloc] initWithTitle:NSLocalizedString(@"no result data", nil)];
        _nodataView.center = _collView.center;
    }
    
    return _nodataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    _lastSelectIndex = -1;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(0,0);
    layout.footerReferenceSize = CGSizeMake(0,0);
    CGFloat itemWidth = K_UIScreenWidth/2;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth + 50);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [layout setHeaderReferenceSize:CGSizeMake(K_UIScreenWidth, 0)];
    [layout setFooterReferenceSize:CGSizeMake(K_UIScreenWidth, 0)];
    self.collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, K_UIScreenHeight - 64 - self.tabBarController.tabBar.height) collectionViewLayout:layout];
    _collView.showsVerticalScrollIndicator = NO;
    _collView.showsHorizontalScrollIndicator = NO;
    _collView.delegate = self;
    _collView.dataSource = self;
    _collView.backgroundColor = [UIColor clearColor];
    [_collView registerClass:[LiveSearchResultCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_collView];

    [self setupRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    
    [self.collView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.collView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    //NSLocalizedString
    self.collView.headerPullToRefreshText = NSLocalizedString(@"release to refresh", nil);
    self.collView.headerReleaseToRefreshText = NSLocalizedString(@"release then refresh", nil);
    self.collView.headerRefreshingText = NSLocalizedString(@"updating data please wait", nil);
    
    self.collView.footerPullToRefreshText = NSLocalizedString(@"pull to get more data", nil);
    self.collView.footerReleaseToRefreshText = NSLocalizedString(@"release then load more data", nil);
    self.collView.footerRefreshingText = NSLocalizedString(@"loading data", nil);
    
//    self.pageNum = @"1";
    // 2.2秒后刷新表格UI
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
//    [self requestSearch];
    //        });
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    self.pageNum = @"1";
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self requestSearch];
    });
}

- (void)footerRereshing
{
    self.pageNum = [NSString stringWithFormat:@"%d",(int)(_pageNum.integerValue + 1)];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self requestSearch];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.hidden = YES;
//    
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    self.pageNum = @"1";
    [self requestSearch];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)requestSearch {
    
    [[LiveManager sharedInstance] queryLiveByType:_typeId pageNum:_pageNum.integerValue completion:^(NSArray * _Nullable queryResultList, NSError * _Nullable error) {
        [self.collView headerEndRefreshing];
        [self.collView footerEndRefreshing];
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            if (_pageNum.integerValue == 1) {
                
                [self.liveList removeAllObjects];
            }
            
            if (queryResultList.count > 0) {
                
                [self.liveList addObjectsFromArray:queryResultList];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_collView reloadData];
                
                if ([_pageNum isEqualToString:@"1"]) {
                    
                    if (queryResultList.count > 0) {
                        
                        [_collView scrollRectToVisible:CGRectMake(0, 0, _collView.width, _collView.height) animated:NO];
                    }
                }
                
                if (self.liveList.count == 0) {
                    
                    [self.view addSubview:self.nodataView];
                }
            });
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.liveList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LiveSearchResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.resultModel = [_liveList objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![[MineManager sharedInstance] getMyInfo]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadUserLogin object:nil];
        return;
    }
    
    LiveSearchResultModel *model = [_liveList objectAtIndex:indexPath.row];
    
    if ([model.state isEqualToString:@"1"] || [model.state isEqualToString:@"3"]) {
    
        _lastSelectIndex = indexPath.row;
        UserLivePlayViewController *vc = [[UserLivePlayViewController alloc] init];
        vc.userLiveChannelModel = model;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (model.vid.length > 0) {
        
        PlayBackDetailViewController *vc = [[PlayBackDetailViewController alloc] init];
        vc.playBackId = model.vid;
        vc.name = model.liveName;
        vc.playBackType = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)didLiveAttent:(BOOL)attent {
    
    if (_lastSelectIndex > -1) {
        
        LiveSearchResultModel *model = [_liveList objectAtIndex:_lastSelectIndex];
        model.isAttent = attent?@"1":@"0";
    }
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
