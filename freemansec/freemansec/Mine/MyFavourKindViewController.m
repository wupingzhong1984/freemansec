//
//  MyFavourKindViewController.m
//  freemansec
//
//  Created by adamwu on 2017/9/20.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyFavourKindViewController.h"

#import "VideoModel.h"
#import "OfficalVideoModel.h"
#import "MyFavourListCell.h"
//#import "MyOfficalFavourListCell.h"
#import "PlayBackDetailViewController.h"

@interface MyFavourKindViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *favourList;
@property (nonatomic, strong) NodataView *nodataView;
@end

@implementation MyFavourKindViewController


- (NSMutableArray*)favourList {
    
    if (!_favourList) {
        _favourList = [[NSMutableArray alloc] init];
    }
    
    return _favourList;
}

- (UIView*)nodataView {
    
    if (!_nodataView) {
        _nodataView = [[NodataView alloc] initWithTitle:NSLocalizedString(@"no result data", nil)];
        _nodataView.center = _tableView.center;
    }
    
    return _nodataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, K_UIScreenHeight-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[MyFavourListCell class] forCellReuseIdentifier:@"MyFavourListCell"];
    [self.view addSubview:_tableView];
    
    if ([_kind isEqualToString:@"0"]) { //官方
        [self requestGetOfficalFavour];
    } else {
        
        [self requestGetUserFavour];
    }
}

- (void)requestGetOfficalFavour {
    
    [self.nodataView removeFromSuperview];
    
    [[MineManager sharedInstance] getMyOfficalFavourListCompletion:^(NSArray * _Nullable favourList, NSError * _Nullable error) {
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            [self.favourList removeAllObjects];
            
            if (favourList.count > 0) {
                
                [self.favourList addObjectsFromArray:favourList];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
            });
            
            if (self.favourList.count == 0) {
                
                [self.view addSubview:self.nodataView];
            }
        }
    }];
    
}


- (void)requestGetUserFavour {
    
    [self.nodataView removeFromSuperview];
    
    [[MineManager sharedInstance] getMyUserFavourListCompletion:^(NSArray * _Nullable favourList, NSError * _Nullable error) {
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            [self.favourList removeAllObjects];
            
            if (favourList.count > 0) {
                
                [self.favourList addObjectsFromArray:favourList];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
            });
            
            if (self.favourList.count == 0) {
                
                [self.view addSubview:self.nodataView];
            }
        }
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.favourList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90 + 20 + 10; //interface:120*90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyFavourListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyFavourListCell"];
    if (!cell) {
        cell = [[MyFavourListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyFavourListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([_kind isEqualToString:@"0"]) {
        
        OfficalVideoModel * favourModel = [self.favourList objectAtIndex:indexPath.row];
        VideoModel *model = [[VideoModel alloc] init];
        model.videoId = favourModel.videoId;
        model.videoName = favourModel.videoName;
        model.authorName = NSLocalizedString(@"people business live",nil);
        model.playCount = favourModel.playCount;
        cell.videoModel = model;
        
    } else {
        
        VideoModel * favourModel = [self.favourList objectAtIndex:indexPath.row];
        cell.videoModel = favourModel;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([_kind isEqualToString:@"0"]) {
        
        OfficalVideoModel *favourModel = [self.favourList objectAtIndex:indexPath.row];
        
        PlayBackDetailViewController *vc = [[PlayBackDetailViewController alloc] init];
        vc.playBackId = favourModel.videoId;
        vc.name = favourModel.videoName;
        vc.playBackType = @"1";
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        VideoModel *favourModel = [self.favourList objectAtIndex:indexPath.row];
        PlayBackDetailViewController *vc = [[PlayBackDetailViewController alloc] init];
        vc.playBackId = favourModel.videoId;
        vc.name = favourModel.videoName;
        vc.playBackType = @"0";
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
