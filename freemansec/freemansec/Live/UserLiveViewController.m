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
LivePlayViewControllerDelegate>

@property (nonatomic,strong) UICollectionView *collView;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,strong) NSMutableArray *liveList;
@property (nonatomic,assign) NSInteger lastSelectIndex;
@end

@implementation UserLiveViewController

- (NSMutableArray*)liveList {
    
    if (!_liveList) {
        _liveList = [[NSMutableArray alloc] init];
    }
    
    return _liveList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    _pageNum = 1;
    _lastSelectIndex = -1;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 20;
    layout.headerReferenceSize = CGSizeMake(0,0);
    layout.footerReferenceSize = CGSizeMake(0,0);
    CGFloat itemWidth = (K_UIScreenWidth-28-20)/2;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth*3/4 + 45);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [layout setHeaderReferenceSize:CGSizeMake(K_UIScreenWidth, 14)];
    [layout setFooterReferenceSize:CGSizeMake(K_UIScreenWidth, 14)];
    self.collView = [[UICollectionView alloc] initWithFrame:CGRectMake(14, 0, K_UIScreenWidth-28, K_UIScreenHeight - 64 - self.tabBarController.tabBar.height) collectionViewLayout:layout];
    _collView.showsVerticalScrollIndicator = NO;
    _collView.showsHorizontalScrollIndicator = NO;
    _collView.delegate = self;
    _collView.dataSource = self;
    _collView.backgroundColor = [UIColor clearColor];
    [_collView registerClass:[LiveSearchResultCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_collView];

    [self requestSearch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.hidden = YES;
//    
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)requestSearch {
    
    [[LiveManager sharedInstance] queryLiveByType:_typeId pageNum:_pageNum completion:^(NSArray * _Nullable queryResultList, NSError * _Nullable error) {
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            if (_pageNum == 1) {
                
                [self.liveList removeAllObjects];
                [_collView reloadData];
            }
            
            if (queryResultList.count > 0) {
                [self.liveList addObjectsFromArray:queryResultList];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_collView reloadData];
                    
                });
            }
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:_collView]) {
        
        return;
    }
    
    if (scrollView.contentOffset.y == roundf(scrollView.contentSize.height-scrollView.frame.size.height)) {
        
        [self.collView performBatchUpdates:^{
            
            _pageNum ++;
            [self requestSearch];
            
        } completion:nil];
    } else {
        
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
