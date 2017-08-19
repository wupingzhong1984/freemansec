//
//  VideoRootViewController.m
//  freemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VideoRootViewController.h"
#import "VideoKindViewController.h"
#import "VideoKindModel.h"

@interface VideoRootViewController ()

@property (nonatomic,strong)NSMutableArray *kindNameArray;
@property (nonatomic,strong)NSMutableArray *classNameArray;
@property (nonatomic,strong)NSMutableArray *kindIdArray;
@end

@implementation VideoRootViewController

- (NSMutableArray*)kindNameArray {
    
    if (!_kindNameArray) {
        _kindNameArray = [[NSMutableArray alloc] init];
    }
    
    return _kindNameArray;
}

- (NSMutableArray*)classNameArray {
    
    if (!_classNameArray) {
        _classNameArray = [[NSMutableArray alloc] init];
    }
    
    return _classNameArray;
}

- (NSMutableArray*)kindIdArray {
    
    if (!_kindIdArray) {
        _kindIdArray = [[NSMutableArray alloc] init];
    }
    
    return _kindIdArray;
}

- (void)loadSearchPage {
    
    return;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, 64)];
    v.backgroundColor = [UIColor blackColor];
    
    UIView *title = [self commNaviTitle:@"热门视频" color:[UIColor whiteColor]]; //NSLocalizedString
    title.centerY = (v.height - 20)/2 + 20;
    [v addSubview:title];
   
    return v;
}

//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:38])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    NSArray *titleArray = @[
                            @"分类1",
                            @"分类2",
                            @"分类3",
                            @"分类4"
                            ];
    
    NSArray *classNames = @[
                            [VideoKindViewController class],
                            [VideoKindViewController class],[VideoKindViewController class],
                            [VideoKindViewController class]
                            ];
    
    NSArray *params = @[
                        @"1",
                        @"2",
                        @"2",
                        @"3"
                        ];
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:params];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //test
    return;
    
//    if ([VideoManager videoKindNeedUpdate] || !self.kindNameArray.count) {
//        
//        [VideoManager updateVideoKindLastUpdateTime:[NSDate date]];
//        
//        [[VideoManager sharedInstance] getVideoKindCompletion:^(NSArray * _Nullable kindList, NSError * _Nullable error) {
//            
//            if (error) {
//                
//                [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
//                
//            } else {
//                
//                BOOL needUpdate = NO;
//                if (kindList.count != self.kindNameArray.count) {
//                    needUpdate = YES;
//                } else {
//                    
//                    if (kindList.count != 0) {
//                        
//                        for (int i = 0; i < kindList.count; i++) {
//                            
//                            VideoKindModel *model = [kindList objectAtIndex:i];
//                            
//                            if (![model.kindId isEqualToString:[self.kindIdArray objectAtIndex:i]] ||
//                                  ![model.kindName isEqualToString:[self.kindNameArray objectAtIndex:i]]) {
//                                needUpdate = YES;
//                                break;
//                            }
//                        }
//                    }
//                }
//                
//                if (needUpdate) {
//                    
//                    [self.kindNameArray removeAllObjects];
//                    [self.kindIdArray removeAllObjects];
//                    [self.classNameArray removeAllObjects];
//                    
//                    for (VideoKindModel *model in kindList) {
//                        
//                        [self.kindNameArray addObject:model.kindName];
//                        [self.kindIdArray addObject:model.kindId];
//                        [self.classNameArray addObject:[VideoKindViewController class]];
//                    }
//                    
//                    [self reloadDataWith:self.kindNameArray andSubViewdisplayClasses:self.classNameArray withParams:self.kindIdArray];
//                }
//            }
//        }];
//    }

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
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
