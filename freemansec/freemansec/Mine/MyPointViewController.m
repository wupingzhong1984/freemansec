//
//  MyPointViewController.m
//  freemansec
//
//  Created by adamwu on 2017/11/23.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyPointViewController.h"
#import "TopupViewController.h"
#import "ConsumeRecordListCell.h"

@interface MyPointViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *recordList;
@property (nonatomic,strong) UILabel *pointLbl;
@property (nonatomic,strong) NSString *userTotalCoin;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MyPointViewController

- (NSMutableArray*)recordList {
    
    if (!_recordList) {
        _recordList = [[NSMutableArray alloc] init];
    }
    
    return _recordList;
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = [UIColor blackColor];
    
    UIView *title = [self commNaviTitle:NSLocalizedString(@"my account", nil) color:[UIColor whiteColor]];
    title.centerY = (v.height - 20)/2 + 20;
    [v addSubview:title];
    
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_back_white.png"]];
    back.centerX = 25;
    back.centerY = (v.height - 20)/2 + 20;
    [v addSubview:back];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.width = back.width + 20;
    btn.height = back.height + 20;
    btn.center = back.center;
    [v addSubview:btn];
    
    return v;
}

- (void)topupAction {
    
    TopupViewController *vc = [[TopupViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView*)topAreaView {
    
    UIView *v = [[UIView alloc] initWithFrame:
                 CGRectMake(0, 0, K_UIScreenWidth, 160)];
    
    UIImageView *topBg = [[UIImageView alloc]
                             initWithImage:[UIImage imageNamed:@"mypoint_topbg.png"]];
    topBg.width = v.width;
    topBg.height = 117;
    [v addSubview:topBg];
    
    self.pointLbl = [UILabel createLabelWithFrame:CGRectZero text:@"0" textColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:34]];
    [_pointLbl sizeToFit];
    _pointLbl.width = v.width;
    _pointLbl.centerY = 30;
    _pointLbl.textAlignment = NSTextAlignmentCenter;
    [v addSubview:_pointLbl];
    
    UILabel *balanceLbl = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"account balance", nil) textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
    [balanceLbl sizeToFit];
    balanceLbl.centerX = _pointLbl.centerX;
    balanceLbl.centerY = _pointLbl.centerY + 30;
    [v addSubview:balanceLbl];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = CGSizeMake(70, 28);
    btn.center = CGPointMake(_pointLbl.centerX, balanceLbl.centerY + 28);
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mypoint_lefticon.png"]] forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedString(@"top-up", nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(topupAction) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    UIImageView *leftIcon = [[UIImageView alloc]
                             initWithImage:[UIImage imageNamed:@"mypoint_lefticon.png"]];
    leftIcon.centerY = v.height - 17;
    [v addSubview:leftIcon];
    
    UILabel *recordLbl = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"records of consumption", nil) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:16]];
    [recordLbl sizeToFit];
    recordLbl.centerY = leftIcon.centerY;
    recordLbl.x = leftIcon.maxX + 10;
    [v addSubview:recordLbl];
    
    return v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    UIView *topArea = [self topAreaView];
    topArea.y = naviBar.maxY;
    [self.view addSubview:topArea];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topArea.maxY, K_UIScreenWidth,K_UIScreenHeight - topArea.maxY) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[ConsumeRecordListCell class] forCellReuseIdentifier:@"ConsumeRecordListCell"];
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [[MineManager sharedInstance] getUserTotalCoinCompletion:^(NSString * _Nullable coin, NSError * _Nullable error) {
        
        if (coin) {
            
            _pointLbl.text = [NSString stringWithFormat:@"%d",(int)[coin intValue]];
        }
    }];
    
    [self.recordList removeAllObjects];
    [[MineManager sharedInstance] getUserConsumeRecordListCompletion:^(NSArray * _Nullable recordList, NSError * _Nullable error) {
        
        [self.recordList removeAllObjects];
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            if (recordList.count > 0) {
                [self.recordList addObjectsFromArray:recordList];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
            });
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.recordList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConsumeRecordListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ConsumeRecordListCell"];
    if (!cell) {
        cell = [[ConsumeRecordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConsumeRecordListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ConsumeRecordModel *model = [self.recordList objectAtIndex:indexPath.row];
    
    cell.recordModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
