//
//  UpdateEmail2ViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/9.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UpdateEmail2ViewController.h"

@interface UpdateEmail2ViewController ()
@property (nonatomic,strong) UITextField *verifyTF;
@end

@implementation UpdateEmail2ViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = [UIColor blackColor];
    
    UIView *title = [self commNaviTitle:@"绑定邮箱" color:[UIColor whiteColor]];//NSLocalizedString
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
    
    return v;
}

-(void)submit {
    
    [_verifyTF resignFirstResponder];
    
    if (![Utility validateEmail:_verifyTF.text]) {
        
        //NSLocalizedString
        [self presentViewController:[Utility createNoticeAlertWithContent:@"请输入验证码。" okBtnTitle:nil] animated:YES completion:nil];
        
    } else {
        
        [[MineManager sharedInstance] updateEmail:_email verify:_verifyTF.text completion:^(NSError * _Nullable error) {
            
            if (error) {
                [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            } else {
                MyInfoModel *info = [[MineManager sharedInstance] getMyInfo];
                info.email = _email;
                [[MineManager sharedInstance] updateMyInfo:info];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)setupSubviews {
    
    UIView *verifyBg = [[UIView alloc] initWithFrame:CGRectMake(15, 60, K_UIScreenWidth - 15*2, 44)];
    verifyBg.backgroundColor = [UIColor whiteColor];
    verifyBg.layer.cornerRadius = 4;
    verifyBg.layer.borderWidth = 1;
    verifyBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:verifyBg];
    
    self.verifyTF = [[UITextField alloc] init];
    _verifyTF.frame = CGRectMake(verifyBg.x + 10, (verifyBg.height-20)/2 + verifyBg.y, verifyBg.width-20, 20);
    _verifyTF.font = [UIFont systemFontOfSize:16];
    _verifyTF.textColor = [UIColor darkGrayColor];
    _verifyTF.placeholder = @"请输入验证码";//NSLocalizedString
    _verifyTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_verifyTF];
    
    UIButton *sumbit = [UIButton buttonWithType:UIButtonTypeCustom];
    sumbit.frame = CGRectMake(verifyBg.x, verifyBg.maxY + 25, verifyBg.width, 40);
    sumbit.backgroundColor = UIColor_82b432;
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
