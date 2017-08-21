//
//  SetTelCodeViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "SetTelCodeViewController.h"

@interface SetTelCodeViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableDictionary *countries;
@property (nonatomic,strong) NSMutableArray *keys; //首字母
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation SetTelCodeViewController

-(void)getCountryData
{
    if (!_keys) {
        self.keys = [[NSMutableArray alloc] init];
    }
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"globaltelcode"
                                                   ofType:@"plist"];
    self.countries = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.countries allKeys] sortedArrayUsingSelector:@selector(compare:)]];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:@"选择区号" color:UIColor_navititle];//NSLocalizedString
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
    
    [self getCountryData];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight-naviBar.maxY) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *key = [_keys objectAtIndex:section];
    titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_countries objectForKey:key];
    return [citySection count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *country;
    UILabel *code;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        country = [[UILabel alloc] init];
        country.font = [UIFont systemFontOfSize:18];
        country.textColor = [UIColor darkGrayColor];
        country.tag = 1;
        [cell.contentView addSubview:country];
        
        code = [[UILabel alloc] init];
        code.font = [UIFont systemFontOfSize:18];
        code.textColor = [UIColor darkGrayColor];
        code.tag = 2;
        [cell.contentView addSubview:code];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40-0.5, tableView.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
    }
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    NSArray *array = [[_countries objectForKey:key] objectAtIndex:indexPath.row];
    
    country = (UILabel*)[cell.contentView viewWithTag:1];
    country.text = [array objectAtIndex:0];
    [country sizeToFit];
    country.x = 15;
    country.centerY = 40/2;
    
    code = (UILabel*)[cell.contentView viewWithTag:2];
    code.text = [array objectAtIndex:1];
    [code sizeToFit];
    code.x = tableView.width - 15 - code.width;
    code.centerY = 40/2;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate && [_delegate respondsToSelector:@selector(SetTelCodeViewControllerTelCode:)]) {
        
        NSArray *array = [[_countries objectForKey:[_keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [_delegate SetTelCodeViewControllerTelCode:[array objectAtIndex:1]];
    }
    
    [self back];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
