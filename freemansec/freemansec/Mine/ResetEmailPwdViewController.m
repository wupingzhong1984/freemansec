//
//  ResetEmailPwdViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "ResetEmailPwdViewController.h"
#import "ResetEmailPwd2ViewController.h"

@interface ResetEmailPwdViewController ()
<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,strong) UITextField *emailTF;

@end

@implementation ResetEmailPwdViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = [UIColor blackColor];
    
    UIView *title = [self commNaviTitle:(_resetPwdKind == RPKResetPwd?@"重设密码":@"忘记密码") color:[UIColor whiteColor]];//NSLocalizedString
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

- (void)submit {
    
    [_emailTF resignFirstResponder];
    
    if ([Utility validateEmail:_emailTF.text]) {
        
        [[MineManager sharedInstance] getEmailVerifyCode:_emailTF.text completion:^(NSString * _Nullable verify, NSError * _Nullable error) {
            
            if(error) {
                
                //NSLocalizedString
                [self presentViewController:[Utility createAlertWithTitle:@"错误" content:@"获取验证码失败。" okBtnTitle:nil] animated:YES completion:nil];
            } else {
                
                ResetEmailPwd2ViewController *vc = [[ResetEmailPwd2ViewController alloc] init];
                vc.email = _emailTF.text;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }];
        
        
    } else {
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请正确输入邮箱。" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
    
    UIView *emailBg = [[UIView alloc] initWithFrame:CGRectMake(15, 60, K_UIScreenWidth-30, 44)];
    emailBg.backgroundColor = [UIColor whiteColor];
    emailBg.layer.cornerRadius = 4;
    emailBg.layer.borderWidth = 1;
    emailBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:emailBg];
    
    self.emailTF = [[UITextField alloc] init];
    _emailTF.frame = CGRectMake(emailBg.x + 10, (emailBg.height-20)/2 + emailBg.y, emailBg.width-20, 20);
    _emailTF.font = [UIFont systemFontOfSize:16];
    _emailTF.textColor = [UIColor darkGrayColor];
    _emailTF.placeholder = @"请输入邮箱";//NSLocalizedString
    [_contentView addSubview:_emailTF];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(emailBg.x, emailBg.maxY + 27, emailBg.width, 40);
    btn.backgroundColor = UIColor_0a6ed2;
    btn.layer.cornerRadius = 4;
    [btn setTitle:@"提交" forState:UIControlStateNormal];//NSLocalizedString
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:btn];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_emailTF resignFirstResponder];
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
