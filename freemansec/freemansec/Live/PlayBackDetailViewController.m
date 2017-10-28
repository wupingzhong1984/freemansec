//
//  PlayBackDetailViewController.m
//  freemansec
//
//  Created by adamwu on 2017/9/1.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "PlayBackDetailViewController.h"
#import "PlayBackListByUserViewController.h"

@interface PlayBackDetailViewController ()
<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@end

@implementation PlayBackDetailViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, self.navigationController.navigationBar.maxY)];
    v.backgroundColor = UIColor_navibg;
    
    [v addSubview:[self commNaviTitle:_name color:UIColor_navititle]];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, naviBar.maxY,K_UIScreenWidth, K_UIScreenHeight - naviBar.maxY)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://mzcj.dhteam.net/videoback.html?vid=%@&lang=%@&type=%@",_playBackId,[LogicManager appLangCode],_playBackType];
    
    if ([[MineManager sharedInstance] getMyInfo]) {
        [url appendFormat:@"&userid=%@",[[MineManager sharedInstance] getMyInfo].userId];
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:
                           [NSURL URLWithString:
                            url]]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *scheme = @"freemansec://";
    NSString *urlStr = request.URL.absoluteString;
    NSRange range = [urlStr rangeOfString:scheme];
        
    if (range.length > 0) {
            
        NSString *subPath = [urlStr substringFromIndex:scheme.length];
        NSArray *arr = [subPath componentsSeparatedByString:@"?"];
        
        if ([arr[0] isEqualToString:@"keyword"]) {
            
            if (arr.count > 1) {
                
                NSString *str = [arr[1] stringByRemovingPercentEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                
                PlayBackListByUserViewController *vc = [[PlayBackListByUserViewController alloc] init];
                if ([dic[@"type"] isEqualToString:@"0"]) { //官方
                    vc.typeId = _kingPlayBackType;
                } else { //主播
                    vc.cId = dic[@"cid"];
                }
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        return NO;
    }
    
    return YES;
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
