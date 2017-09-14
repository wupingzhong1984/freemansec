//
//  MoreWonderPlayBackViewController.m
//  freemansec
//
//  Created by adamwu on 2017/9/1.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MoreWonderPlayBackViewController.h"
#import "WonderPlayBackCollectionViewCell.h"
#import "LivePlayBackModel.h"
#import "PlayBackDetailViewController.h"

@interface MoreWonderPlayBackViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *playbackList;
@property (nonatomic,strong) UICollectionView *playbackCollView;
@end

@implementation MoreWonderPlayBackViewController

- (NSMutableArray*)playbackList {
    
    if (!_playbackList) {
        _playbackList = [[NSMutableArray alloc] init];
    }
    
    return _playbackList;
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, self.navigationController.navigationBar.maxY)];
    v.backgroundColor = UIColor_navibg;
    
    //NSLocalizedString
    [v addSubview:[self commNaviTitle:NSLocalizedString(@"wonder playback", nil) color:UIColor_navititle]];
    
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
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 15;
    layout.minimumLineSpacing = 15;
    layout.headerReferenceSize = CGSizeMake(K_UIScreenWidth,15);
    layout.footerReferenceSize = CGSizeMake(K_UIScreenWidth,15);
    CGFloat itemWidth = (K_UIScreenWidth-15-20)/2;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth*3/4 + 30);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.playbackCollView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, naviBar.maxY, K_UIScreenWidth-20, K_UIScreenHeight - naviBar.maxY) collectionViewLayout:layout];
    _playbackCollView.backgroundColor = [UIColor clearColor];
    _playbackCollView.delegate = self;
    _playbackCollView.dataSource = self;
    _playbackCollView.showsHorizontalScrollIndicator = NO;
    _playbackCollView.showsVerticalScrollIndicator = NO;
    [_playbackCollView registerClass:[WonderPlayBackCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_playbackCollView];

    [[LiveManager sharedInstance] getLivePlayBackListByTypeId:@"0" completion:^(NSArray * _Nullable playList, NSError * _Nullable error) {
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            [self.playbackList removeAllObjects];
            if (playList && playList.count > 0) {
                
                [self.playbackList addObjectsFromArray:playList];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.playbackCollView reloadData];
            });
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.playbackList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WonderPlayBackCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.playBackModel = [self.playbackList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LivePlayBackModel *model = [self.playbackList objectAtIndex:indexPath.row];
        PlayBackDetailViewController *vc = [[PlayBackDetailViewController alloc] init];
        vc.playBackId = model.playbackId;
        [self.navigationController pushViewController:vc animated:YES];
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
