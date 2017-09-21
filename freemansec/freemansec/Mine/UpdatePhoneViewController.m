//
//  UpdatePhoneViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/8.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UpdatePhoneViewController.h"
#import "SetTelCodeViewController.h"

@interface UpdatePhoneViewController ()
<SetTelCodeViewControllerDelegate>
@property (nonatomic,strong) UILabel *telCodeLbl;
@property (nonatomic,strong) UITextField *mobileTF;
@property (nonatomic,strong) UIButton *verifyBtn;
@property (nonatomic,strong) UITextField *verifyCodeTF;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int second;
@end

@implementation UpdatePhoneViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:NSLocalizedString(@"bind phonel", nil) color:UIColor_navititle];//NSLocalizedString
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

-(void)mobileTelCodeBtnAction {
    
    SetTelCodeViewController *vc = [[SetTelCodeViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)mobileVerifyBtnAction {
    
    if (!_mobileTF.text.length) {
        
        //NSLocalizedString
        [self presentViewController:[Utility createNoticeAlertWithContent:NSLocalizedString(@"please input phone num", nil) okBtnTitle:nil] animated:YES completion:nil];
        
    } else {
        
        _second = 60;
        _verifyBtn.enabled = NO;
        [_verifyBtn setTitle:[NSString stringWithFormat:@"%dS",_second] forState:UIControlStateDisabled];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            _second--;
            NNSLog(@"%d",_second);
            if (_second > 0) {
                
                [_verifyBtn setTitle:[NSString stringWithFormat:@"%dS",_second] forState:UIControlStateDisabled];
            } else {
                
                [self.timer invalidate];
                self.timer = nil;
                _verifyBtn.enabled = YES;
                [_verifyBtn setTitle:NSLocalizedString(@"verify code", nil) forState:UIControlStateNormal];
            }
            
        }];
        
        [[MineManager sharedInstance] getPhoneVerifyCode:_telCodeLbl.text phone:_mobileTF.text completion:^(NSString * _Nullable verify, NSError * _Nullable error) {
            
            if(error) {
                [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            }
        }];
    }
}

- (void)submit {
    
    [_mobileTF resignFirstResponder];
    [_verifyCodeTF resignFirstResponder];
    
    //NSLocalizedString
    NSMutableString *error = [NSMutableString string];
    
    if (!_mobileTF.text.length) {
        
        [error appendString:NSLocalizedString(@"please input phone num point", nil)];
    }
    
    if (!_verifyCodeTF.text.length) {
        
        [error appendString:NSLocalizedString(@"please input verify code point", nil)];
    }
    
    if (!error.length) {
        
        [[MineManager sharedInstance] updatePhone:_mobileTF.text areaCode:_telCodeLbl.text verify:_verifyCodeTF.text completion:^(NSError * _Nullable error) {
            
            if (error) {
                [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            } else {
                MyInfoModel *info = [[MineManager sharedInstance] getMyInfo];
                info.phone = _mobileTF.text;
                [[MineManager sharedInstance] updateMyInfo:info];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
    } else {
        
        [self presentViewController:[Utility createNoticeAlertWithContent:error okBtnTitle:nil] animated:YES completion:nil];
    }
}

- (void)setupSubviews {
    
    //code
    UIView *codeBg = [[UIView alloc] initWithFrame:CGRectMake(15, 64+60, 73, 44)];
    codeBg.backgroundColor = [UIColor whiteColor];
    codeBg.layer.cornerRadius = 4;
    codeBg.layer.borderWidth = 1;
    codeBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:codeBg];
    
    self.telCodeLbl = [[UILabel alloc] initWithFrame:CGRectMake(codeBg.x, codeBg.y, 47, codeBg.height)];
    _telCodeLbl.numberOfLines = 1;
    _telCodeLbl.textAlignment = NSTextAlignmentRight;
    _telCodeLbl.textColor = [UIColor darkGrayColor];
    _telCodeLbl.font = [UIFont systemFontOfSize:16];
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    _telCodeLbl.text = ([languageName isEqualToString:@"zh-Hans"]?@"86":@"852");
    [self.view addSubview:_telCodeLbl];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tel_code_downward.png"]];
    icon.centerX = (codeBg.maxX - _telCodeLbl.maxX)/2 + _telCodeLbl.maxX;
    icon.centerY = codeBg.centerY;
    [self.view addSubview:icon];
    
    UIButton *telCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telCodeBtn.frame = codeBg.frame;
    [telCodeBtn addTarget:self action:@selector(mobileTelCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:telCodeBtn];
    
    UIView *mobileBg = [[UIView alloc] initWithFrame:CGRectMake(codeBg.maxX + 10, codeBg.y, K_UIScreenWidth - 15 - (codeBg.maxX + 10), codeBg.height)];
    mobileBg.backgroundColor = [UIColor whiteColor];
    mobileBg.layer.cornerRadius = 4;
    mobileBg.layer.borderWidth = 1;
    mobileBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:mobileBg];
    
    self.verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.backgroundColor = UIColor_82b432;
    _verifyBtn.layer.cornerRadius = 4;
    _verifyBtn.size = (CGSize){70,32};
    _verifyBtn.centerY = mobileBg.centerY;
    _verifyBtn.x = mobileBg.maxX - 5 - _verifyBtn.width;
    [_verifyBtn setTitle:NSLocalizedString(@"verify code", nil) forState:UIControlStateNormal]; //NSLocalizedString
    [_verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_verifyBtn addTarget:self action:@selector(mobileVerifyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verifyBtn];
    
    self.mobileTF = [[UITextField alloc] init];
    _mobileTF.frame = CGRectMake(mobileBg.x + 10, (mobileBg.height-20)/2 + mobileBg.y, _verifyBtn.x - 10 - (mobileBg.x + 10), 20);
    _mobileTF.font = [UIFont systemFontOfSize:16];
    _mobileTF.textColor = [UIColor darkGrayColor];
    _mobileTF.placeholder = NSLocalizedString(@"please input phone num", nil);//NSLocalizedString
    _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_mobileTF];
    
    UIView *verifyCodeBg = [[UIView alloc] initWithFrame:CGRectMake(codeBg.x, codeBg.maxY + 10, K_UIScreenWidth - codeBg.x*2, codeBg.height)];
    verifyCodeBg.backgroundColor = [UIColor whiteColor];
    verifyCodeBg.layer.cornerRadius = 4;
    verifyCodeBg.layer.borderWidth = 1;
    verifyCodeBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:verifyCodeBg];
    
    self.verifyCodeTF = [[UITextField alloc] init];
    _verifyCodeTF.frame = CGRectMake(verifyCodeBg.x + 10, (verifyCodeBg.height-20)/2 + verifyCodeBg.y, verifyCodeBg.width-20, 20);
    _verifyCodeTF.font = [UIFont systemFontOfSize:16];
    _verifyCodeTF.textColor = [UIColor darkGrayColor];
    _verifyCodeTF.placeholder = NSLocalizedString(@"please input verify code", nil);//NSLocalizedString
    _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_verifyCodeTF];
    
    UIButton *sumbit = [UIButton buttonWithType:UIButtonTypeCustom];
    sumbit.frame = CGRectMake(verifyCodeBg.x, verifyCodeBg.maxY + 25, verifyCodeBg.width, 40);
    sumbit.backgroundColor = UIColor_82b432;
    sumbit.layer.cornerRadius = 4;
    [sumbit setTitle:NSLocalizedString(@"submit", nil) forState:UIControlStateNormal];//NSLocalizedString
    [sumbit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sumbit.titleLabel.font = [UIFont systemFontOfSize:16];
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
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)SetTelCodeViewControllerTelCode:(NSString*)code {
    
    _telCodeLbl.text = code;
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
