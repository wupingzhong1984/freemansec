//
//  RealNameCertifyViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "RealNameCertifyViewController.h"
#import "DottedLineView.h"

@interface RealNameCertifyViewController ()
<UIScrollViewDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,strong) UITextField *nameTF;
@property (nonatomic,strong) UILabel *userTypeLbl;
@property (nonatomic,strong) UIView *frontPlaceV;
@property (nonatomic,strong) UIImageView *frontIV;
@end

@implementation RealNameCertifyViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)frontPlaceV {
    
    if (!_frontPlaceV) {
        
        _frontPlaceV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth-30, 140)];
        
        UIImageView *add = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]; //todo
        add.center = CGPointMake(_frontPlaceV.width/2, 57);
        [_frontPlaceV addSubview:add];
        
        //NSLocalizedString
        UILabel *title = [UILabel createLabelWithFrame:CGRectZero text:@"上传手持身份证" textColor:UIColor_textfield_placecolor font:[UIFont systemFontOfSize:16]];
        [title sizeToFit];
        title.center = CGPointMake(add.centerX, 98);
        [_frontPlaceV addSubview:title];
        
    }
    return _frontPlaceV;
}

- (UIView*)backPlaceV {
    
    if (!_frontPlaceV) {
        
        _frontPlaceV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth-30, 140)];
        
        UIImageView *add = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]; //todo
        add.center = CGPointMake(_frontPlaceV.width/2, 57);
        [_frontPlaceV addSubview:add];
        
        //NSLocalizedString
        UILabel *title = [UILabel createLabelWithFrame:CGRectZero text:@"上传身份证背面" textColor:UIColor_textfield_placecolor font:[UIFont systemFontOfSize:16]];
        [title sizeToFit];
        title.center = CGPointMake(add.centerX, 98);
        [_frontPlaceV addSubview:title];
        
    }
    return _frontPlaceV;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = [UIColor blackColor];
    
    UIView *title = [self commNaviTitle:@"实名认证" color:[UIColor whiteColor]];//NSLocalizedString
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

- (void)userTypeAction {
    
    //NSLocalizedString
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"用户类型" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"大陆用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _userTypeLbl.text = @"大陆用户";
        _userTypeLbl.textColor = [UIColor darkGrayColor];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"香港用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _userTypeLbl.text = @"香港用户";
        _userTypeLbl.textColor = [UIColor darkGrayColor];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"其他用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _userTypeLbl.text = @"其他用户";
        _userTypeLbl.textColor = [UIColor darkGrayColor];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showImagePick {
    
    //NSLocalizedString
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.allowsEditing = NO;
            [self presentViewController:controller
                               animated:YES completion:nil];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        [self presentViewController:controller animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) submit {
    
    //todo
    //submit
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(RealNameCertifyViewControllerDelegateDidSubmit)]) {
        [_delegate RealNameCertifyViewControllerDelegateDidSubmit];
    }
    [self back];
}

- (void)setupSubviews {
    
    UIView *nameBg = [[UIView alloc] initWithFrame:CGRectMake(15, 60, K_UIScreenWidth-30, 44)];
    nameBg.backgroundColor = [UIColor whiteColor];
    nameBg.layer.cornerRadius = 4;
    nameBg.layer.borderWidth = 1;
    nameBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:nameBg];
    
    self.nameTF = [[UITextField alloc] init];
    _nameTF.frame = CGRectMake(nameBg.x + 10, (nameBg.height-20)/2 + nameBg.y, nameBg.width-20, 20);
    _nameTF.font = [UIFont systemFontOfSize:16];
    _nameTF.textColor = [UIColor darkGrayColor];
    _nameTF.placeholder = @"请输入真实姓名";//NSLocalizedString
    [_contentView addSubview:_nameTF];
    
    UIView *userTypeBg = [[UIView alloc] initWithFrame:CGRectMake(nameBg.x, nameBg.maxY + 10, nameBg.width, nameBg.height)];
    userTypeBg.backgroundColor = [UIColor whiteColor];
    userTypeBg.layer.cornerRadius = 4;
    userTypeBg.layer.borderWidth = 1;
    userTypeBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_contentView addSubview:userTypeBg];
    
    self.userTypeLbl = [[UILabel alloc] initWithFrame:CGRectMake(userTypeBg.x + 10, (userTypeBg.height-20)/2 + userTypeBg.y, userTypeBg.width-20, 20)];
    _userTypeLbl.font = [UIFont systemFontOfSize:16];
    _userTypeLbl.textColor = UIColor_textfield_placecolor;
    _userTypeLbl.text = @"请选择用户类型（大陆，香港，其它）";//NSLocalizedString
    [_contentView addSubview:_userTypeLbl];
    
    UIButton *setUserTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setUserTypeBtn.frame = userTypeBg.frame;
    [setUserTypeBtn addTarget:self action:@selector(userTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:setUserTypeBtn];
    
    DottedLineView *whiteBg1 = [[DottedLineView alloc] initWithLineColor:[UIColor lightGrayColor] width:1 frame:CGRectMake(15, userTypeBg.maxY + 20, K_UIScreenWidth-30, 140)];
    whiteBg1.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:whiteBg1];
    UIView *place1 = self.frontPlaceV;
    place1.center = whiteBg1.center;
    [_contentView addSubview:place1];
    self.frontIV = [[UIImageView alloc] initWithFrame:whiteBg1.frame];
    [_contentView addSubview:_frontIV];
    UIButton *frontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    frontBtn.frame = whiteBg1.frame;
    [frontBtn addTarget:self action:@selector(showImagePick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:frontBtn];
    
    UILabel *sample1 = [UILabel createLabelWithFrame:CGRectZero text:@"示例：" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13]];
    [sample1 sizeToFit];
    sample1.x = frontBtn.x;
    sample1.y = frontBtn.maxY + 13;
    [_contentView addSubview:sample1];
    
    UIImageView *samplePhoto1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]; //todo
    samplePhoto1.x = sample1.x;
    samplePhoto1.y = sample1.maxY + 10;
    [_contentView addSubview:samplePhoto1];
    
    //todo
    //text
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(nameBg.x, samplePhoto1.maxY + 27, nameBg.width, 40);
    btn.backgroundColor = UIColor_0a6ed2;
    btn.layer.cornerRadius = 4;
    [btn setTitle:@"提交" forState:UIControlStateNormal];//NSLocalizedString
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:btn];
    _contentView.contentSize = CGSizeMake(_contentView.width, btn.maxY + 25);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_nameTF resignFirstResponder];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        originalImage = [Utility fixOrientation:originalImage];
        //UIImageJPEGRepresentation(originImage,0.8);
        
        UIImageView *imgV;
        CGPoint center;
        
            _frontPlaceV.hidden = YES;
            imgV = _frontIV;
            center = _frontIV.center;
    
        
        if (imgV.width/imgV.height < originalImage.size.width/originalImage.size.height) {
            
            imgV.frame = CGRectMake(0, imgV.y, imgV.height*(originalImage.size.width/originalImage.size.height), imgV.height);
        } else {
            imgV.frame = CGRectMake(0, imgV.y, imgV.width, imgV.width/(originalImage.size.width/originalImage.size.height));
        }
        imgV.center = center;
        [_contentView addSubview:imgV];
    }];
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
