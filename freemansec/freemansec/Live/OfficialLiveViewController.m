//
//  OfficialLiveViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/21.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "OfficialLiveViewController.h"
#import "OfficialLiveTypeViewController.h"
#import "LivePlayViewController.h"
#import "LiveBannerCollectionViewCell.h"
#import "OfficialLiveType.h"

@interface OfficialLiveViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *bannerList;
@property (nonatomic,strong) UICollectionView *bannerView;
@property (nonatomic,strong) UIScrollView *contentView;
@end

@implementation OfficialLiveViewController

- (NSMutableArray*)bannerList {
    
    if (!_bannerList) {
        
        _bannerList = [[NSMutableArray alloc] init];
    }
    
    return _bannerList;
}

- (void)liveTypeClicked:(id)sender {
    
    int type = (int)((UIButton*)sender).tag - 100;
    OfficialLiveTypeViewController *vc = [[OfficialLiveTypeViewController alloc] init];
    vc.typeIndex = type;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, K_UIScreenHeight - 64 - self.tabBarController.tabBar.height)];
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
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
    _bannerView.backgroundColor = [UIColor blackColor];
    
    CGFloat centerX = 20 + (K_UIScreenWidth-40)/6;
    CGFloat centerY = _bannerView.maxY + 53;
    UIImageView *typeIV;
    UILabel *title;
    UIButton *btn;
    for (int i = 0; i < 6; i++) {
        
        typeIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"live_type_%d.png",i]]];
        typeIV.centerX = centerX;
        typeIV.centerY = centerY;
        [_contentView addSubview:typeIV];
        
        OfficialLiveType *type = [[LiveManager getOfficialLiveTypeList] objectAtIndex:i];
        
        title = [UILabel createLabelWithFrame:CGRectZero text:type.liveTypeName textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:12]];
        [title sizeToFit];
        title.centerX = typeIV.centerX;
        title.y = typeIV.centerY + 34;
        [_contentView addSubview:title];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(liveTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = typeIV.frame;
        btn.tag = i + 100;
        [_contentView addSubview:btn];
        
        if ((i+1)%3==0) {
            
            centerX = 20 + (K_UIScreenWidth-40)/6;
            centerY += 105;
            
        } else {
            
            centerX += (K_UIScreenWidth-40)/3;
        }
    }
    
    _contentView.contentSize = CGSizeMake(_contentView.width, title.maxY + 20);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.hidden = YES;
//    
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    if (([LiveManager liveBannerNeedUpdate] && [[MineManager sharedInstance] getMyInfo]) ||
        (!self.bannerList.count && [[MineManager sharedInstance] getMyInfo])) {
        
        [LiveManager updateLiveBannerLastUpdateTime:[NSDate date]];
        
        [[LiveManager sharedInstance] getLiveBannerCompletion:^(NSArray * _Nullable channelList, NSError * _Nullable error) {
            
            if (error) {
                [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            } else {
                
                BOOL needUpdate = NO;
                if (channelList.count != self.bannerList.count) {
                    needUpdate = YES;
                } else {
                    
                    if (channelList.count != 0) {
                        
                        for (int i = 0; i < channelList.count; i++) {
                            
                            if (![LogicManager isSameLiveChannelModel:[channelList objectAtIndex:i] other:[self.bannerList objectAtIndex:i]]) {
                                needUpdate = YES;
                                break;
                            }
                        }
                    }
                }
                
                if (needUpdate) {
                    [self.bannerList removeAllObjects];
                    [self.bannerList addObjectsFromArray:channelList];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.bannerView reloadData];
                        
                    });
                }
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.hidden = NO;
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
