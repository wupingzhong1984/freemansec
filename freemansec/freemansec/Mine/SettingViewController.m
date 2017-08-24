//
//  SettingViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/25.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SettingViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:@"系统设置" color:UIColor_navititle];//NSLocalizedString
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
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth,K_UIScreenHeight - naviBar.maxY) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *lb1;
    UILabel *lb2;
    UIView *line;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        lb1 = [[UILabel alloc] initWithFrame:CGRectZero];
        lb1.font = [UIFont systemFontOfSize:16];
        lb1.textColor = [UIColor blackColor];
        lb1.tag = 1;
        [cell.contentView addSubview:lb1];
        
        lb2 = [[UILabel alloc] initWithFrame:CGRectZero];
        lb2.font = [UIFont systemFontOfSize:16];
        lb2.textColor = [UIColor lightGrayColor];
        lb2.textAlignment = NSTextAlignmentRight;
        lb2.lineBreakMode = NSLineBreakByTruncatingHead;
        lb2.numberOfLines = 1;
        lb2.tag = 2;
        [cell.contentView addSubview:lb2];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 40-0.5, tableView.width, 0.5)];
        line.tag = 3;
        line.backgroundColor = UIColor_line_d2d2d2;
        [cell.contentView addSubview:line];
    }
    
    lb1 = (UILabel*)[cell.contentView viewWithTag:1];
    lb2 = (UILabel*)[cell.contentView viewWithTag:2];
    line = [cell.contentView viewWithTag:3];
    
    if (indexPath.row == 0) {
        lb1.text = @"清除缓存";
        
        CGFloat size = [[SDImageCache sharedImageCache] getSize];
        NSString *message = [NSString stringWithFormat:@"%.2fB", size];
        if (size > 1) {
            message = [NSString stringWithFormat:@"%.0fB", size];
        }
        
        if (size > (1024 * 1024))
        {
            size = size / (1024 * 1024);
            message = [NSString stringWithFormat:@"%.2fM", size];
            if (size > 1) {
                message = [NSString stringWithFormat:@"%.0fM", size];
            }
        }
        else if (size > 1024)
        {
            size = size / 1024;
            message = [NSString stringWithFormat:@"%.2fKB", size];
            if (size > 1) {
                message = [NSString stringWithFormat:@"%.0fKB", size];
            }
        }
        
        lb2.text = message;
        
        
        line.hidden = NO;
    } else {
        lb1.text = @"当前版本";
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        lb2.text = [NSString stringWithFormat:@"V%@",[infoDict objectForKey:@"CFBundleShortVersionString"]];
        line.hidden = YES;
    }
    
    [lb1 sizeToFit];
    [lb2 sizeToFit];
    lb1.x = 10;
    lb1.centerY = 44/2;
    lb2.centerY = lb1.centerY;
    lb2.x = lb1.maxX + 10;
    lb2.width = _tableView.width - 10 - lb2.x;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否清除所有缓存？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                
                [_tableView reloadData];
            }];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
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
