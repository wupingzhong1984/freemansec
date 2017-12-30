//
//  TopupViewController.m
//  freemansec
//
//  Created by adamwu on 2017/11/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "TopupViewController.h"
#import "TopupProductView.h"
#import "TopupProductModel.h"

@interface TopupViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger selectedIndex;

@end

@implementation TopupViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = [UIColor blackColor];
    
    UIView *title = [self commNaviTitle:NSLocalizedString(@"my account", nil) color:[UIColor whiteColor]];
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

- (void)payAction {
    
    if (_selectedIndex < 0) {
        
        [self presentViewController:[Utility createNoticeAlertWithContent:NSLocalizedString(@"please select pop-up item", nil) okBtnTitle:nil] animated:YES completion:nil];
        return;
    }
    
    //todo
}

- (void)productClicked:(id)sender {
    
    TopupProductView *v;
    UIButton *btn = (UIButton*)sender;
    v = (TopupProductView*)[btn superview];
    
    if (v.tag - 100 == _selectedIndex) { //已选中
        return;
    }
    
    //old
    v = (TopupProductView*)[_scrollView viewWithTag:(100+_selectedIndex)];
    v.selected = NO;
    
    //new
    v = (TopupProductView*)[btn superview];
    v.selected = YES;
    _selectedIndex = v.tag - 100;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectedIndex = -1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    CGSize itemSize = [UIImage imageNamed:@"topup_btn_bg.png"].size;
    CGFloat originX = (K_UIScreenWidth - itemSize.width*2 - 14)/2;
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(originX, K_UIScreenHeight - 40 - 20, K_UIScreenWidth - originX*2, 40);
    [payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    payBtn.layer.cornerRadius = 4;
    payBtn.backgroundColor = UIColor_1877d1;
    [payBtn setTitle:NSLocalizedString(@"pay presently", nil) forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:payBtn];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, naviBar.maxY, K_UIScreenWidth, payBtn.y - 20 - naviBar.maxY)];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_scrollView];
    
    [self requestTopupList];
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

- (void)requestTopupList {
    
    [[MineManager sharedInstance] getTopupProductListCompletion:^(NSArray * _Nullable productList, NSError * _Nullable error) {
        
        if (error) {
            
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            
        } else {
            
            CGSize itemSize = [UIImage imageNamed:@"topup_btn_bg_h.png"].size;
            CGFloat space = 14;
            CGFloat originX = (K_UIScreenWidth - itemSize.width*2 - space)/2;
            CGFloat originY = 10;
            
            TopupProductView *v;
            for (int i = 0; i < productList.count; i++) {
                
                TopupProductModel *product = [productList objectAtIndex:i];
                
                v = [[TopupProductView alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
                [v.touchBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
                v.productName = product.productName;
                v.costDesc = product.costDesc;
                v.origin = CGPointMake(originX, originY);
                v.tag = 100+i;
                [_scrollView addSubview:v];
                
                if ((i+1)%2 == 0) {
                    originX = (K_UIScreenWidth - itemSize.width*2 - space)/2;
                    originY += 10 + itemSize.height;
                } else {
                    originX += space + itemSize.width;
                }
            }
            
            _scrollView.contentSize = CGSizeMake(_scrollView.width, v.maxY + 10);
        }
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
