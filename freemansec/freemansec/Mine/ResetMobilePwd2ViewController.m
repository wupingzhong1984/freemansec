//
//  ResetMobilePwd2ViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/23.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "ResetMobilePwd2ViewController.h"

@interface ResetMobilePwd2ViewController ()
<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,strong) UITextField *nPwdTF;
@property (nonatomic,strong) UITextField *nPwdTF2;
@end

@implementation ResetMobilePwd2ViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:(_resetPwdKind == RPKResetPwd?@"重设密码":@"找回密码") color:UIColor_navititle];//NSLocalizedString
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
    
    [_nPwdTF resignFirstResponder];
    [_nPwdTF2 resignFirstResponder];
    
    //NSLocalizedString
    NSMutableString *error = [NSMutableString string];
    
    if (_nPwdTF.text.length < 6 || _nPwdTF.text.length > 16) {
        
        [error appendString:@"请正确输入密码。"];
    }
    
    if (![_nPwdTF2.text isEqualToString:_nPwdTF.text]) {
        
        [error appendString:@"请正确重复输入密码。"];
    }
    
    if (!error.length) {
        
        [[MineManager sharedInstance] resetPwd:_nPwdTF.text phone:_phone email:nil completion:^(NSError * _Nullable error) {
        
            if (error) {
                [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            } else {
                
                if (_resetPwdKind == RPKResetPwd) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            }
        }];
        
    } else {
        
        [self presentViewController:[Utility createNoticeAlertWithContent:error okBtnTitle:nil] animated:YES completion:nil];
    }
}

- (void)setupSubviews {
    
    UIView *pwdBg = [[UIView alloc] initWithFrame:CGRectMake(15, 60, _contentView.width-30, 44)];
    pwdBg.backgroundColor = [UIColor whiteColor];
    pwdBg.layer.cornerRadius = 4;
    pwdBg.layer.borderWidth = 1;
    pwdBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:pwdBg];
    
    self.nPwdTF = [[UITextField alloc] init];
    _nPwdTF.frame = CGRectMake(pwdBg.x + 10, (pwdBg.height-20)/2 + pwdBg.y, pwdBg.width-20, 20);
    _nPwdTF.font = [UIFont systemFontOfSize:16];
    _nPwdTF.textColor = [UIColor darkGrayColor];
    _nPwdTF.placeholder = @"请输入6-16位新密码";//NSLocalizedString
    _nPwdTF.keyboardType = UIKeyboardTypeNumberPad;
    [_contentView addSubview:_nPwdTF];
    
    UIView *pwdBg2 = [[UIView alloc] initWithFrame:CGRectMake(pwdBg.x, pwdBg.maxY + 15, pwdBg.width, pwdBg.height)];
    pwdBg2.backgroundColor = [UIColor whiteColor];
    pwdBg2.layer.cornerRadius = 4;
    pwdBg2.layer.borderWidth = 1;
    pwdBg2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:pwdBg2];
    
    self.nPwdTF2 = [[UITextField alloc] init];
    _nPwdTF2.frame = CGRectMake(pwdBg2.x + 10, (pwdBg.height-20)/2 + pwdBg2.y, pwdBg.width-20, 20);
    _nPwdTF2.font = [UIFont systemFontOfSize:16];
    _nPwdTF2.textColor = [UIColor darkGrayColor];
    _nPwdTF2.placeholder = @"再输入一次密码";//NSLocalizedString
    _nPwdTF2.keyboardType = UIKeyboardTypeNumberPad;
    [_contentView addSubview:_nPwdTF2];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = pwdBg2.size;
    btn.x = pwdBg2.x;
    btn.y = pwdBg2.maxY + 27;
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
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight-naviBar.maxY)];
    _contentView.delegate = self;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.size = (CGSize){_contentView.width,_contentView.height+1};
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
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_nPwdTF resignFirstResponder];
    [_nPwdTF2 resignFirstResponder];
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
