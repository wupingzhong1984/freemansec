//
//  OfficialLiveTypeViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/12.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "OfficialLiveTypeViewController.h"
#import "PlayBackCollectionViewCell.h"
#import "PlayBackDetailViewController.h"
#import "LiveManager.h"
#import "LivePlayBackModel.h"

@interface OfficialLiveTypeViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *playBackList;
@property (nonatomic,strong) UICollectionView *playBackCollView;
@property (nonatomic,strong) NodataView *nodataView;

@end

@implementation OfficialLiveTypeViewController

- (NSMutableArray*)playBackList {
    
    if (!_playBackList) {
        
        _playBackList = [[NSMutableArray alloc] init];
    }
    
    return _playBackList;
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)nodataView {
    
    if (!_nodataView) {
        _nodataView = [[NodataView alloc] initWithTitle:NSLocalizedString(@"no result data", nil)];
        _nodataView.center = _playBackCollView.center;
    }
    
    return _nodataView;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, self.navigationController.navigationBar.maxY)];
    v.backgroundColor = UIColor_navibg;
    
    [v addSubview:[self commNaviTitle:_typeModel.liveTypeName color:UIColor_navititle]];
    
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_back_gray.png"]];
    back.centerX = 25;
    back.centerY = (v.height - 20)/2 + 20;
    [v addSubview:back];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.width = back.width + 20;
    btn.height = back.height + 20;
    btn.center = back.center;
    [v addSubview:btn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, v.height-0.5, v.width, 0.5)];
    line.backgroundColor = UIColor_line_d2d2d2;
    [v addSubview:line];
    
    return v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    int itemWidth = (int)((K_UIScreenWidth-20-10)/2);
    int itemHeight = (int)(itemWidth*3/4 + 40);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(K_UIScreenWidth,10);
    layout.footerReferenceSize = CGSizeMake(K_UIScreenWidth,10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.playBackCollView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight - naviBar.maxY) collectionViewLayout:layout];
    _playBackCollView.x = 10;
    _playBackCollView.width = K_UIScreenWidth - 20;
    _playBackCollView.backgroundColor = [UIColor clearColor];
    _playBackCollView.delegate = self;
    _playBackCollView.dataSource = self;
    _playBackCollView.showsHorizontalScrollIndicator = NO;
    _playBackCollView.showsVerticalScrollIndicator = NO;
    [_playBackCollView registerClass:[PlayBackCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_playBackCollView];
    
    [[LiveManager sharedInstance] getLivePlayBackListByTypeId:_typeModel.liveTypeId completion:^(NSArray * _Nullable playBackList, NSError * _Nullable error) {
        
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            [self.playBackList removeAllObjects];
            if (playBackList.count > 0) {
                [self.playBackList addObjectsFromArray:playBackList];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.playBackCollView reloadData];
                
            });
            
            if (self.playBackList.count == 0) {
                
                [self.view addSubview:self.nodataView];
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.playBackList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayBackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.playBackModel = [_playBackList objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LivePlayBackModel *model = [self.playBackList objectAtIndex:indexPath.row];
    
    PlayBackDetailViewController *vc = [[PlayBackDetailViewController alloc] init];
    vc.playBackId = model.playbackId;
    vc.name = model.title;
    vc.playBackType = @"1";
    vc.kingPlayBackType = _typeModel.liveTypeId;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)didLiveAttent:(BOOL)attent {
//    
//    if (_lastSelectIndex > -1) {
//        
//        LiveChannelModel *model = [_channelList objectAtIndex:_lastSelectIndex];
//        model.isAttent = attent?@"1":@"0";
//    }
//}

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
