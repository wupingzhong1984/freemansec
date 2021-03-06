//
//  OfficialLiveViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/21.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "OfficialLiveViewController.h"
#import "LivePlayViewController.h"
#import "LiveBannerCollectionViewCell.h"
#import "OfficialLiveTypeModel.h"
#import "LiveProgramCellView.h"
#import "LiveWonderPlayBackCellView.h"
#import "PlayBackCollectionViewCell.h"
#import "PlayBackDetailViewController.h"
#import "MoreWonderPlayBackViewController.h"
#import "LiveTypeCollectionViewCell.h"
#import "PlayBackListByUserViewController.h"

@interface OfficialLiveViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,
LivePlayViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *bannerList;
@property (nonatomic,strong) UICollectionView *bannerCollView;
@property (nonatomic,assign) NSInteger lastBannerSelectIndex;

@property (nonatomic,strong) UISegmentedControl *segmentedControl;

@property (nonatomic,strong) UIScrollView *todayLiveContentView;
@property (nonatomic,strong) NSMutableArray *programList;
@property (nonatomic,strong) UIView *programArea;
@property (nonatomic,strong) UIView *wonderfulPlayBackArea;
@property (nonatomic,strong) NSMutableArray *wonderfulPlayBackList;
@property (nonatomic,strong) UICollectionView *wonderfulPlayBackCollView;

@property (nonatomic,strong) NSMutableArray *kingProgramLiveTypeList;
@property (nonatomic,strong) UICollectionView *kingProgramLiveTypeCollView;
@end

@implementation OfficialLiveViewController

- (NSMutableArray*)bannerList {
    
    if (!_bannerList) {
        
        _bannerList = [[NSMutableArray alloc] init];
    }
    
    return _bannerList;
}

- (NSMutableArray*)programList {
    
    if (!_programList) {
        
        _programList = [[NSMutableArray alloc] init];
    }
    
    return _programList;
}

- (NSMutableArray*)wonderfulPlayBackList {
    
    if (!_wonderfulPlayBackList) {
        
        _wonderfulPlayBackList = [[NSMutableArray alloc] init];
    }
    
    return _wonderfulPlayBackList;
}

- (NSMutableArray*)kingProgramLiveTypeList {
    
    if (!_kingProgramLiveTypeList) {
        
        _kingProgramLiveTypeList = [[NSMutableArray alloc] init];
    }
    
    return _kingProgramLiveTypeList;
}

- (void)setupBannerArea {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(K_UIScreenWidth, K_UIScreenWidth*3/4);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.bannerCollView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, K_UIScreenWidth*3/4) collectionViewLayout:layout];
    _bannerCollView.backgroundColor = [UIColor whiteColor];
    _bannerCollView.delegate = self;
    _bannerCollView.dataSource = self;
    _bannerCollView.showsHorizontalScrollIndicator = NO;
    _bannerCollView.showsVerticalScrollIndicator = NO;
    [_bannerCollView registerClass:[LiveBannerCollectionViewCell class] forCellWithReuseIdentifier:@"BannerCell"];
    [self.view addSubview:_bannerCollView];
    _bannerCollView.backgroundColor = [UIColor blackColor];
}

- (void)setupSegmentControl {
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"today living", nil),NSLocalizedString(@"king program", nil), nil]];
    _segmentedControl.frame = CGRectMake(7, (int)(_bannerCollView.maxY + 10), K_UIScreenWidth - 14, 34);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = UIColor_82b432;
    [_segmentedControl addTarget:self action:@selector(segmentaAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
}

- (void)segmentaAction:(UISegmentedControl*)seg {
    
    if (seg.selectedSegmentIndex == 0) {
        
        _todayLiveContentView.hidden = NO;
        _kingProgramLiveTypeCollView.hidden = YES;
        
    } else {
        
        _todayLiveContentView.hidden = YES;
        _kingProgramLiveTypeCollView.hidden = NO;
    }
}

- (void)setupTodayLiveArea {
    
    self.todayLiveContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentedControl.maxY + 10, K_UIScreenWidth, K_UIScreenHeight - 64 - self.tabBarController.tabBar.height - (_segmentedControl.maxY + 10))];
    _todayLiveContentView.showsVerticalScrollIndicator = NO;
    _todayLiveContentView.showsHorizontalScrollIndicator = NO;
    _todayLiveContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_todayLiveContentView];
    
    self.programArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _todayLiveContentView.width, 0)];
    _programArea.backgroundColor = [UIColor whiteColor];
    [_todayLiveContentView addSubview:_programArea];
    
    self.wonderfulPlayBackArea = [[UIView alloc] initWithFrame:CGRectMake(0, _programArea.maxY + 7, _todayLiveContentView.width, 0)];
    _wonderfulPlayBackArea.backgroundColor = UIColor_vc_bgcolor_lightgray;
    [_todayLiveContentView addSubview:_wonderfulPlayBackArea];
    
    _todayLiveContentView.contentSize = CGSizeMake(_todayLiveContentView.width, _todayLiveContentView.maxY + 25);
}

- (void)reloadProgramArea {
    
    for (UIView *sub in _programArea.subviews) {
        
        [sub removeFromSuperview];
    }
    if (self.programList.count > 0) {
        
        UIImage *icon = [UIImage imageNamed:@"liveprogram_icon.png"];
        UIView *headLine = [[UIView alloc] initWithFrame:CGRectMake(10+icon.size.width/2, 22/2, 0.5, 0)];
        headLine.backgroundColor = UIColor_line_d2d2d2;
        [_programArea addSubview:headLine];
        
        NSInteger programIndex = 0;
        LiveProgramCellView *cellView;
        CGFloat originY = 0;
        for (LiveProgramModel *program in self.programList) {
            
            cellView = [[LiveProgramCellView alloc] initWithProgram:program width:(_programArea.width - 30)];
            cellView.x = 10;
            cellView.y = originY;
            [_programArea addSubview:cellView];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = programIndex+1000;
            [btn addTarget:self action:@selector(loadLiveProgram:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = cellView.frame;
            [_programArea addSubview:btn];
            
            originY += cellView.height;
            programIndex ++;
            if (programIndex != self.programList.count) {
                originY += 12;
            }
        }
        _programArea.height = cellView.maxY + 10;
        headLine.height = cellView.maxY - headLine.y;
    } else {
        
        _programArea.height = 60;
        //NSLocalizedString
        UILabel *noData = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"none program", nil) textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:16]];
        [noData sizeToFit];
        noData.center = CGPointMake(_programArea.width/2, _programArea.height/2);
        [_programArea addSubview:noData];
    }
    
    [self reloadWonderfulPlayBackArea];
}

- (void)reloadWonderfulPlayBackArea {
    
    _wonderfulPlayBackArea.y = _programArea.maxY;
    for (UIView *sub in _wonderfulPlayBackArea.subviews) {
        
        [sub removeFromSuperview];
    }
    
    UIView *whiteBg = [[UIView alloc] initWithFrame:CGRectMake(0, 7, _wonderfulPlayBackArea.width, 38)];
    whiteBg.backgroundColor = [UIColor whiteColor];
    [_wonderfulPlayBackArea addSubview:whiteBg];
    
    UIView *green = [[UIView alloc] initWithFrame:CGRectMake(10, (38-18)/2, 3, 18)];
    green.backgroundColor = UIColor_82b432;
    [whiteBg addSubview:green];
    
    //NSLocalizedString
    UILabel *title = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"wonder playback", nil) textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:16]];
    [title sizeToFit];
    title.x = 20;
    title.centerY = 38/2;
    [whiteBg addSubview:title];
    
    if (self.wonderfulPlayBackList.count > 0) {
        
        BOOL showMore;
        NSInteger maxCount;
        if (self.wonderfulPlayBackList.count > 8) {
            maxCount = 8;
            showMore = YES;
        } else {
            maxCount = self.wonderfulPlayBackList.count;
            showMore = NO;
        }
        
        LiveWonderPlayBackCellView *cell;
        CGFloat originX = 10;
        CGFloat originY = 38;
        CGFloat itemWidth = (K_UIScreenWidth - originX*2 - 15)/2;
        for (int i = 0; i < maxCount; i++) {
            
            cell = [[LiveWonderPlayBackCellView alloc] initWithPlayBack:[self.wonderfulPlayBackList objectAtIndex:i] width:itemWidth];
            cell.origin = CGPointMake(originX, originY);
            [whiteBg addSubview:cell];
            
            UIButton *cb = [UIButton buttonWithType:UIButtonTypeCustom];
            cb.frame = cell.frame;
            cb.tag = 100+i;
            [cb addTarget:self action:@selector(loadWonderPlayBack:) forControlEvents:UIControlEventTouchUpInside];
            [whiteBg addSubview:cb];
            
            if ((i+1)%2 == 0) {
                originX = 10;
                originY += cell.height + 10;
            } else {
                originX += 15 + cell.width;
            }
        }
        
        whiteBg.height = cell.maxY;
        
        if (showMore) {
            
            //NSLocalizedString
            UILabel *more = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"see more", nil) textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
            [more sizeToFit];
            more.centerY = title.centerY;
            more.x = whiteBg.width - 10 - more.width;
            [whiteBg addSubview:more];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.size = CGSizeMake(more.width + 20, more.height + 20);
            btn.center = more.center;
            [btn addTarget:self action:@selector(loadMoreWonderPlayBack) forControlEvents:UIControlEventTouchUpInside];
            [whiteBg addSubview:btn];
        }
        
    } else {
        
        whiteBg.height = whiteBg.height + 60;
        //NSLocalizedString
        UILabel *noData = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"none program", nil) textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:16]];
        [noData sizeToFit];
        noData.center = CGPointMake(_wonderfulPlayBackArea.width/2, 37 + 60/2);
        [whiteBg addSubview:noData];
    }
    whiteBg.height = whiteBg.height + 20;
    _wonderfulPlayBackArea.height = whiteBg.maxY;
    _todayLiveContentView.contentSize = CGSizeMake(_todayLiveContentView.width, _wonderfulPlayBackArea.maxY);
}

- (void)loadLiveProgram:(id)sender {
    
    LiveProgramModel *model = [self.programList objectAtIndex:(((UIButton*)sender).tag - 1000)];
    
    if (![model.status isEqualToString:@"1"]) {
        
        return;
    }
    
    LiveChannelModel *channelModel = [[LiveChannelModel alloc] init];
    channelModel.liveName = model.title;
    channelModel.liveImg = model.liveImg;
    channelModel.liveIntroduce = model.desc;
    channelModel.livelink = model.liveLink;
    channelModel.anchorName = model.anchorName;
    
    LivePlayViewController *vc = [[LivePlayViewController alloc] init];
    vc.liveChannelModel = channelModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadWonderPlayBack:(id)sender {
    
    LivePlayBackModel *model = [self.wonderfulPlayBackList objectAtIndex:((UIButton*)sender).tag - 100];
    PlayBackDetailViewController *vc = [[PlayBackDetailViewController alloc] init];
    vc.playBackId = model.playbackId;
    vc.name = model.title;
    vc.playBackType = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadMoreWonderPlayBack {
    
    MoreWonderPlayBackViewController *vc = [[MoreWonderPlayBackViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupKingPlayBackArea {
    
    int itemWidth = (int)((K_UIScreenWidth-20-10)/2);
    int itemHeight = (int)(itemWidth*3/4 + 40);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.kingProgramLiveTypeCollView = [[UICollectionView alloc] initWithFrame:_todayLiveContentView.frame collectionViewLayout:layout];
    _kingProgramLiveTypeCollView.x = 10;
    _kingProgramLiveTypeCollView.width = K_UIScreenWidth - 20;
    _kingProgramLiveTypeCollView.backgroundColor = [UIColor whiteColor];
    _kingProgramLiveTypeCollView.delegate = self;
    _kingProgramLiveTypeCollView.dataSource = self;
    _kingProgramLiveTypeCollView.showsHorizontalScrollIndicator = NO;
    _kingProgramLiveTypeCollView.showsVerticalScrollIndicator = NO;
    [_kingProgramLiveTypeCollView registerClass:[LiveTypeCollectionViewCell class] forCellWithReuseIdentifier:@"LiveTypeCell"];
    [self.view addSubview:_kingProgramLiveTypeCollView];
    _kingProgramLiveTypeCollView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _lastBannerSelectIndex = -1;
    
    [self setupBannerArea];
    
    [self setupSegmentControl];
    
    [self setupTodayLiveArea];
    
    [self setupKingPlayBackArea];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.hidden = YES;
//    
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    
    if ([LiveManager liveBannerNeedUpdate] || !self.bannerList.count) {
        
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
                        
                        [_bannerCollView reloadData];
                        
                    });
                }
            }
        }];
    }
    
    [self requstLiveProgram];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)requstLiveProgram {
    
    [[LiveManager sharedInstance] getLiveProgramListCompletion:^(NSArray * _Nullable programlList, NSError * _Nullable error) {
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            [self.programList removeAllObjects];
            if (programlList && programlList.count > 0) {
                
                [self.programList addObjectsFromArray:programlList];
            }
        }
        
        [self requestWonderfulPlayBack];
    }];
}

- (void)requestWonderfulPlayBack {
    
    [[LiveManager sharedInstance] getLivePlayBackListByTypeId:@"0" completion:^(NSArray * _Nullable playList, NSError * _Nullable error) {
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            [self.wonderfulPlayBackList removeAllObjects];
            if (playList && playList.count > 0) {
                
                [self.wonderfulPlayBackList addObjectsFromArray:playList];
            }
        }
        
        [self requestKingProgramLiveType];
    }];
}

- (void)requestKingProgramLiveType {
    
    [[LiveManager sharedInstance] getKingProgramLiveTypeListCompletion:^(NSArray * _Nullable typeList, NSError * _Nullable error) {
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            [self.kingProgramLiveTypeList removeAllObjects];
            if (typeList && typeList.count > 0) {
                
                [self.kingProgramLiveTypeList addObjectsFromArray:typeList];
            }
            
        }
        
        [self reloadProgramArea];
        [_kingProgramLiveTypeCollView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([collectionView isEqual:_bannerCollView]) {
        return self.bannerList.count;
    }
    
    if ([collectionView isEqual:_kingProgramLiveTypeCollView]) {
        return self.kingProgramLiveTypeList.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:_bannerCollView]) {
        
        LiveBannerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BannerCell" forIndexPath:indexPath];
        cell.channelModel = [self.bannerList objectAtIndex:indexPath.row];
        
        return cell;
    } else {
        
        LiveTypeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveTypeCell" forIndexPath:indexPath];
        cell.typeModel = [self.kingProgramLiveTypeList objectAtIndex:indexPath.row];
        
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:_bannerCollView]) {
        _lastBannerSelectIndex = indexPath.row;
        LivePlayViewController *vc = [[LivePlayViewController alloc] init];
        vc.liveChannelModel = [self.bannerList objectAtIndex:indexPath.row];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        OfficialLiveTypeModel *model = [self.kingProgramLiveTypeList objectAtIndex:indexPath.row];
        PlayBackListByUserViewController *vc = [[PlayBackListByUserViewController alloc] init];
        vc.typeId = model.liveTypeId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didLiveAttent:(BOOL)attent {
    
    if (_lastBannerSelectIndex > -1) {
        
        LiveChannelModel *model = [_bannerList objectAtIndex:_lastBannerSelectIndex];
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
