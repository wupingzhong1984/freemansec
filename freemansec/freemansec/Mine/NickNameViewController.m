//
//  NickNameViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/29.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "NickNameViewController.h"

@interface NickNameViewController ()
<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,strong) UITextField *nickNameTF;

@end

@implementation NickNameViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:@"昵称" color:UIColor_navititle];//NSLocalizedString
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

- (void)submit {
    
    [_nickNameTF resignFirstResponder];
    
    if (!_nickNameTF.text.length) {
        //NSLocalizedString
        [self presentViewController:[Utility createNoticeAlertWithContent:@"请输入昵称。" okBtnTitle:nil] animated:YES completion:nil];
    } else {
        
        [[MineManager sharedInstance] updateNickName:_nickNameTF.text completion:^(MyInfoModel * _Nullable myInfo, NSError * _Nullable error) {
            if (error) {
                [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            } else {
                
                [[MineManager sharedInstance] updateMyInfo:myInfo];
                [self back];
            }
        }];
    }
}

- (void)setupSubviews {
    
    UIView *nameBg = [[UIView alloc] initWithFrame:CGRectMake(15, 60, K_UIScreenWidth-30, 44)];
    nameBg.backgroundColor = [UIColor whiteColor];
    nameBg.layer.cornerRadius = 4;
    nameBg.layer.borderWidth = 1;
    nameBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:nameBg];
    
    self.nickNameTF = [[UITextField alloc] init];
    _nickNameTF.frame = CGRectMake(nameBg.x + 10, (nameBg.height-20)/2 + nameBg.y, nameBg.width-20, 20);
    _nickNameTF.font = [UIFont systemFontOfSize:16];
    _nickNameTF.textColor = [UIColor darkGrayColor];
    _nickNameTF.text = [[MineManager sharedInstance] getMyInfo].nickName;
    _nickNameTF.placeholder = @"请输入昵称";//NSLocalizedString
    [_contentView addSubview:_nickNameTF];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(nameBg.x, nameBg.maxY + 27, nameBg.width, 40);
    btn.backgroundColor = UIColor_82b432;
    btn.layer.cornerRadius = 4;
    [btn setTitle:@"提交" forState:UIControlStateNormal];//NSLocalizedString
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:btn];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight - naviBar.maxY)];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    [self setupSubviews];
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
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_nickNameTF resignFirstResponder];
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
