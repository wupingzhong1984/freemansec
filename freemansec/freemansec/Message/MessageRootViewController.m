//
//  MessageRootViewController.m
//  freemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MessageRootViewController.h"
#import "MJRefresh.h"
#import "MsgModel.h"
#import "MsgListCell.h"

@interface MessageRootViewController ()
<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *msgList;
@property (nonatomic,strong) NodataView *nodataView;
@property (nonatomic, assign) BOOL didLoginAppear;
@end

@implementation MessageRootViewController

- (NSMutableArray*)msgList {
    
    if (!_msgList) {
        _msgList = [[NSMutableArray alloc] init];
    }
    
    return _msgList;
}

- (UIView*)nodataView {
    
    if (!_nodataView) {
        _nodataView = [[NodataView alloc] initWithTitle:@"暂无数据"];
        _nodataView.center = _tableView.center;
    }
    
    return _nodataView;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, self.navigationController.navigationBar.maxY)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:@"消息" color:UIColor_navititle];//NSLocalizedString
    title.centerY = (v.height - 20)/2 + 20;
    [v addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, v.height-0.5, v.width, 0.5)];
    line.backgroundColor = UIColor_line_d2d2d2;
    [v addSubview:line];
    
    return v;
}

- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, K_UIScreenWidth, K_UIScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[MsgListCell class] forCellReuseIdentifier:@"MsgListCell"];
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
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在拼命的刷新数据中，请稍后!";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在拼命的加载中";
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self requestGetUnReadMsg];
    });
}

- (void)footerRereshing
{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.msgList.count == 0) {
           
            [self requestGetUnReadMsg];
            
        } else {
            
            MsgModel *last = [self.msgList lastObject];
            [self requestGetMoreMsg:last.msgId];
        }
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
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    if (![[MineManager sharedInstance] getMyInfo]) {
        [self.msgList removeAllObjects];
        [self.tableView reloadData];
        [self.nodataView removeFromSuperview]; //clear
        [self.view addSubview:self.nodataView];
        if (!_didLoginAppear) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您还未登录" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"一会再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.nodataView removeFromSuperview]; //clear
                [self.view addSubview:self.nodataView];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                _didLoginAppear = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadUserLogin object:nil];
                
            }]];
            [self presentViewController:alert animated:alert completion:nil];
        } else {
            _didLoginAppear = NO;
        }
        
    } else {
    
        if (self.msgList.count == 0) {
            
            [self.msgList addObjectsFromArray:[[MessageManager sharedInstance] getLocalMsgListOrderByMsgIdDESC]];
            [self.tableView reloadData];
        }
    
        [self requestGetUnReadMsg];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    [[MessageManager sharedInstance] updateAllLocalMsgReaded];
    
    for (MsgModel *model in self.msgList) {
        model.isRead = @"1";
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestGetUnReadMsg {
    
    [self.nodataView removeFromSuperview];
    
    [[MessageManager sharedInstance] getNewMsgListCompletion:^(NSArray * _Nullable msgList, NSError * _Nullable error) {
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            if (msgList && msgList.count > 0) {
                
                [[MessageManager sharedInstance] insertMsgList:msgList];
                for (int i = msgList.count; i > 0; i--) {
                    
                    [self.msgList insertObject:[msgList objectAtIndex:(i-1)] atIndex:0];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMsgCenterTabRedPoint object:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                });
            }
            
            if (_msgList.count == 0) {
                
                [self.view addSubview:self.nodataView];
            }
            
        }
    }];
}

- (void)requestGetMoreMsg:(NSString*)lastMsgId {
    
    [self.nodataView removeFromSuperview];
    
    [[MessageManager sharedInstance] getMsgListLastMsgId:lastMsgId completion:^(NSArray * _Nullable msgList, NSError * _Nullable error) {
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            
            if (msgList && msgList.count > 0) {
                
                [[MessageManager sharedInstance] insertMsgList:msgList];
                
                [self.msgList addObjectsFromArray:msgList];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                });
            }
            
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.msgList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    MsgModel *model = [self.msgList objectAtIndex:indexPath.row];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_cell_icon.png"]];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(imgV.width + 20, 72/2+5, K_UIScreenWidth - 10 - (50 + 20), 0)];
    [Utility formatLabel:lbl text:model.content font:[UIFont systemFontOfSize:15] lineSpacing:5];
    
    return lbl.maxY + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MsgListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MsgListCell"];
    if (!cell) {
        cell = [[MsgListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MsgListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MsgModel *model = [self.msgList objectAtIndex:indexPath.row];
    
    cell.msgModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
