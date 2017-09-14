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
#import "UpdatePhoneViewController.h"
#import "UpdateEmailViewController.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "AreaModel.h"
#import "ResetMobilePwdViewController.h"
#import "ResetEmailPwdViewController.h"

@interface MinePersonInfoViewController ()
<UIScrollViewDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate,
UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,strong) UIView *locationPickerView;
@property (nonatomic,strong) UIPickerView *locationPicker;
@property (nonatomic,strong) NSMutableArray *provinceArray;
@property (nonatomic,strong) NSMutableArray *cityArray;
@property (nonatomic,strong) NSMutableArray *areaArray;
@end

@implementation MinePersonInfoViewController

- (NSMutableArray*)titleArray {
    
    //NSLocalizedString
    return [NSMutableArray arrayWithObjects:
            NSLocalizedString(@"face img", nil),
            NSLocalizedString(@"nickname", nil),
            NSLocalizedString(@"gender", nil),
            NSLocalizedString(@"live citys", nil),
            NSLocalizedString(@"password", nil),
            NSLocalizedString(@"phone", nil),
            NSLocalizedString(@"mail bind", nil),
            NSLocalizedString(@"identity verify", nil), nil];
}

- (NSMutableArray*)provinceArray {
    
    if (!_provinceArray) {
        
        _provinceArray = [[NSMutableArray alloc] init];
    }
    return _provinceArray;
}

- (NSMutableArray*)cityArray {
    
    if (!_cityArray) {
        
        _cityArray = [[NSMutableArray alloc] init];
    }
    return _cityArray;
}

- (NSMutableArray*)areaArray {
    
    if (!_areaArray) {
        
        _areaArray = [[NSMutableArray alloc] init];
    }
    return _areaArray;
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locationPickerViewCancel {
    
    _locationPickerView.y = K_UIScreenHeight;
}

- (void)locationPickerViewConfirm {
    
    _locationPickerView.y = K_UIScreenHeight;
    
    ProvinceModel *p;
    if (self.provinceArray.count > 0){
        p = [self.provinceArray objectAtIndex:[_locationPicker selectedRowInComponent:0]];
    }
    
    CityModel *c;
    if (self.cityArray.count > 0){
        c = [self.cityArray objectAtIndex:[_locationPicker selectedRowInComponent:1]];
    }
    
    AreaModel *a;
    if (self.areaArray.count > 0){
        a = [self.areaArray objectAtIndex:[_locationPicker selectedRowInComponent:2]];
    }
    
    [[MineManager sharedInstance] updateProvince:(p.provinceId.length > 0?p.provinceId:@"")
                                            city:(c.cityId.length > 0?c.cityId:@"")
                                            area:(a.areaId.length > 0?a.areaId:@"")
                                      completion:^(MyInfoModel * _Nullable myInfo, NSError * _Nullable error) {
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            [[MineManager sharedInstance] updateMyInfo:myInfo];
            UILabel *locationLbl = (UILabel*)[_contentView viewWithTag:103];
            locationLbl.text = myInfo.area.length > 0?myInfo.area:myInfo.city;
        }
    }];
}

- (UIView*)locationPickerView {
    
    if(!_locationPickerView) {
        
        _locationPicker = [[UIPickerView alloc] init];
        _locationPicker.width = K_UIScreenWidth;
        _locationPicker.showsSelectionIndicator = YES;
        _locationPicker.delegate = self;
        _locationPicker.dataSource = self;
        
        _locationPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, K_UIScreenHeight, K_UIScreenWidth, _locationPicker.height + 40)];
        _locationPickerView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _locationPicker.width, 1)];
        line.backgroundColor = UIColor_line_d2d2d2;
        [_locationPickerView addSubview:line];
        
        
        [_locationPickerView addSubview:_locationPicker];
        _locationPicker.y = 40;
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:NSLocalizedString(@"alert cancel", nil) forState:UIControlStateNormal];
        [cancel setTitleColor:UIColor_82b432 forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        cancel.size = CGSizeMake(60, 40);
        [cancel addTarget:self action:@selector(locationPickerViewCancel) forControlEvents:UIControlEventTouchUpInside];
        [_locationPickerView addSubview:cancel];
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setTitle:NSLocalizedString(@"alert OK", nil) forState:UIControlStateNormal];
        [confirm setTitleColor:UIColor_82b432 forState:UIControlStateNormal];
        confirm.titleLabel.font = [UIFont systemFontOfSize:16];
        confirm.size = CGSizeMake(60, 40);
        confirm.x = _locationPickerView.width-confirm.width;
        [confirm addTarget:self action:@selector(locationPickerViewConfirm) forControlEvents:UIControlEventTouchUpInside];
        [_locationPickerView addSubview:confirm];
    }
    
    return _locationPickerView;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:NSLocalizedString(@"personal info", nil) color:UIColor_navititle];//NSLocalizedString
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

- (void)cellAction:(id)sender {
    
    NSInteger index = ((UIView*)sender).tag;
    switch (index) {
        case 0: {
            //NSLocalizedString
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"take photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                    controller.delegate = self;
                    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                    controller.allowsEditing = YES;
                    [self presentViewController:controller
                                       animated:YES completion:nil];
                }]];
            }
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"select from album", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.delegate = self;
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                controller.allowsEditing = YES;
                [self presentViewController:controller animated:YES completion:nil];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"alert cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"please select gender", nil) preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"female", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[MineManager sharedInstance] updateSex:@"1" completion:^(MyInfoModel * _Nullable myInfo, NSError * _Nullable error) {
                    if (error) {
                        
                        [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
                        
                    } else {
                        
                        [[MineManager sharedInstance] updateMyInfo:myInfo];
                        UILabel *genderLbl = (UILabel*)[_contentView viewWithTag:102];
                        genderLbl.text = NSLocalizedString(@"female", nil);
                    }
                }];
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"male", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[MineManager sharedInstance] updateSex:@"0" completion:^(MyInfoModel * _Nullable myInfo, NSError * _Nullable error) {
                    if (error) {
                        
                        [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
                        
                    } else {
                        
                        [[MineManager sharedInstance] updateMyInfo:myInfo];
                        UILabel *genderLbl = (UILabel*)[_contentView viewWithTag:102];
                        genderLbl.text = NSLocalizedString(@"male", nil);
                    }
                }];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"alert cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case 3: {
            
            if (!_locationPickerView) {
                
                [self.view addSubview:self.locationPickerView];
            }
            
            if (_locationPickerView.y == K_UIScreenHeight) {
                
                _locationPickerView.y = K_UIScreenHeight - _locationPickerView.height;
            }
            break;
        }
        case 4: {
            //重设密码=密码找回
            MyInfoModel *myInfo = [[MineManager sharedInstance] getMyInfo];
            if (myInfo.phone.length > 0 && myInfo.email.length > 0) {
                ForgetPwdViewController *vc = [[ForgetPwdViewController alloc] init];
                vc.resetPwdKind = RPKResetPwd;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (myInfo.phone.length > 0) {
                ResetMobilePwdViewController *vc = [[ResetMobilePwdViewController alloc] init];
                vc.resetPwdKind = RPKResetPwd;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (myInfo.email.length > 0) {
                ResetEmailPwdViewController *vc = [[ResetEmailPwdViewController alloc] init];
                vc.resetPwdKind = RPKResetPwd;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                //NSLocalizedString
                [self presentViewController:[Utility createNoticeAlertWithContent:NSLocalizedString(@"cant modify pwd when login with third", nil) okBtnTitle:nil] animated:YES completion:nil];
            }
            
            break;
        }
        case 5: {
            if(![[MineManager sharedInstance] getMyInfo].phone.length) {
                
                UpdatePhoneViewController *vc = [[UpdatePhoneViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        case 6: {
            if(![[MineManager sharedInstance] getMyInfo].email.length) {
                
                UpdateEmailViewController *vc = [[UpdateEmailViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        default: {
            
            NSString *state = [[MineManager sharedInstance] getMyInfo].realNameVerifyState;
            if (!state || !state.length || [state isEqualToString:@"3"]) {
                
                RealNameCertifyViewController *vc = [[RealNameCertifyViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                //NSLocalizedString
                NSString *msg;
                if ([state isEqualToString:@"1"]) {
                    msg = NSLocalizedString(@"sorry your identity verify is passed", nil);
                } else if ([state isEqualToString:@"2"]) {
                    msg = NSLocalizedString(@"sorry your identity is locked", nil);
                } else {
                    msg = NSLocalizedString(@"we are verifying your apply please wait", nil);
                }
                [self presentViewController:[Utility createNoticeAlertWithContent:msg okBtnTitle:nil] animated:YES completion:nil];
            }
            break;
        }
    }
}

- (void)logout {
    
    [[MineManager sharedInstance] logout];
    [self back];
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
    logout.backgroundColor = UIColor_82b432;
    logout.layer.cornerRadius = 4;
    [logout setTitle:NSLocalizedString(@"log out", nil) forState:UIControlStateNormal];//NSLocalizedString
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    [imgV sd_setImageWithURL:[NSURL URLWithString:[[MineManager sharedInstance] getMyInfo].headImg]];
    
    UILabel *nickNameLbl = (UILabel*)[_contentView viewWithTag:101];
    nickNameLbl.text = [[MineManager sharedInstance] getMyInfo].nickName;
    
    UILabel *genderLbl = (UILabel*)[_contentView viewWithTag:102];
    genderLbl.text = ([[MineManager sharedInstance] getMyInfo].sex.integerValue == 0?@"男":@"女");
    
    UILabel *cityLbl = (UILabel*)[_contentView viewWithTag:103];
    cityLbl.text = [[MineManager sharedInstance] getMyInfo].area.length > 0?[[MineManager sharedInstance] getMyInfo].area:NSLocalizedString(@"please select", nil);
    
    UILabel *pwdLbl = (UILabel*)[_contentView viewWithTag:104];
    pwdLbl.text = NSLocalizedString(@"clich to modify", nil);
    
    UILabel *mobileLbl = (UILabel*)[_contentView viewWithTag:105];
    mobileLbl.text = [[MineManager sharedInstance] getMyInfo].phone.length > 0?[[MineManager sharedInstance] getMyInfo].phone:NSLocalizedString(@"click to bind", nil);
    
    UILabel *emailLbl = (UILabel*)[_contentView viewWithTag:106];
    emailLbl.text = [[MineManager sharedInstance] getMyInfo].email.length > 0?[[MineManager sharedInstance] getMyInfo].email:NSLocalizedString(@"click to bind", nil);
    
    UILabel *realLbl = (UILabel*)[_contentView viewWithTag:107];
    
    if([[MineManager sharedInstance] getMyInfo].realNameVerifyState) {
        //0未审核，1已审核，2已冻结，3未通过审核，4审核中
        switch ([[[MineManager sharedInstance] getMyInfo].realNameVerifyState intValue]) {
            case 0:
                realLbl.text = NSLocalizedString(@"click to submit", nil);
                break;
            case 1:
                realLbl.text = NSLocalizedString(@"verify finished", nil);
                break;
            case 2:
                realLbl.text = NSLocalizedString(@"locked", nil);
                break;
            case 3:
                realLbl.text = NSLocalizedString(@"verify failed", nil);
                break;
            default:
                realLbl.text = NSLocalizedString(@"verifying", nil);
                break;
        }
        
    } else {
        realLbl.text = NSLocalizedString(@"click to submit", nil);
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
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    [self setupSubviews];
    
    [[MineManager sharedInstance] getProvinceListCompletion:^(NSArray * _Nullable provinceList, NSError * _Nullable error) {
        
        if (provinceList) {
            [self.provinceArray removeAllObjects];
            [self.provinceArray addObjectsFromArray:provinceList];
            [self.view addSubview:self.locationPickerView];
            
            ProvinceModel *p = [self.provinceArray objectAtIndex:0];
            [[MineManager sharedInstance] getCityListByProvinceId:p.provinceId completion:^(NSArray * _Nullable cityList, NSError * _Nullable error) {
                if (cityList) {
                    [self.cityArray addObjectsFromArray:cityList];
                    [_locationPicker reloadComponent:1];
                    CityModel *c = [self.cityArray objectAtIndex:0];
                    [[MineManager sharedInstance] getAreaListByCityId:c.cityId completion:^(NSArray * _Nullable areaList, NSError * _Nullable error) {
                        if (areaList) {
                            [self.areaArray addObjectsFromArray:areaList];
                            [_locationPicker reloadComponent:2];
                        }
                    }];
                }
            }];

        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    [self loadInfos];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [[MineManager sharedInstance] updateHeadImg:editImage completion:^(MyInfoModel * _Nullable myInfo, NSError * _Nullable error) {
            
            [MBProgressHUD hideHUDForView:self.view];
            if (error) {
                
                [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
                
            } else {
                
                [[MineManager sharedInstance] updateMyInfo:myInfo];
                UIImageView *imgV = (UIImageView*)[_contentView viewWithTag:100];
                [imgV sd_setImageWithURL:[NSURL URLWithString:myInfo.headImg]];
                
            }
        }];
        
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.areaArray.count;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        
        ProvinceModel *p = [self.provinceArray objectAtIndex:row];
        return p.name;
    } else if (component == 1) {
        CityModel *c = [self.cityArray objectAtIndex:row];
        return c.name;
    } else {
        AreaModel *a = [self.areaArray objectAtIndex:row];
        return a.name;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        [self.areaArray removeAllObjects];
        [self.cityArray removeAllObjects];
        [_locationPicker reloadComponent:2];
        [_locationPicker reloadComponent:1];
        
        ProvinceModel *p = [self.provinceArray objectAtIndex:row];
        [[MineManager sharedInstance] getCityListByProvinceId:p.provinceId completion:^(NSArray * _Nullable cityList, NSError * _Nullable error) {
            if (cityList) {
                [self.cityArray addObjectsFromArray:cityList];
                [_locationPicker reloadComponent:1];
                CityModel *c = [self.cityArray objectAtIndex:0];
                [[MineManager sharedInstance] getAreaListByCityId:c.cityId completion:^(NSArray * _Nullable areaList, NSError * _Nullable error) {
                    if (areaList) {
                        [self.areaArray addObjectsFromArray:areaList];
                        [_locationPicker reloadComponent:2];
                    }
                }];
            }
        }];
    } else if (component == 1) {
        
        [self.areaArray removeAllObjects];
        [_locationPicker reloadComponent:2];
        CityModel *c = [self.cityArray objectAtIndex:row];
        [[MineManager sharedInstance] getAreaListByCityId:c.cityId completion:^(NSArray * _Nullable areaList, NSError * _Nullable error) {
            if (areaList) {
                [self.areaArray addObjectsFromArray:areaList];
                [_locationPicker reloadComponent:2];
            }
        }];
    }
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
