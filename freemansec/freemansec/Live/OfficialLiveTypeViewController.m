//
//  OfficialLiveTypeViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/12.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "OfficialLiveTypeViewController.h"
#import "CustomNaviController.h"
#import "LivePlayViewController.h"
#import "LiveTypeChannelCollectionViewCell.h"
#import "LiveManager.h"
#import "OfficialLiveType.h"

@interface OfficialLiveTypeViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,
LivePlayViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *channelList;
@property (nonatomic,strong) UICollectionView *channelCollView;
@property (nonatomic,assign) NSInteger lastSelectIndex;

@end

@implementation OfficialLiveTypeViewController

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
    v.backgroundColor = UIColor_navibg;
    
    OfficialLiveType *type = [[LiveManager getOfficialLiveTypeList] objectAtIndex:_typeIndex];
    [v addSubview:[self commNaviTitle:type.liveTypeName color:UIColor_navititle]];
    
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
    _lastSelectIndex = -1;
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
    [_channelCollView registerClass:[LiveTypeChannelCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_channelCollView];
    
    OfficialLiveType *type = [[LiveManager getOfficialLiveTypeList] objectAtIndex:_typeIndex];
    
    [[LiveManager sharedInstance] getLiveListByLiveTypeId:type.liveTypeId completion:^(NSArray * _Nullable channelList, NSError * _Nullable error) {
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            if (channelList.count > 0) {
                
                [self.channelList removeAllObjects];
                [self.channelList addObjectsFromArray:channelList];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.channelCollView reloadData];
                    
                });
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
    
    return self.channelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _lastSelectIndex = indexPath.row;
    LiveTypeChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.channelModel = [_channelList objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LivePlayViewController *vc = [[LivePlayViewController alloc] init];
    vc.liveChannelModel = [_channelList objectAtIndex:indexPath.row];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didLiveAttent:(BOOL)attent {
    
    if (_lastSelectIndex > -1) {
        
        LiveChannelModel *model = [_channelList objectAtIndex:_lastSelectIndex];
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
