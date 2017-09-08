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
        _nodataView = [[NodataView alloc] initWithTitle:@"暂无数据"];
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
    self.collView.headerPullToRefreshText = @"下拉可以刷新了";
    self.collView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.collView.headerRefreshingText = @"正在拼命的刷新数据中，请稍后!";
    
    self.collView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.collView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.collView.footerRefreshingText = @"正在拼命的加载中";
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    return;
    NNSLog(@"%f  %f",scrollView.contentOffset.y,roundf(scrollView.contentSize.height-scrollView.frame.size.height));
    if (![scrollView isEqual:_collView]) {
        
        return;
    }
    
    if ((int)scrollView.contentOffset.y == (int)roundf(scrollView.contentSize.height-scrollView.frame.size.height)) {
        
        [self.collView performBatchUpdates:^{
            
            self.pageNum = [NSString stringWithFormat:@"%d",(int)(_pageNum.integerValue + 1)];
            [self requestSearch];
            
        } completion:nil];
    }
    
    if (scrollView.contentOffset.y < -60) {
        
        [self.collView performBatchUpdates:^{
            
            self.pageNum = @"1";
            [self requestSearch];
            
        } completion:nil];
    }
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
    
    _lastSelectIndex = indexPath.row;
    LiveSearchResultModel *model = [_liveList objectAtIndex:indexPath.row];
    
    if (model.cid.length > 0 ) { //个人
    
        if (![[MineManager sharedInstance] getMyInfo]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadUserLogin object:nil];
            return;
        }
        
        UserLivePlayViewController *vc = [[UserLivePlayViewController alloc] init];
        vc.userLiveChannelModel = model;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else { //官方
        
        LiveChannelModel *channel = [[LiveChannelModel alloc] init];
        channel.liveId = model.liveId;
        channel.liveName = model.liveName;
        channel.liveImg = model.liveImg;
        channel.liveIntroduce = model.liveIntroduce;
        channel.livelink = model.livelink;
        channel.anchorId = model.anchorId;
        channel.anchorName = model.nickName;
        channel.anchorImg = model.headImg;
        channel.isAttent = model.isAttent;
        
        LivePlayViewController *vc = [[LivePlayViewController alloc] init];
        vc.liveChannelModel = channel;
        vc.delegate = self;
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
