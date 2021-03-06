//
//  MineRootViewController.m
//  freemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MineRootViewController.h"
#import "MinePersonInfoViewController.h"
#import "DottedLineView.h"
#import "MyVideoViewController.h"
#import "MyFavourViewController.h"
#import "MyAttentionViewController.h"
#import "ApplyAnchorViewController.h"
#import "SettingViewController.h"
#import "RealNameCertifyViewController.h"
#import "MyPointViewController.h"

@interface MineRootViewController ()
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *imgArray;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *pointBg;
@property (nonatomic,strong) UILabel *pLbl;
@property (nonatomic,strong) UILabel *pointLbl;
@property (nonatomic,strong) NSString *userTotalCoin;
@end

@implementation MineRootViewController

- (NSMutableArray*)imgArray {
    
    if (!_imgArray) {
        
        _imgArray = [NSMutableArray arrayWithObjects:
                     @"mineroot_cell_img_0.png",
                     @"mineroot_cell_img_1.png",
                     @"mineroot_cell_img_2.png",
                     @"mineroot_cell_img_3.png",
                     @"mineroot_cell_img_4.png",
                     @"mineroot_cell_img_5.png", nil];
    }
    return _imgArray;
}

- (NSMutableArray*)titleArray {
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:
                       NSLocalizedString(@"my account", nil),
                       NSLocalizedString(@"my videos", nil),
                       NSLocalizedString(@"video favour", nil),
                       NSLocalizedString(@"my attentions", nil),
                       NSLocalizedString(@"anchor apply", nil),
                       NSLocalizedString(@"setting", nil), nil];
    }
    return _titleArray;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, 20)];
    v.backgroundColor = UIColor_navibg;
    
    return v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    self.userTotalCoin = @"0";
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight-naviBar.maxY-self.tabBarController.tabBar.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
//    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    if ([[MineManager sharedInstance] getMyInfo]) {
        
        [[MineManager sharedInstance] getUserTotalCoinCompletion:^(NSString * _Nullable coin, NSError * _Nullable error) {
            if (coin) {
                
                _pointLbl.text = [NSString stringWithFormat:@"%d",(int)[coin intValue]];
                [_pointLbl sizeToFit];
                _pointBg.width = _pLbl.width + _pointLbl.width + 13*3;
                _pointBg.centerX = _tableView.width/2;
                _pLbl.x = _pointBg.x + 13;
                _pLbl.centerY = _pointBg.centerY;
                _pointLbl.x = _pLbl.maxX + 13;
                _pointLbl.centerY = _pointBg.centerY;
                
            } else {
                
                NNSLog(@"getUserTotalCoin error.")
            }
        }];
    } else {
        
        self.userTotalCoin = @"0";
    }
    
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.hidden = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 10.0f;
    } else {
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0)];
    return v;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0)];
    v.backgroundColor = UIColor_vc_bgcolor_lightgray;
    if (section == 0) {
        v.height = 10.0f;
    } else {
        v.height = 0;
    }
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        return 190;
    }
    
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView topCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell"];
    
    UIImageView *face;
    UILabel *name;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor blackColor];
        
        UIView *container = [[UIView alloc] init];
        container.size = CGSizeMake(tableView.width, 190);
        container.clipsToBounds = YES;
        [cell.contentView addSubview:container];
        
        UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mycenter_headbg.png"]];
        bgImg.size = container.size;
        [container addSubview:bgImg];
        
        UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
        visualEffectView.size = container.size;
        visualEffectView.alpha = 0.5;
        [container addSubview:visualEffectView];
        
        UIView *con1 = [[UIView alloc] init];
        con1.clipsToBounds = YES;
        con1.size = CGSizeMake(68, 68);
        con1.center = CGPointMake(container.width/2, 60);
        con1.layer.cornerRadius = con1.width/2;
        [container addSubview:con1];
        
        UIVisualEffectView *visualEffectView2 = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
        visualEffectView2.size = con1.size;
        visualEffectView2.alpha = 0.5;
        visualEffectView2.center = CGPointMake(con1.width/2, con1.width/2);
        [con1 addSubview:visualEffectView2];
        
        face = [[UIImageView alloc] init];
        face.clipsToBounds = YES;
        face.tag = 1;
        face.size = CGSizeMake(64, 64);
        face.layer.cornerRadius = face.width/2;
        face.center = visualEffectView2.center;
        [con1 addSubview:face];
        
        name = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"no login", nil) textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16]];
        name.tag = 2;
        [name sizeToFit];
        name.width = tableView.width;
        name.textAlignment = NSTextAlignmentCenter;
        name.centerX = con1.centerX;
        name.centerY = 117;
        [container addSubview:name];
        
        self.pointBg = [[UIView alloc]init];
        _pointBg.clipsToBounds = YES;
        _pointBg.y = 140;
        _pointBg.height = 28;
        _pointBg.layer.cornerRadius = _pointBg.height/2;
        [container addSubview:_pointBg];
        
        UIVisualEffectView *visualEffectView3 = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
        visualEffectView3.width = K_UIScreenWidth;
        visualEffectView3.height = _pointBg.height;
        visualEffectView3.alpha = 0.5;
        [_pointBg addSubview:visualEffectView3];
        
        self.pLbl = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"point num", nil) textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
        [_pLbl sizeToFit];
        [container addSubview:_pLbl];
        
        self.pointLbl = [UILabel createLabelWithFrame:CGRectZero text:@"0" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16]];
        [_pointLbl sizeToFit];
        [container addSubview:_pointLbl];
        
    }
    
    face = (UIImageView*)[cell.contentView viewWithTag:1];
    name = (UILabel*)[cell.contentView viewWithTag:2];
    
    
    if ([[MineManager sharedInstance] getMyInfo]) {
        name.text = [[MineManager sharedInstance] getMyInfo].nickName;
        [face sd_setImageWithURL:[NSURL URLWithString:[[MineManager sharedInstance] getMyInfo].headImg] placeholderImage:[UIImage imageNamed:@"user_headimg_default.png"]];
    } else {
        name.text = NSLocalizedString(@"no login", nil);
        [face setImage:[UIImage imageNamed:@"user_headimg_default.png"]];
    }
    _pointLbl.text = self.userTotalCoin;
    [_pointLbl sizeToFit];
    _pointBg.width = _pLbl.width + _pointLbl.width + 13*3;
    _pointBg.centerX = K_UIScreenWidth/2;
    _pLbl.x = _pointBg.x + 13;
    _pLbl.centerY = _pointBg.centerY;
    _pointLbl.x = _pLbl.maxX + 13;
    _pointLbl.centerY = _pointBg.centerY;
    
    return cell;
}

- (int)indexByIndexPath:(NSIndexPath*)path {
    
    if (path.section == 0) {
        
        if (path.row == 1) {
            return 0;
        } else if (path.row == 2) {
            return 1;
        } else {
            return 2;
        }
    } else {
        if (path.row == 0) {
            
            return 3;
        } else if (path.row == 1) {
            return 4;
        } else {
            return 5;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView otherCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UIView *line;
    UIImageView *img;
    UILabel *title;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(15, 50-0.5, tableView.width-15, 0.5)];
        line.backgroundColor = UIColor_line_d2d2d2;
        line.tag = 1;
        [cell.contentView addSubview:line];
        
        img = [[UIImageView alloc] init];
        img.tag = 2;
        [cell.contentView addSubview:img];
        
        title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:15];
        title.textColor = UIColor_9f9f9f;
        title.tag = 3;
        [cell.contentView addSubview:title];
    }
    
    line = [cell.contentView viewWithTag:1];
    if ((indexPath.section == 0 && indexPath.row == 1) ||
        (indexPath.section == 0 && indexPath.row == 2) ||
        (indexPath.section == 1 && indexPath.row == 0) ||
        (indexPath.section == 1 && indexPath.row == 1) ) {
        line.hidden = NO;
    } else {
        line.hidden = YES;
    }
    
    img = (UIImageView*)[cell.contentView viewWithTag:2];
    UIImage *i = [UIImage imageNamed:[self.imgArray objectAtIndex:[self indexByIndexPath:indexPath]]];
    img.size = i.size;
    img.image = i;
    img.center = CGPointMake(23, 50/2);
    
    title = (UILabel*)[cell.contentView viewWithTag:3];
    title.text = [self.titleArray objectAtIndex:[self indexByIndexPath:indexPath]];
    [title sizeToFit];
    title.centerY = img.centerY;
    title.x = 44;
    
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [self tableView:tableView topCellForRowAtIndexPath:indexPath];
    } else {
        cell = [self tableView:tableView otherCellForRowAtIndexPath:indexPath];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (![[MineManager sharedInstance] getMyInfo] && !(indexPath.section == 1 && indexPath.row == 2)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadUserLogin object:nil];
        return;
    }
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            MinePersonInfoViewController *vc = [[MinePersonInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 1) {
          
            MinePersonInfoViewController *vc = [[MinePersonInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            //todo
//            MyPointViewController *vc = [[MyPointViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 2) {
            
            MyVideoViewController *vc = [[MyVideoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            MyFavourViewController *vc = [[MyFavourViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        
        if (indexPath.row == 0) {
            MyAttentionViewController *vc = [[MyAttentionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            NSString *state = [[MineManager sharedInstance] getMyInfo].realNameVerifyState;
            if (state && [state isEqualToString:@"1"]) { //已实名认证
                
                ApplyAnchorViewController *vc = [[ApplyAnchorViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            } else if (state && [state isEqualToString:@"4"]) {
                
                [self presentViewController:[Utility createNoticeAlertWithContent:NSLocalizedString(@"we are verifying your apply please wait", nil) okBtnTitle:nil] animated:YES completion:nil];
                
            } else {
                
                NSString *msg;
                if ([state isEqualToString:@"3"]) {
                    //NSLocalizedString
                    msg = NSLocalizedString(@"identity verify failed submit again", nil);
                } else {
                    //NSLocalizedString
                    msg = NSLocalizedString(@"please finish identity verify then apply anchor", nil);
                }
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:
                                            msg preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"alert cancel", nil) style:UIAlertActionStyleDefault handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"go to verify", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    RealNameCertifyViewController *vc = [[RealNameCertifyViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } else {
            
            SettingViewController *vc = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
