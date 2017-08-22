//
//  LivePlayViewController.m
//  freemansec
//
//  Created by adamwu on 2017/7/9.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LivePlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "Reachability.h"
#import "PlayerView.h"
//#import "IMYWebView.h"

@interface LivePlayViewController ()
{
    BOOL played;
    BOOL landed;
}
@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (nonatomic ,strong) PlayerView *playerView;
@property (nonatomic, strong) UIView *controlBar;
@property (nonatomic ,strong) UIButton *stateButton;
@property (nonatomic ,strong) UIButton *oriBtn;
@end

@implementation LivePlayViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)attention {
    
    [[MineManager sharedInstance] addMyAttentionLiveId:_liveChannelModel.liveId completion:^(NSError * _Nullable error) {
        
        if (error) {
            [MBProgressHUD showError:@"关注失败！"];//NSLocalizedString
        } else {
            [MBProgressHUD showSuccess:@"关注成功！"];//NSLocalizedString
        }
    }];
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:_liveChannelModel.liveName color:UIColor_navititle];//NSLocalizedString
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
    
    UIImageView *attention = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_mark.png"]];
    attention.centerX = v.width - 25;
    attention.centerY = back.centerY;
    [v addSubview:attention];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:@selector(attention) forControlEvents:UIControlEventTouchUpInside];
    btn2.width = attention.width + 20;
    btn2.height = attention.height + 20;
    btn2.center = attention.center;
    [v addSubview:btn2];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, v.height-0.5, v.width, 0.5)];
    line.backgroundColor = UIColor_line_d2d2d2;
    [v addSubview:line];
    
    return v;
}

- (BOOL)prefersStatusBarHidden
{
    if (landed) {
        return YES;
    } else {
        return NO;
    }
}

- (void)transPlayViewToPortrait {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _playerView.transform = CGAffineTransformMakeRotation(0);
        _playerView.frame = CGRectMake(0, (K_UIScreenHeight-K_UIScreenWidth*3/4)/2, K_UIScreenWidth, K_UIScreenWidth*3/4);
        
        _controlBar.transform = CGAffineTransformMakeRotation(0);
        _controlBar.frame = CGRectMake(0, K_UIScreenHeight-40,K_UIScreenWidth,40);
        _oriBtn.frame = CGRectMake(K_UIScreenWidth-60, 0, 60, 40);
    } completion:^(BOOL finished) {
        if (finished) {
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
    }];
}

- (void)transPlayViewToLandscape {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _playerView.transform = CGAffineTransformMakeRotation(M_PI/2);
        _playerView.frame = CGRectMake(40, 0, K_UIScreenWidth-40 ,K_UIScreenHeight);
        
        _controlBar.transform = CGAffineTransformMakeRotation(M_PI/2);
        _controlBar.frame = CGRectMake(0, 0, 40, K_UIScreenHeight);
        _oriBtn.x = K_UIScreenHeight-60;
    } completion:^(BOOL finished) {
        if (finished) {
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
    }];
}

- (void)changeOrientationChange {
    
    landed = !landed;
    if (landed) {
        [self transPlayViewToLandscape];
    } else {
        [self transPlayViewToPortrait];
    }
}

- (void)playAction {
    
    if (!played) {
        
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN) {
            
            //NSLocalizedString
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您当前在非WIFI状态下，是否继续使用流量观看？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"一会再说" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"继续观看" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.playerView.player play];
                played=YES;
                [self.stateButton setImage:[UIImage imageNamed:@"play_bar_pause.png"] forState:UIControlStateNormal];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        [self.playerView.player play];
        played = YES;
        [self.stateButton setImage:[UIImage imageNamed:@"play_bar_pause.png"] forState:UIControlStateNormal];
        
    } else {
        [self.playerView.player pause];
        played = NO;
        [self.stateButton setImage:[UIImage imageNamed:@"play_bar_play.png"] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *naviBar = [self naviBarView];
    [self.view addSubview:naviBar];
    
    NSURL *videoUrl = [NSURL URLWithString:self.liveChannelModel.livelink];
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerView = [[PlayerView alloc] init];
    _playerView.backgroundColor = [UIColor blackColor];
    self.playerView.player = _player;
    self.playerView.frame = CGRectMake(0, (K_UIScreenHeight-K_UIScreenWidth*3/4)/2, K_UIScreenWidth, K_UIScreenWidth*3/4);
    
    UIImageView *face = [[UIImageView alloc] initWithFrame:CGRectMake(20, _playerView.maxY + 15, 40, 40)];
    face.clipsToBounds = YES;
    face.layer.cornerRadius = face.width/2;
    [self.view addSubview:face];
    [face setImageWithURL:[NSURL URLWithString:_liveChannelModel.anchorImg]];
    
    UILabel *name = [UILabel createLabelWithFrame:CGRectZero text:_liveChannelModel.anchorName textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    [name sizeToFit];
    name.x = face.maxX + 10;
    name.centerY = face.centerY;
    name.width = 200;
    [self.view addSubview:name];
    [self.view addSubview:_playerView];
    
    self.controlBar = [[UIView alloc] initWithFrame:CGRectMake(0, K_UIScreenHeight-40, K_UIScreenWidth, 40)];
    _controlBar.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_controlBar];
    
    self.stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_stateButton setImage:[UIImage imageNamed:@"play_bar_play.png"] forState:UIControlStateNormal];
    [_stateButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    _stateButton.frame = CGRectMake(0, 0, 60, 40);
    [_controlBar addSubview:_stateButton];
    _stateButton.enabled = NO;
    
    self.oriBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_oriBtn setImage:[UIImage imageNamed:@"play_bar_orientation.png"] forState:UIControlStateNormal];
    _oriBtn.frame = CGRectMake(K_UIScreenWidth-60, 0, 60, 40);
    [_oriBtn addTarget:self action:@selector(changeOrientationChange) forControlEvents:UIControlEventTouchUpInside];
    [_controlBar addSubview:_oriBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    if (!played && _stateButton.enabled) {
        [self playAction];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    if (played) {
        
        [self.playerView.player pause];
        played = NO;
    }
    [self.stateButton setImage:[UIImage imageNamed:@"play_bar_play.png"] forState:UIControlStateNormal];
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}

// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            self.stateButton.enabled = YES;
            
            if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi) {
                
                [self playAction];
                played = YES;
            }
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
    }
}

- (void)moviePlayDidEnd:(NSNotification *)notification {
    NSLog(@"Play end");
    
    __weak typeof(self) weakSelf = self;
    [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [weakSelf.stateButton setImage:[UIImage imageNamed:@"play_bar_play.png"] forState:UIControlStateNormal];
        played = NO;
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
