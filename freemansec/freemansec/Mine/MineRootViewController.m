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

@interface MineRootViewController ()
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *imgArray;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *pointBg;
@property (nonatomic,strong) UILabel *pLbl;
@property (nonatomic,strong) UILabel *pointLbl;
@end

@implementation MineRootViewController

- (NSMutableArray*)imgArray {
    
    if (!_imgArray) {
        //todo
        _imgArray = [NSMutableArray arrayWithObjects:@"tab_img_3.png",@"tab_img_3.png",@"tab_img_3.png",@"tab_img_3.png",@"tab_img_3.png",@"tab_img_3.png", nil];
    }
    return _imgArray;
}

- (NSMutableArray*)titleArray {
    
    if (!_titleArray) {
        //todo
        _titleArray = [NSMutableArray arrayWithObjects:@"我的账户",@"我的视频",@"视频收藏",@"我的关注",@"主播申请",@"设置", nil];
    }
    return _titleArray;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, 20)];
    v.backgroundColor = [UIColor blackColor];
    
    return v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight-naviBar.maxY-self.tabBarController.tabBar.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //todo
    //get point
    _pointLbl.text = @"0";
    [_pointLbl sizeToFit];
    _pointBg.width = _pLbl.width + _pointLbl.width + 13*3;
    _pointBg.centerX = _tableView.width/2;
    _pLbl.x = _pointBg.x + 13;
    _pLbl.centerY = _pointBg.centerY;
    _pointLbl.x = _pLbl.maxX + 13;
    _pointLbl.centerY = _pointBg.centerY;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
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
    
    if (section == 0) {
        return 0.1f;
    } else {
        return 10.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0)];
    v.backgroundColor = UIColor_vc_bgcolor_lightgray;
    if (section == 0) {
        v.height = 0.1f;
    } else {
        v.height = 10.0f;
    }
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        return 150;
    }
    
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView topCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *container = [[UIView alloc] init];
        container.size = CGSizeMake(tableView.width, 150);
        container.clipsToBounds = YES;
        [cell.contentView addSubview:container];
        
        UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]; //todo
        bgImg.center = container.center;
        [container addSubview:bgImg];
        
        UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
        visualEffectView.size = bgImg.size;
        visualEffectView.alpha = 0.5;
        [container addSubview:visualEffectView];
        
        UIVisualEffectView *visualEffectView2 = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
        visualEffectView2.size = CGSizeMake(68, 68);
        visualEffectView2.layer.cornerRadius = 34;
        visualEffectView2.alpha = 0.5;
        visualEffectView2.center = CGPointMake(container.width/2, 58);
        [container addSubview:visualEffectView2];
        
        UIImageView *face = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];//todo
        face.size = CGSizeMake(62, 62);
        face.layer.cornerRadius = 31;
        face.center = visualEffectView2.center;
        [container addSubview:face];
        
        //todo
        UILabel *name = [UILabel createLabelWithFrame:CGRectZero text:@"" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
        [name sizeToFit];
        name.centerX = face.centerX;
        name.centerY = 110;
        [container addSubview:name];
        
        self.pointBg = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
        _pointBg.y = 122;
        _pointBg.height = 21;
        _pointBg.layer.cornerRadius = 34;
        _pointBg.alpha = 0.5;
        [container addSubview:_pointBg];
        
        self.pLbl = [UILabel createLabelWithFrame:CGRectZero text:@"金币数" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
        [_pLbl sizeToFit];
        [container addSubview:_pLbl];
        
        self.pointLbl = [UILabel createLabelWithFrame:CGRectZero text:@"0" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
        [_pointLbl sizeToFit];
        [container addSubview:_pointLbl];
        
        
        _pointBg.width = _pLbl.width + _pointLbl.width + 13*3;
        _pointBg.centerX = container.width/2;
        _pLbl.x = _pointBg.x + 13;
        _pLbl.centerY = _pointBg.centerY;
        _pointLbl.x = _pLbl.maxX + 13;
        _pointLbl.centerY = _pointBg.centerY;
        
    }

    
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
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor lightGrayColor];
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
    
    if (indexPath.row == 1) {
        
        MinePersonInfoViewController *vc = [[MinePersonInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //todo
    
    if (indexPath.row == 5) {
        
        if (YES) { //实名认证
            
        } else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先在我的账户中完成实名认证。" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
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
