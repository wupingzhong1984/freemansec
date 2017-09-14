//
//  LiveRootViewController.m
//  freemansec
//
//  Created by adamwu on 2017/6/29.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveRootViewController.h"
#import "LiveSearchViewController.h"
#import "UserLiveRootViewController.h"
#import "CustomNaviController.h"
#import "OfficialLiveViewController.h"
#import "UserLiveViewController.h"
#import "UserLiveType.h"
#import "ApplyAnchorViewController.h"
#import "RealNameCertifyViewController.h"
#import "LoginViewController.h"

@interface LiveRootViewController ()

@property (nonatomic,strong)NSMutableArray *typeNameArray;
@property (nonatomic,strong)NSMutableArray *classNameArray;
@property (nonatomic,strong)NSMutableArray *typeIdArray;

@end

@implementation LiveRootViewController

- (NSMutableArray*)typeNameArray {
    
    if (!_typeNameArray) {
        _typeNameArray = [[NSMutableArray alloc] init];
    }
    
    return _typeNameArray;
}

- (NSMutableArray*)classNameArray {
    
    if (!_classNameArray) {
        _classNameArray = [[NSMutableArray alloc] init];
    }
    
    return _classNameArray;
}

- (NSMutableArray*)typeIdArray {
    
    if (!_typeIdArray) {
        _typeIdArray = [[NSMutableArray alloc] init];
    }
    
    return _typeIdArray;
}

- (void)tabBarCenterAction {
    
    if (![[MineManager sharedInstance] getMyInfo]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadUserLogin object:nil];
        return;
    }
    
    NSString *state = [[MineManager sharedInstance] getMyInfo].realNameVerifyState;
    if (state && [state isEqualToString:@"1"]) { //已实名认证
        
        if ([[MineManager sharedInstance] getMyInfo].cId.length > 0) { //申请主播
            
            UserLiveRootViewController *vc = [[UserLiveRootViewController alloc]init];
            //[self.navigationController pushViewController:vc animated:YES];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        } else {
            //NSLocalizedString
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"please finish apply anchor", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"alert cancel", nil) style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"go to apply", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                ApplyAnchorViewController *vc = [[ApplyAnchorViewController alloc]init];
                vc.vcLoadStyle = VCLSPresent;
                [self.navigationController presentViewController:vc animated:YES completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else if ([state isEqualToString:@"4"]) {
        
        [self presentViewController:[Utility createNoticeAlertWithContent:NSLocalizedString(@"we are verifying your apply please wait", nil) okBtnTitle:nil] animated:YES completion:nil];
        
    } else {
        
        NSString *msg;
        if ([state isEqualToString:@"3"]) {
            //NSLocalizedString
            msg = NSLocalizedString(@"identity verify failed submit again", nil);
        } else {
            //NSLocalizedString
            msg = NSLocalizedString(@"please finish identity verify then apply anchor", nil);
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"alert cancel", nil) style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"去验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            RealNameCertifyViewController *vc = [[RealNameCertifyViewController alloc]init];
            vc.vcLoadStyle = VCLSPresent;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)loadSearchPage {
    
    LiveSearchViewController *vc = [[LiveSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)naviBarView {
    
    
    UIImageView *logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_navi_logo.png"]];
    logoIV.x = 15;
    logoIV.centerY = (64 - 20)/2 + 20;
    [self.view addSubview:logoIV];
    
    UIImageView *search = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navibar_search.png"]];
    search.centerX = K_UIScreenWidth - 25;
    search.centerY = logoIV.centerY;
    [self.view addSubview:search];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(loadSearchPage) forControlEvents:UIControlEventTouchUpInside];
    btn.width = search.width + 20;
    btn.height = search.height + 20;
    btn.center = search.center;
    [self.view addSubview:btn];

//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64-0.5, K_UIScreenWidth, 0.5)];
//    line.backgroundColor = UIColor_line_d2d2d2;
//    [self.view addSubview:line];
    
}

- (instancetype)init
{
    if (self = [super initWithTagViewHeight:44])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tabCollViewRect = CGRectMake(60, 20, K_UIScreenWidth-120, 44);
    
    [self naviBarView];

    
        //tabbar中间按钮相应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarCenterAction) name:kNotificationLoadUserLive object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    if ([VideoManager videoKindNeedUpdate] || !self.typeNameArray.count) {

        [VideoManager updateVideoKindLastUpdateTime:[NSDate date]];

        [[MineManager sharedInstance] getUserLiveTypeCompletion:^(NSArray * _Nullable typeList, NSError * _Nullable error) {

            if (error) {

                if (!self.typeNameArray.count) {
                    
                    [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
                }

            } else {

                BOOL needUpdate = NO;
                if (typeList.count != self.typeNameArray.count) {
                    needUpdate = YES;
                } else {

                    if (typeList.count != 0) {

                        for (int i = 0; i < typeList.count; i++) {

                            UserLiveType *model = [typeList objectAtIndex:i];

                            if (![model.liveTypeId isEqualToString:[self.typeIdArray objectAtIndex:i]] ||
                                  ![model.liveTypeName isEqualToString:[self.typeNameArray objectAtIndex:i]]) {
                                needUpdate = YES;
                                break;
                            }
                        }
                    }
                }

                if (needUpdate) {

                    [self.typeNameArray removeAllObjects];
                    [self.typeIdArray removeAllObjects];
                    [self.classNameArray removeAllObjects];
                    [self reloadDataWith:self.typeNameArray andSubViewdisplayClasses:self.classNameArray withParams:self.typeIdArray];
                    
                    for (int i = 0; i < typeList.count; i++) {

                        UserLiveType *model = [typeList objectAtIndex:i];
                        [self.typeNameArray addObject:model.liveTypeName];
                        [self.typeIdArray addObject:model.liveTypeId];
                        
                        if (i == 0) {
                            
                            [self.classNameArray addObject:[OfficialLiveViewController class]];
                        } else {
                            [self.classNameArray addObject:[UserLiveViewController class]];
                        }
                        
                    }

                    [self reloadDataWith:self.typeNameArray andSubViewdisplayClasses:self.classNameArray withParams:self.typeIdArray];
                }
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
