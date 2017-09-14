//
//  VideoKindViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/23.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VideoKindViewController.h"
#import "MJRefresh.h"
#import "VideoModel.h"
#import "VideoListCell.h"

@interface VideoKindViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videoList;
@property (nonatomic, assign) int pageNum;
@end

@implementation VideoKindViewController

- (NSMutableArray*)videoList {
    
    if (!_videoList) {
        _videoList = [[NSMutableArray alloc] init];
    }
    
    return _videoList;
}

- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
    
    self.pageNum = 1;
    // 2.2秒后刷新表格UI
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self requestGetVideo];
//        });
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
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    [self createTableView];
}

- (void)requestGetVideo {
    
    //todo
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
    
    VideoModel * videoModel = [self.videoList objectAtIndex:indexPath.row];
    //todo
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
