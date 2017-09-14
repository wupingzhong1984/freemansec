//
//  MyAttentionViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "LiveSearchResultModel.h"
#import "LiveSearchResultCollectionViewCell.h"
#import "LivePlayViewController.h"
#import "UserLivePlayViewController.h"

@interface MyAttentionViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collView;
@property (nonatomic, strong) NSMutableArray *attenList;
@property (nonatomic,strong) NodataView *nodataView;
@end

@implementation MyAttentionViewController

- (NSMutableArray*)attenList {
    
    if (!_attenList) {
        _attenList = [[NSMutableArray alloc] init];
    }
    
    return _attenList;
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)nodataView {
    
    if (!_nodataView) {
        _nodataView = [[NodataView alloc] initWithTitle:@"暂无数据"];
        _nodataView.center = _collView.center;
    }
    
    return _nodataView;
}

- (UIView*)naviBarView {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:NSLocalizedString(@"my attentions", nil) color:UIColor_navititle];//NSLocalizedString
    title.centerY = (v.height - 20)/2 + 20;
    [v addSubview:title];
    
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
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    UIView *navi = [self naviBarView];
    [self.view addSubview:navi];
    
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
    self.collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navi.maxY, K_UIScreenWidth, K_UIScreenHeight - navi.maxY) collectionViewLayout:layout];
    _collView.showsVerticalScrollIndicator = NO;
    _collView.showsHorizontalScrollIndicator = NO;
    _collView.delegate = self;
    _collView.dataSource = self;
    _collView.backgroundColor = [UIColor clearColor];
    [_collView registerClass:[LiveSearchResultCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_collView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    [self requestGetAttention];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)requestGetAttention {
    
    [self.nodataView removeFromSuperview];
    
    [[MineManager sharedInstance] getMyAttentionListCompletion:^(NSArray * _Nullable attenList, NSError * _Nullable error) {
        
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            [self.attenList removeAllObjects];
            if (attenList.count > 0) {
                [self.attenList addObjectsFromArray:attenList];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collView reloadData];
                
            });
            
            if (self.attenList.count == 0) {
                
                [self.view addSubview:self.nodataView];
            }
        }
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.attenList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LiveSearchResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.resultModel = [_attenList objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LiveSearchResultModel * model = [self.attenList objectAtIndex:indexPath.row];
    if (model.cid.length > 0) { //个人
        model.isAttent = @"1";
        
        UserLivePlayViewController *vc = [[UserLivePlayViewController alloc] init];
        vc.userLiveChannelModel = model;
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
        channel.isAttent = @"1";
        
        LivePlayViewController *vc = [[LivePlayViewController alloc] init];
        vc.liveChannelModel = channel;
        [self.navigationController pushViewController:vc animated:YES];
        
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
