//
//  MinePersonInfoViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/27.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MinePersonInfoViewController.h"
#import "LoginViewController.h"
#import "CustomNaviController.h"
#import "NickNameViewController.h"
#import "ForgetPwdViewController.h"
#import "RealNameCertifyViewController.h"

@interface MinePersonInfoViewController ()
<UIScrollViewDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate,
RealNameCertifyViewControllerDelegate>

@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,assign) BOOL didSubmitRealNameVerify;
@end

@implementation MinePersonInfoViewController

- (NSMutableArray*)titleArray {
    
    //NSLocalizedString
    return [NSMutableArray arrayWithObjects:@"头像",@"昵称",@"性别",@"所在地",@"密码",@"手机",@"邮箱绑定",@"实名认证", nil];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = [UIColor blackColor];
    
    UIView *title = [self commNaviTitle:@"个人信息" color:[UIColor whiteColor]];//NSLocalizedString
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

- (void)cellAction:(id)sender {
    
    NSInteger index = ((UIView*)sender).tag;
    switch (index) {
        case 0: {
            //NSLocalizedString
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                    controller.delegate = self;
                    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                    controller.allowsEditing = YES;
                    [self presentViewController:controller
                                       animated:YES completion:nil];
                }]];
            }
            [alert addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.delegate = self;
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                controller.allowsEditing = YES;
                [self presentViewController:controller animated:YES completion:nil];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
            break;
        }
        case 1: {
         
            NickNameViewController *vc = [[NickNameViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            //NSLocalizedString
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择性别" preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //todo
                //submit gender
                UILabel *genderLbl = (UILabel*)[_contentView viewWithTag:102];
                genderLbl.text = @"女";
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //todo
                //submit gender
                UILabel *genderLbl = (UILabel*)[_contentView viewWithTag:102];
                genderLbl.text = @"男";
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            break;
        }
        case 3: {
            
            //todo
            //所在地 picker
            break;
        }
        case 4: {
            //重设密码=密码找回
            ForgetPwdViewController *vc = [[ForgetPwdViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5: {
            if(![MineManager sharedInstance].myInfo.phone.length) {
                
                //todo
                //手机绑定
            }
            break;
        }
        case 6: {
            if(![MineManager sharedInstance].myInfo.email.length) {
                
                //todo
                //邮箱绑定
            }
            break;
        }
        default: {
            
            NSString *state = [MineManager sharedInstance].myInfo.realNameVerifyState;
            if (!state || [state isEqualToString:@"3"]) {
                
                RealNameCertifyViewController *vc = [[RealNameCertifyViewController alloc] init];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                //NSLocalizedString
                NSString *msg;
                if ([state isEqualToString:@"1"]) {
                    msg = @"对不起，您的实名认证已通过，无法重复提交。";
                } else if ([state isEqualToString:@"2"]) {
                    msg = @"对不起，您的身份已冻结，无法再提交实名认证。";
                } else {
                    msg = @"我们正在审核您的认证申请，请耐心等待。";
                }
                [self presentViewController:[Utility createAlertWithTitle:@"提示" content:msg okBtnTitle:nil] animated:YES completion:nil];
            }
            break;
        }
    }
}

- (void)logout {
    
    [[MineManager sharedInstance] logout];
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:vc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:NO completion:nil];
}

- (void)setupSubviews {
    
    UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 20, _contentView.width+1, 45*4)];
    bg1.backgroundColor = [UIColor whiteColor];
    bg1.layer.borderWidth = 0.5;
    bg1.layer.borderColor = UIColor_line_d2d2d2.CGColor;
    [_contentView addSubview:bg1];
    
    UIView *bg2 = [[UIView alloc] initWithFrame:CGRectMake(-0.5, bg1.maxY + 20, _contentView.width+1, 45*4)];
    bg2.backgroundColor = [UIColor whiteColor];
    bg2.layer.borderWidth = 0.5;
    bg2.layer.borderColor = UIColor_line_d2d2d2.CGColor;
    [_contentView addSubview:bg2];
    
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    logout.frame = CGRectMake(15, bg2.maxY + 40, _contentView.width-30, 44);
    logout.backgroundColor = UIColor_0a6ed2;
    logout.layer.cornerRadius = 4;
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];//NSLocalizedString
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; //todo
    logout.titleLabel.font = [UIFont systemFontOfSize:16];
    [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:logout];
    _contentView.contentSize = CGSizeMake(_contentView.width, logout.maxY);
    
    
    CGFloat originY = 20;
    for (int i = 0; i < [self titleArray].count;i++) {
        
        UILabel *title = [UILabel createLabelWithFrame:CGRectZero text:[[self titleArray] objectAtIndex:i] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16]];
        [title sizeToFit];
        title.x = 15;
        title.centerY = originY + 45/2;
        [_contentView addSubview:title];
        
        UIImageView *right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_cell_right.png"]];
        right.centerY = title.centerY;
        right.x = _contentView.width-15-right.width;
        [_contentView addSubview:right];
        
        UIImageView *img;
        UILabel *lbl;
        if (i == 0) {
            img = [[UIImageView alloc] init];
            img.size = CGSizeMake(35, 35);
            img.x = right.x - 10 - img.width;
            img.centerY = originY + 45/2;
            img.tag = 100+i;
            [_contentView addSubview:img];
        } else {
            lbl = [[UILabel alloc] init];
            lbl.font = [UIFont systemFontOfSize:16];
            lbl.textColor = UIColor_line_d2d2d2;
            lbl.numberOfLines = 1;
            lbl.textAlignment = NSTextAlignmentRight;
            lbl.x = title.maxX + 10;
            lbl.height = 45;
            lbl.y = originY;
            lbl.width = right.x - 10 - lbl.x;
            lbl.tag = 100+i;
            [_contentView addSubview:lbl];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(0, originY, _contentView.width, 45);
        [btn addTarget:self action:@selector(cellAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btn];
        
        if (i == 0 ||
            i == 1 ||
            i == 2 ||
            i == 4 ||
            i == 5 ||
            i == 6) {
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, originY+45, _contentView.width-15, 0.5)];
            line.backgroundColor = UIColor_line_d2d2d2;
            [_contentView addSubview:line];
        }
        
        originY += 45;
        if (i == 3) {
            originY += 20;
        }
    }
}

- (void)loadInfos {
    
    UIImageView *imgV = (UIImageView*)[_contentView viewWithTag:100];
    [imgV setImageWithURL:[NSURL URLWithString:[MineManager sharedInstance].myInfo.headImg]];
    
    UILabel *nickNameLbl = (UILabel*)[_contentView viewWithTag:101];
    nickNameLbl.text = [MineManager sharedInstance].myInfo.nickName;
    
    UILabel *genderLbl = (UILabel*)[_contentView viewWithTag:102];
    genderLbl.text = ([MineManager sharedInstance].myInfo.sex.integerValue == 0?@"男":@"女");
    
    UILabel *cityLbl = (UILabel*)[_contentView viewWithTag:103];
    cityLbl.text = [MineManager sharedInstance].myInfo.area.length > 0?[MineManager sharedInstance].myInfo.area:@"请选择";
    
    UILabel *pwdLbl = (UILabel*)[_contentView viewWithTag:104];
    pwdLbl.text = @"点击修改";
    
    UILabel *mobileLbl = (UILabel*)[_contentView viewWithTag:105];
    mobileLbl.text = [MineManager sharedInstance].myInfo.phone.length > 0?[MineManager sharedInstance].myInfo.phone:@"点击绑定";
    
    UILabel *emailLbl = (UILabel*)[_contentView viewWithTag:106];
    emailLbl.text = [MineManager sharedInstance].myInfo.email.length > 0?[MineManager sharedInstance].myInfo.email:@"点击绑定";
    
    UILabel *realLbl = (UILabel*)[_contentView viewWithTag:107];
    
    if([MineManager sharedInstance].myInfo.realNameVerifyState) {
        //0未审核，1已审核，2已冻结，3未通过审核，4审核中
        switch ([[MineManager sharedInstance].myInfo.realNameVerifyState intValue]) {
            case 0:
                realLbl.text = @"未审核";
                break;
            case 1:
                realLbl.text = @"已审核";
                break;
            case 2:
                realLbl.text = @"已冻结";
                break;
            case 3:
                realLbl.text = @"未通过审核";
                break;
            default:
                realLbl.text = @"审核中";
                break;
        }
        
    } else {
        realLbl.text = @"点击提交";
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight - naviBar.maxY)];
    _contentView.backgroundColor = [UIColor clearColor]; //todo
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
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self loadInfos];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *editImage = [info valueForKey:UIImagePickerControllerEditedImage];
        
        editImage = [Utility fixOrientation:editImage];
        //UIImageJPEGRepresentation(originImage,0.8);
        
        //todo
        //submit face
        
        UIImageView *imgV = (UIImageView*)[_contentView viewWithTag:100];
        [imgV setImageWithURL:[NSURL URLWithString:@""]];
        
    }];
}

- (void)RealNameCertifyViewControllerDelegateDidSubmit {
    
    _didSubmitRealNameVerify = YES;
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
