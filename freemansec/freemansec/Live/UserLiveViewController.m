//
//  UserLiveViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserLiveViewController.h"
#import "UserLivePlayViewController.h"
#import "MJRefresh.h"
#import "LiveSearchResultModel.h"
#import "LiveSearchResultCollectionViewCell.h"

@interface UserLiveViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collView;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,strong) NSMutableArray *liveList;
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
    self.collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, K_UIScreenHeight - 64 - self.tabBarController.tabBar.height) collectionViewLayout:layout];
    _collView.showsVerticalScrollIndicator = NO;
    _collView.showsHorizontalScrollIndicator = NO;
    _collView.delegate = self;
    _collView.dataSource = self;
    [self.view addSubview:_collView];

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

- (void)requestSearch {
    
    [[LiveManager sharedInstance] quaryLiveByType:_typeId pageNum:_pageNum completion:^(NSArray * _Nullable quaryResultList, NSError * _Nullable error) {
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            if (_pageNum == 1) {
                
                [self.liveList removeAllObjects];
                [_collView reloadData];
            }
            
            if (quaryResultList.count > 0) {
                [self.liveList addObjectsFromArray:quaryResultList];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_collView reloadData];
                    
                });
            }
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_collView] && scrollView.contentOffset.y == roundf(scrollView.contentSize.height-scrollView.frame.size.height)) {
        
        [self.collView performBatchUpdates:^{
            
            _pageNum ++;
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
    
    LiveSearchResultModel *model = [_liveList objectAtIndex:indexPath.row];
    
//    if (model.cid.length > 0 ) { //个人
    
        UserLivePlayViewController *vc = [[UserLivePlayViewController alloc] init];
        vc.userLiveChannelModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        
//    } else { //官方
//        
//        LiveChannelModel *channel = [[LiveChannelModel alloc] init];
//        channel.liveId = model.liveId;
//        channel.liveName = model.liveName;
//        channel.liveImg = model.liveImg;
//        channel.liveIntroduce = model.liveIntroduce;
//        channel.livelink = model.livelink;
//        channel.anchorId = model.anchorId;
//        channel.anchorName = model.nickName;
//        channel.anchorImg = model.headImg;
//        
//        LivePlayViewController *vc = [[LivePlayViewController alloc] init];
//        vc.liveChannelModel = channel;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
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
