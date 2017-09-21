//
//  LiveSearchViewController.m
//  freemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveSearchViewController.h"
#import "LiveSearchQuickChoiceView.h"
#import "LiveSearchResultModel.h"
#import "LiveSearchResultCollectionViewCell.h"
#import "LivePlayViewController.h"
#import "UserLivePlayViewController.h"
#import "MJRefresh.h"
#import "PlayBackDetailViewController.h"

@interface LiveSearchViewController ()
<LiveSearchQuickChoiceViewDelegate,
UITextFieldDelegate,
UICollectionViewDelegate,UICollectionViewDataSource,
UserLivePlayViewControllerDelegate,
LivePlayViewControllerDelegate>
@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,strong) UICollectionView *collView;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,strong) NSMutableArray *resultArray;
@property (nonatomic,strong) LiveSearchQuickChoiceView *choiceView;
@property (nonatomic,assign) NSInteger lastSelectIndex;
@property (nonatomic,strong) NodataView *nodataView;
@end

@implementation LiveSearchViewController

- (void)back {
    
    [_searchTF resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray*)resultArray {
    
    if (!_resultArray) {
        _resultArray = [[NSMutableArray alloc] init];
    }
    return _resultArray;
}

- (UIView*)nodataView {
    
    if (!_nodataView) {
        _nodataView = [[NodataView alloc] initWithTitle:NSLocalizedString(@"no search result data", nil)];
        _nodataView.center = _collView.center;
    }
    
    return _nodataView;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, self.navigationController.navigationBar.maxY)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *whiteBg = [[UIView alloc] init];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.size = CGSizeMake(K_UIScreenWidth-15-45, 32);
    whiteBg.x = 15;
    whiteBg.centerY = (v.height - 20)/2+20;
    whiteBg.layer.cornerRadius = whiteBg.height/2;
    whiteBg.layer.borderColor = UIColor_line_d2d2d2.CGColor;
    whiteBg.layer.borderWidth = 0.5;
    [v addSubview:whiteBg];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_icon.png"]];
    icon.center = CGPointMake(whiteBg.x + 17, whiteBg.centerY);
    [v addSubview:icon];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(icon.maxX + 10, whiteBg.y + (whiteBg.height - 17)/2, whiteBg.maxX - whiteBg.height/2 - (icon.maxX + 10), 17)];
    _searchTF.font = [UIFont systemFontOfSize:16];
    _searchTF.textColor = [UIColor darkGrayColor];
    _searchTF.placeholder = NSLocalizedString(@"search channel", nil);
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.delegate = self;
    [v addSubview:_searchTF];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:NSLocalizedString(@"alert cancel", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.size = CGSizeMake(44, whiteBg.height);
    btn.x = v.width - btn.width;
    btn.centerY = whiteBg.centerY;
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
    
    _lastSelectIndex = -1;
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
    
    [self setupRefresh];
    
    [[LiveManager sharedInstance] getLiveSearchHotWordsCompletion:^(NSArray * _Nullable wordList, NSError * _Nullable error) {
        
        self.choiceView = [[LiveSearchQuickChoiceView alloc] initWithHeight:_collView.height hotwords:wordList history:[LiveManager getLiveSearchHistory]];
        _choiceView.y = navi.maxY;
        _choiceView.delegate = self;
        [self.view addSubview:_choiceView];
    }];
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
    self.pageNum = 1;
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self requestSearch];
    });
}

- (void)footerRereshing
{
    self.pageNum ++;
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self requestSearch];
    });
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestSearch {
    
    [self.nodataView removeFromSuperview];
    
    [[LiveManager sharedInstance] queryLiveByWord:_searchTF.text pageNum:_pageNum completion:^(NSArray * _Nullable queryResultList, NSError * _Nullable error) {
        
        [self.collView headerEndRefreshing];
        [self.collView footerEndRefreshing];
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            if (_pageNum == 1) {
                
                [self.resultArray removeAllObjects];
            }
            
            if (queryResultList.count > 0) {
                
                [self.resultArray addObjectsFromArray:queryResultList];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_collView reloadData];
                
                if (_pageNum == 1) {
                    
                    if (queryResultList.count > 0) {
                        
                        [_collView scrollRectToVisible:CGRectMake(0, 0, _collView.width, _collView.height) animated:NO];
                    }
                }
                
                if (_resultArray.count == 0) {
                    
                    [self.view addSubview:self.nodataView];
                }
            });
        }
    }];
}

- (void)LiveSearchQuickChoiceViewDelegateDidScroll {
    
    [_searchTF resignFirstResponder];
}

- (void)LiveSearchQuickChoiceViewDelegateSearchWord:(NSString *)word {
    
    _searchTF.text = word;
    _choiceView.hidden = YES;
    
    //update history
    NSMutableArray *historys = [LiveManager getLiveSearchHistory];
    if (!historys) {
        historys = [[NSMutableArray alloc] init];
    } else if (historys.count > 0 && [[historys firstObject] isEqualToString:word]) {
        [historys removeObjectAtIndex:0];
    }
    [historys insertObject:word atIndex:0];
    if (historys.count > 25){
        
        [historys removeLastObject];
    }
    [LiveManager saveLiveSearchHistory:historys];
    
    _pageNum = 1;
    [self requestSearch];
    [_searchTF resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    _choiceView.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
//    if (textField.text.length == 0) {
//        return NO;
//    }
    
    if (textField.text.length > 0) {
        
        //update history
        NSMutableArray *historys = [LiveManager getLiveSearchHistory];
        if (!historys) {
            historys = [[NSMutableArray alloc] init];
        } else if (historys.count > 0 && [[historys firstObject] isEqualToString:textField.text]) {
            [historys removeObjectAtIndex:0];
        }
        if(historys.count > 0) {
            [historys insertObject:textField.text atIndex:0];
        } else {
            [historys addObject:textField.text];
        }
        if (historys.count > 25){
            
            [historys removeLastObject];
        }
        [LiveManager saveLiveSearchHistory:historys];
    }
    
    _choiceView.hidden = YES;
    _pageNum = 1;
    [self requestSearch];
    [textField resignFirstResponder];
    
    return YES;
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
    
    return self.resultArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LiveSearchResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.resultModel = [_resultArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LiveSearchResultModel *model = [_resultArray objectAtIndex:indexPath.row];
    
    if (model.cid.length > 0 ) { //个人
        
        if (![[MineManager sharedInstance] getMyInfo]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadUserLogin object:nil];
            return;
        }
        
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
        
        LiveSearchResultModel *model = [_resultArray objectAtIndex:_lastSelectIndex];
        model.isAttent = attent?@"1":@"0";
    }
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
