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
#import "NELivePlayer.h"
#import "NELivePlayerController.h"

//#import "IMYWebView.h"

@interface LivePlayViewController ()
{
    BOOL played;
    BOOL landed;
}

@property(nonatomic, strong) id<NELivePlayer> liveplayer;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) UIView *controlBar;
@property (nonatomic, strong) UIImageView *attentionIV;
@property (nonatomic ,strong) UIButton *stateButton;
@property (nonatomic ,strong) UIButton *oriBtn;
@end

@implementation LivePlayViewController

- (void)back {
    
    [self.liveplayer shutdown]; // 退出播放并释放相关资源
    [self.liveplayer.view removeFromSuperview];
    self.liveplayer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)attention {
    
    if (![_liveChannelModel.isAttent boolValue]) {
        
        [[MineManager sharedInstance] addMyAttentionLiveId:_liveChannelModel.liveId completion:^(NSError * _Nullable error) {
            
            if (error) {
                [MBProgressHUD showError:@"关注失败！"];//NSLocalizedString
            } else {
                [MBProgressHUD showSuccess:@"关注成功！"];//NSLocalizedString
                _liveChannelModel.isAttent = @"1";
                [_attentionIV setImage:[UIImage imageNamed:@"navi_mark_1.png"]];
                if (_delegate && [_delegate respondsToSelector:@selector(didLiveAttent:)]) {
                    [_delegate didLiveAttent:YES];
                }
            }
        }];
    } else {
        
        [[MineManager sharedInstance] cancelMyAttentionLiveId:_liveChannelModel.liveId completion:^(NSError * _Nullable error) {
            
            if (error) {
                [MBProgressHUD showError:@"取消关注失败！"];//NSLocalizedString
            } else {
                [MBProgressHUD showSuccess:@"取消关注成功！"];//NSLocalizedString
                _liveChannelModel.isAttent = @"0";
                [_attentionIV setImage:[UIImage imageNamed:@"navi_mark.png"]];
                if (_delegate && [_delegate respondsToSelector:@selector(didLiveAttent:)]) {
                    [_delegate didLiveAttent:NO];
                }
            }
        }];

    }
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:_liveChannelModel.liveName color:UIColor_navititle];
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
    
    self.attentionIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_liveChannelModel.isAttent isEqualToString:@"0"]?@"navi_mark.png":@"navi_mark_1.png"]];
    _attentionIV.centerX = v.width - 25;
    _attentionIV.centerY = back.centerY;
    [v addSubview:_attentionIV];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:@selector(attention) forControlEvents:UIControlEventTouchUpInside];
    btn2.width = _attentionIV.width + 20;
    btn2.height = _attentionIV.height + 20;
    btn2.center = _attentionIV.center;
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
        
        _liveplayer.view.transform = CGAffineTransformMakeRotation(0);
        _liveplayer.view.frame = CGRectMake(0, (K_UIScreenHeight-K_UIScreenWidth*3/4)/2, K_UIScreenWidth, K_UIScreenWidth*3/4);
        
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
        
        _liveplayer.view.transform = CGAffineTransformMakeRotation(M_PI/2);
        _liveplayer.view.frame = CGRectMake(40, 0, K_UIScreenWidth-40 ,K_UIScreenHeight);
        
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
                
                [self.liveplayer play];
                played=YES;
                [self.stateButton setImage:[UIImage imageNamed:@"play_bar_pause.png"] forState:UIControlStateNormal];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        [self.liveplayer play];
        played = YES;
        [self.stateButton setImage:[UIImage imageNamed:@"play_bar_pause.png"] forState:UIControlStateNormal];
        
    } else {
        [self.liveplayer pause];
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
    
    self.mediaType = @"livestream";
    self.liveplayer = [[NELivePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.liveChannelModel.livelink]];
    if (self.liveplayer == nil) {
        NSLog(@"player initilize failed, please tay again! url:%@",self.liveChannelModel.livelink);
    }
    self.liveplayer.view.frame = CGRectMake(0, (K_UIScreenHeight-K_UIScreenWidth*3/4)/2, K_UIScreenWidth, K_UIScreenWidth*3/4);
    _liveplayer.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *face = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.liveplayer.view.maxY + 15, 40, 40)];
    face.clipsToBounds = YES;
    face.layer.cornerRadius = face.width/2;
    [self.view addSubview:face];
    [face sd_setImageWithURL:[NSURL URLWithString:_liveChannelModel.anchorImg]];
    
    UILabel *name = [UILabel createLabelWithFrame:CGRectZero text:_liveChannelModel.anchorName textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    [name sizeToFit];
    name.x = face.maxX + 10;
    name.centerY = face.centerY;
    name.width = 200;
    [self.view addSubview:name];
    [self.view addSubview:_liveplayer.view];
    
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
    
    if ([self.mediaType isEqualToString:@"livestream"] ) {
        [self.liveplayer setBufferStrategy:NELPLowDelay]; // 直播低延时模式
    }
    else {
        [self.liveplayer setBufferStrategy:NELPAntiJitter]; // 点播抗抖动
    }
    [self.liveplayer setScalingMode:NELPMovieScalingModeNone]; // 设置画面显示模式，默认原始大小
    [self.liveplayer setShouldAutoplay:([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi)]; // 设置prepareToPlay完成后是否自动播放
    [self.liveplayer setHardwareDecoder:YES]; // 设置解码模式，是否开启硬件解码
    [self.liveplayer setPauseInBackground:NO]; // 设置切入后台时的状态，暂停还是继续播放
    [self.liveplayer setPlaybackTimeout:15 *1000]; // 设置拉流超时时间
    [self.liveplayer prepareToPlay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlaybackStateChanged:)
                                                 name:NELivePlayerPlaybackStateChangedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NeLivePlayerloadStateChanged:)
                                                 name:NELivePlayerLoadStateChangedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlayBackFinished:)
                                                 name:NELivePlayerPlaybackFinishedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstVideoDisplayed:)
                                                 name:NELivePlayerFirstVideoDisplayedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstAudioDisplayed:)
                                                 name:NELivePlayerFirstAudioDisplayedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerReleaseSuccess:)
                                                 name:NELivePlayerReleaseSueecssNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerVideoParseError:)
                                                 name:NELivePlayerVideoParseErrorNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerSeekComplete:)
                                                 name:NELivePlayerMoviePlayerSeekCompletedNotification
                                               object:_liveplayer];

//    if (!played && _stateButton.enabled) {
//        [self playAction];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    if (played) {
        
        [self.stateButton setImage:[UIImage imageNamed:@"play_bar_play.png"] forState:UIControlStateNormal];
        [self.liveplayer pause];
        played = NO;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerDidPreparedToPlayNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerPlaybackStateChangedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerLoadStateChangedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerPlaybackFinishedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerFirstVideoDisplayedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerFirstAudioDisplayedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerReleaseSueecssNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerVideoParseErrorNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerMoviePlayerSeekCompletedNotification object:_liveplayer];
}

- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification {
    
    NSLog(@"NELivePlayerDidPreparedToPlay");
    
    self.stateButton.enabled = YES;
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi) {
        
        [self playAction];
        played = YES;
    } else if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN) {
        
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您当前在非WIFI状态下，是否继续使用流量观看？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"一会再说" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续观看" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.liveplayer play];
            played = YES;
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)NELivePlayerPlaybackStateChanged:(NSNotification*)notification
{
    //    NSLog(@"NELivePlayerPlaybackStateChanged");
}

- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification
{
    
}

- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification
{
    UIAlertController *alertController = NULL;
    UIAlertAction *action = NULL;
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:
        {
            if ([self.mediaType isEqualToString:@"livestream"]) {
                alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"直播结束" preferredStyle:UIAlertControllerStyleAlert];
                action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        [self back];
                    }];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            break;
        }
        case NELPMovieFinishReasonPlaybackError:
        {
            alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"播放失败" preferredStyle:UIAlertControllerStyleAlert];
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self back];
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
            
        case NELPMovieFinishReasonUserExited:
            break;
            
        default:
            break;
    }
}

- (void)NELivePlayerFirstVideoDisplayed:(NSNotification*)notification
{
    NSLog(@"first video frame rendered!");
}

- (void)NELivePlayerFirstAudioDisplayed:(NSNotification*)notification
{
    NSLog(@"first audio frame rendered!");
}

- (void)NELivePlayerVideoParseError:(NSNotification*)notification
{
    NSLog(@"video parse error!");
}

- (void)NELivePlayerSeekComplete:(NSNotification*)notification
{
    NSLog(@"seek complete!");
}

- (void)NELivePlayerReleaseSuccess:(NSNotification*)notification
{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerReleaseSueecssNotification object:_liveplayer];
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
