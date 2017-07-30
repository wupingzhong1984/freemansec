//
//  ResetMobilePwdViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "ResetMobilePwdViewController.h"
#import "ResetMobilePwd2ViewController.h"
#import "SetTelCodeViewController.h"

@interface ResetMobilePwdViewController ()
<UIScrollViewDelegate,
SetTelCodeViewControllerDelegate>

@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,strong) UILabel *telCodeLbl;
@property (nonatomic,strong) UITextField *mobileTF;
@property (nonatomic,strong) UIButton *verifyBtn;
@property (nonatomic,strong) UITextField *verifyCodeTF;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int second;

@end

@implementation ResetMobilePwdViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = [UIColor blackColor];
    
    UIView *title = [self commNaviTitle:@"忘记密码" color:[UIColor whiteColor]];//NSLocalizedString
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

- (void)telCodeAction {
    
    SetTelCodeViewController *vc = [[SetTelCodeViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)verifyCodeAction {
    
    if (!_mobileTF.text.length) {
        
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入手机号。" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        _second = 60;
        _verifyBtn.enabled = NO;
        [_verifyBtn setTitle:[NSString stringWithFormat:@"%dS",_second] forState:UIControlStateDisabled];
        self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            _second--;
            NNSLog(@"%d",_second);
            if (_second > 0) {
                
                [_verifyBtn setTitle:[NSString stringWithFormat:@"%dS",_second] forState:UIControlStateDisabled];
            } else {
                
                self.timer = nil;
                _verifyBtn.enabled = YES;
                [_verifyBtn setTitle:@"验证码" forState:UIControlStateNormal];
            }
            
        }];
        
        //todo
        //request verify code
    }

}

- (void)submit {
    
    [_mobileTF resignFirstResponder];
    [_verifyCodeTF resignFirstResponder];
    
    NSMutableString *error = [NSMutableString string];
    
    //NSLocalizedString
    if (!_mobileTF.text.length) {
        
        [error appendString:@"请输入手机号。"];
    }
    
    if (!_verifyCodeTF.text.length) {
        
        [error appendString:@"请输入验证码。"];
    }
    
    if (!error.length) {
        
        //todo
        //sumbit mobile
        ResetMobilePwd2ViewController *vc = [[ResetMobilePwd2ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)loadSubViews {
    
    //code
    UIView *codeBg = [[UIView alloc] initWithFrame:CGRectMake(15, 60, 73, 44)];
    codeBg.backgroundColor = [UIColor whiteColor];
    codeBg.layer.cornerRadius = 4;
    codeBg.layer.borderWidth = 1;
    codeBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:codeBg];
    
    self.telCodeLbl = [[UILabel alloc] initWithFrame:CGRectMake(codeBg.x, codeBg.y, 47, codeBg.height)];
    _telCodeLbl.numberOfLines = 1;
    _telCodeLbl.textAlignment = NSTextAlignmentRight;
    _telCodeLbl.textColor = [UIColor darkGrayColor];
    _telCodeLbl.font = [UIFont systemFontOfSize:16];
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    _telCodeLbl.text = ([languageName isEqualToString:@"zh-Hans"]?@"+86":@"+852");
    [_contentView addSubview:_telCodeLbl];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]; //todo
    icon.centerX = (codeBg.maxX - _telCodeLbl.maxX)/2 + _telCodeLbl.maxX;
    icon.centerY = codeBg.centerY;
    [_contentView addSubview:icon];
    
    UIButton *telCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [telCodeBtn addTarget:self action:@selector(telCodeAction) forControlEvents:UIControlEventTouchUpInside];
    telCodeBtn.frame = codeBg.frame;
    [_contentView addSubview:telCodeBtn];
    
    UIView *mobileBg = [[UIView alloc] initWithFrame:CGRectMake(codeBg.maxX + 10, codeBg.y, _contentView.width - 15 - (codeBg.maxX + 10), codeBg.height)];
    mobileBg.backgroundColor = [UIColor whiteColor];
    mobileBg.layer.cornerRadius = 4;
    mobileBg.layer.borderWidth = 1;
    mobileBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:mobileBg];
    
    self.verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.backgroundColor = [UIColor blueColor]; //todo
    _verifyBtn.layer.cornerRadius = 4;
    _verifyBtn.size = (CGSize){60,32};
    _verifyBtn.centerY = mobileBg.centerY;
    _verifyBtn.x = mobileBg.maxX - 5 - _verifyBtn.width;
    [_verifyBtn setTitle:@"验证码" forState:UIControlStateNormal]; //NSLocalizedString
    [_verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_verifyBtn addTarget:self action:@selector(verifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_verifyBtn];
    
    self.mobileTF = [[UITextField alloc] init];
    _mobileTF.frame = CGRectMake(mobileBg.x + 10, (mobileBg.height-20)/2 + mobileBg.y, _verifyBtn.x - 10 - (mobileBg.x + 10), 20);
    _mobileTF.font = [UIFont systemFontOfSize:16];
    _mobileTF.textColor = [UIColor darkGrayColor];
    _mobileTF.placeholder = @"请输入手机号";//NSLocalizedString
    _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    [_contentView addSubview:_mobileTF];
    
    UIView *verifyCodeBg = [[UIView alloc] initWithFrame:CGRectMake(codeBg.x, codeBg.maxY + 10, _contentView.width - codeBg.x*2, codeBg.height)];
    verifyCodeBg.backgroundColor = [UIColor whiteColor];
    verifyCodeBg.layer.cornerRadius = 4;
    verifyCodeBg.layer.borderWidth = 1;
    verifyCodeBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:verifyCodeBg];
    
    self.verifyCodeTF = [[UITextField alloc] init];
    _verifyCodeTF.frame = CGRectMake(verifyCodeBg.x + 10, (verifyCodeBg.height-20)/2 + verifyCodeBg.y, verifyCodeBg.width-20, 20);
    _verifyCodeTF.font = [UIFont systemFontOfSize:16];
    _verifyCodeTF.textColor = [UIColor darkGrayColor];
    _verifyCodeTF.placeholder = @"请输入验证码";//NSLocalizedString
    _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    [_contentView addSubview:_verifyCodeTF];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor]; //todo
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight-naviBar.maxY)];
    _contentView.delegate = self;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.size = (CGSize){_contentView.width,_contentView.height+1};
    [self.view addSubview:_contentView];
    
    [self loadSubViews];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_mobileTF resignFirstResponder];
    [_verifyCodeTF resignFirstResponder];
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
