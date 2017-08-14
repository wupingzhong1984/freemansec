//
//  UpdateEmailViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/8.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UpdateEmailViewController.h"
#import "UpdateEmail2ViewController.h"

@interface UpdateEmailViewController ()
@property (nonatomic,strong) UITextField *emailTF;
@end

@implementation UpdateEmailViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = [UIColor blackColor];
    
    UIView *title = [self commNaviTitle:@"绑定邮箱" color:[UIColor whiteColor]];//NSLocalizedString
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

-(void)submit {
    
    [_emailTF resignFirstResponder];
    
    if (![Utility validateEmail:_emailTF.text]) {
        
        //NSLocalizedString
        [self presentViewController:[Utility createNoticeAlertWithContent:@"请正确输入邮箱。" okBtnTitle:nil] animated:YES completion:nil];        
    } else {
        
        [[MineManager sharedInstance] getEmailVerifyCode:_emailTF.text completion:^(NSString * _Nullable verify, NSError * _Nullable error) {
            
            if(error) {
                [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            } else {
                
                UpdateEmail2ViewController *vc = [[UpdateEmail2ViewController alloc] init];
                vc.email = _emailTF.text;
                [self.navigationController pushViewController:vc animated:nil];
            }
        }];
    }
}

- (void)setupSubviews {
    
    UIView *emailBg = [[UIView alloc] initWithFrame:CGRectMake(15, 64+60, K_UIScreenWidth - 15*2, 44)];
    emailBg.backgroundColor = [UIColor whiteColor];
    emailBg.layer.cornerRadius = 4;
    emailBg.layer.borderWidth = 1;
    emailBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:emailBg];
    
    self.emailTF = [[UITextField alloc] init];
    _emailTF.frame = CGRectMake(emailBg.x + 10, (emailBg.height-20)/2 + emailBg.y, emailBg.width-20, 20);
    _emailTF.font = [UIFont systemFontOfSize:16];
    _emailTF.textColor = [UIColor darkGrayColor];
    _emailTF.placeholder = @"请输入邮箱";//NSLocalizedString
    _emailTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_emailTF];
    
    UIButton *sumbit = [UIButton buttonWithType:UIButtonTypeCustom];
    sumbit.frame = CGRectMake(emailBg.x, emailBg.maxY + 25, emailBg.width, 40);
    sumbit.backgroundColor = UIColor_0a6ed2;
    sumbit.layer.cornerRadius = 4;
    [sumbit setTitle:@"提交" forState:UIControlStateNormal];//NSLocalizedString
    [sumbit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];    sumbit.titleLabel.font = [UIFont systemFontOfSize:16];
    [sumbit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sumbit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
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
