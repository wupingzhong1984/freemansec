//
//  ApplyAnchorViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "ApplyAnchorViewController.h"
#import "UserLiveType.h"

@interface ApplyAnchorViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITextField *titleTF;
@property (nonatomic,strong) UILabel *typePlace;
@property (nonatomic,strong) UILabel *typeLbl;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) NSMutableArray *typeArray;
@end

@implementation ApplyAnchorViewController

- (NSMutableArray*)typeArray {
    
    if (!_typeArray) {
        _typeArray = [[NSMutableArray alloc] init];
    }
    return _typeArray;
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:@"申请主播" color:UIColor_navititle];//NSLocalizedString
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

-(void)submit {
    
    [_titleTF resignFirstResponder];
    _tableView.hidden = YES;
    
    NSMutableString *error = [NSMutableString string];
    
    if (!_titleTF.text.length) {
        
        [error appendString:@"请输入标题。"];
    }
    
    if (!_typeLbl.text.length) {
        
        [error appendString:@"请设置分类。"];
    }
    
    if (!error.length) {
        
        NSString *tId;
        if (_selectIndex < 0) { //没改
            tId = [[MineManager sharedInstance] getMyInfo].liveTypeId;
        } else {
            
            UserLiveType *type = [self.typeArray objectAtIndex:_selectIndex];
            tId = type.liveTypeId;
        }
        
        if([[MineManager sharedInstance] getMyInfo].liveId.length > 0) {
            
            [[MineManager sharedInstance] updateMyLiveTitle:_titleTF.text liveTypeId:tId completion:^(NSError * _Nullable error)  {
                
                if (error) {
                    [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
                } else {
                    
                    MyInfoModel *myInfo = [[MineManager sharedInstance] getMyInfo];
                    myInfo.liveTitle = _titleTF.text;
                    myInfo.liveTypeId = tId;
                    for (UserLiveType *type in _typeArray) {
                        if ([type.liveTypeId isEqualToString:tId]) {
                            
                            myInfo.liveTypeName = type.liveTypeName;
                            break;
                        }
                    }
                    [[MineManager sharedInstance] updateMyInfo:myInfo];
                    
                    [self back];
                }
            }];
            
        } else {
            [[MineManager sharedInstance] createMyLiveWithLiveTitle:_titleTF.text liveType:tId completion:^(MyInfoModel * _Nullable myInfo, NSError * _Nullable error)  {
                
                if (error) {
                    [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
                } else {
                    
                    [[MineManager sharedInstance] updateMyInfo:myInfo];
                    [self back];
                }
            }];
        }

    } else {
        
        [self presentViewController:[Utility createNoticeAlertWithContent:error okBtnTitle:nil] animated:YES completion:nil];
    }
}

- (void)userTypeAction {
    
    _tableView.hidden = !_tableView.hidden;
}

- (void)setupSubViews {
    
    UIView *titleBg = [[UIView alloc] initWithFrame:CGRectMake(15, 64+56, K_UIScreenWidth - 30, 44)];
    titleBg.backgroundColor = [UIColor whiteColor];
    titleBg.layer.cornerRadius = 4;
    titleBg.layer.borderWidth = 1;
    titleBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:titleBg];
    
    self.titleTF = [[UITextField alloc] init];
    _titleTF.frame = CGRectMake(titleBg.x + 10, (titleBg.height-20)/2 + titleBg.y, titleBg.width-20, 20);
    _titleTF.font = [UIFont systemFontOfSize:16];
    _titleTF.textColor = [UIColor darkGrayColor];
    _titleTF.placeholder = @"请输入标题";//NSLocalizedString
    [self.view addSubview:_titleTF];
    
    UIView *typeBg = [[UIView alloc] initWithFrame:CGRectMake(titleBg.x, titleBg.maxY + 10, titleBg.width, titleBg.height)];
    typeBg.backgroundColor = [UIColor whiteColor];
    typeBg.layer.cornerRadius = 4;
    typeBg.layer.borderWidth = 1;
    typeBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:typeBg];
    
    self.typePlace = [UILabel createLabelWithFrame:CGRectMake(typeBg.x + 10, typeBg.y, typeBg.width-20, typeBg.height) text:@"分类" textColor:UIColor_textfield_placecolor font:[UIFont systemFontOfSize:16]];
    [self.view addSubview:_typePlace];
    
    self.typeLbl = [UILabel createLabelWithFrame:CGRectMake(_typePlace.x, _typePlace.y + (_typePlace.height-20)/2, _typePlace.width, 20) text:@"" textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:16]];
    [self.view addSubview:_typeLbl];
    
    UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn.frame = typeBg.frame;
    [typeBtn addTarget:self action:@selector(userTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:typeBtn];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(typeBg.x, typeBg.maxY + 50, typeBg.width, 40);
    submit.backgroundColor = UIColor_82b432;
    submit.layer.cornerRadius = 4;
    [submit setTitle:@"提交" forState:UIControlStateNormal];//NSLocalizedString
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:16];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];

    
    if ([[MineManager sharedInstance] getMyInfo].liveTitle.length > 0) {
        
        _titleTF.text = [[MineManager sharedInstance] getMyInfo].liveTitle;
        _typePlace.hidden = YES;
        _typeLbl.text = [[MineManager sharedInstance] getMyInfo].liveTypeName;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    _selectIndex = -1;
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    [self setupSubViews];
    
    [[MineManager sharedInstance] getUserLiveTypeCompletion:^(NSArray * _Nullable typeList, NSError * _Nullable error) {
        
        if (!error && typeList.count > 0) {
            [self.typeArray addObjectsFromArray:typeList];
            for(UserLiveType *type in _typeArray) {
                
                if ([type.liveTypeName isEqualToString:@"民众财经频道"]) {
                    
                    [_typeArray removeObject:type];
                    break;
                }
            }
        }
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(_typePlace.x-10, _typePlace.maxY, _typePlace.width+20, 150) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.layer.borderWidth = 1;
        _tableView.layer.borderColor = UIColor_line_d2d2d2.CGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.typeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *typeLbl;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        typeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.width-20, 20)];
        typeLbl.font = [UIFont systemFontOfSize:16];
        typeLbl.textColor = [UIColor darkGrayColor];
        typeLbl.tag = 1;
        [cell.contentView addSubview:typeLbl];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40-0.5, tableView.width, 0.5)];
        line.backgroundColor = UIColor_line_d2d2d2;
        [cell.contentView addSubview:line];
    }
    UserLiveType *type = [self.typeArray objectAtIndex:indexPath.row];
    
    typeLbl = (UILabel*)[cell.contentView viewWithTag:1];
    typeLbl.text = type.liveTypeName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _tableView.height = YES;
    _selectIndex = indexPath.row;
    UserLiveType *type = [self.typeArray objectAtIndex:indexPath.row];
    _typeLbl.text = type.liveTypeName;
    _typePlace.hidden = YES;
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
