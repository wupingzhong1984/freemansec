//
//  VideoRoot2ViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/15.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VideoRoot2ViewController.h"
#import "MJRefresh.h"
#import "VideoModel.h"
#import "VideoListCell.h"
#import "PlayBackDetailViewController.h"

@interface VideoRoot2ViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videoList;
@property (nonatomic, assign) int pageNum;
@property (nonatomic,strong) NodataView *nodataView;
@end

@implementation VideoRoot2ViewController

- (NSMutableArray*)videoList {
    
    if (!_videoList) {
        _videoList = [[NSMutableArray alloc] init];
    }
    
    return _videoList;
}

- (UIView*)nodataView {
    
    if (!_nodataView) {
        _nodataView = [[NodataView alloc] initWithTitle:NSLocalizedString(@"no result data", nil)];
        _nodataView.center = _tableView.center;
    }
    
    return _nodataView;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:NSLocalizedString(@"hot video", nil) color:UIColor_navititle]; //NSLocalizedString
    title.centerY = (v.height - 20)/2 + 20;
    [v addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, v.height-0.5, v.width, 0.5)];
    line.backgroundColor = UIColor_line_d2d2d2;
    [v addSubview:line];
    
    return v;
}

- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, K_UIScreenWidth, K_UIScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[VideoListCell class] forCellReuseIdentifier:@"VideoListCell"];
    [self.view addSubview:_tableView];
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    //NSLocalizedString
    self.tableView.headerPullToRefreshText = NSLocalizedString(@"release to refresh", nil);
    self.tableView.headerReleaseToRefreshText = NSLocalizedString(@"release then refresh", nil);
    self.tableView.headerRefreshingText = NSLocalizedString(@"updating data please wait", nil);
    
    self.tableView.footerPullToRefreshText = NSLocalizedString(@"pull to get more data", nil);
    self.tableView.footerReleaseToRefreshText = NSLocalizedString(@"release then load more data", nil);
    self.tableView.footerRefreshingText = NSLocalizedString(@"loading data", nil);
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    self.pageNum = 1;
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self requestGetVideo];
    });
}

- (void)footerRereshing
{
    self.pageNum++;
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self requestGetVideo];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    self.pageNum = 1;
    [self requestGetVideo];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestGetVideo {
    
    [self.nodataView removeFromSuperview];
    
    [[VideoManager sharedInstance] getVideoListPageNum:_pageNum completion:^(NSArray * _Nullable videoList, NSError * _Nullable error) {
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            if (self.pageNum == 1) {
                [self.videoList removeAllObjects];
            }
            
            if (videoList.count > 0) {
                
                [self.videoList addObjectsFromArray:videoList];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
                if (self.pageNum == 1) {
                    if (videoList.count > 0) {
                        
                        [self.tableView scrollRectToVisible:CGRectMake(0, 0, _tableView.width, _tableView.height) animated:NO];
                    }
                }
                
                if (self.videoList.count == 0) {
                    
                    [self.view addSubview:self.nodataView];
                }
            });
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.videoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90 + 20 + 10; //interface:120*90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VideoListCell"];
    if (!cell) {
        cell = [[VideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VideoListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    VideoModel * videoModel = [self.videoList objectAtIndex:indexPath.row];
    
    cell.videoModel = videoModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (![[MineManager sharedInstance] getMyInfo]) {
     
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadUserLogin object:nil];
        return;
    }
    
    VideoModel * videoModel = [self.videoList objectAtIndex:indexPath.row];
    
    PlayBackDetailViewController *vc = [[PlayBackDetailViewController alloc] init];
    vc.playBackId = videoModel.videoId;
    vc.name = videoModel.videoName;
    vc.playBackType = @"0";
    [self.navigationController pushViewController:vc animated:YES];
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
