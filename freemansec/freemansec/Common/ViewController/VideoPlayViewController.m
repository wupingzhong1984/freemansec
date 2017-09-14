//
//  VideoPlayViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/16.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VideoPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "Reachability.h"
#import "NELivePlayer.h"
#import "NELivePlayerController.h"

@interface VideoPlayViewController ()
{
    BOOL played;
}
@property(nonatomic, strong) id<NELivePlayer> liveplayer;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) UIView *controlBar;
@property (nonatomic ,strong) UIButton *stateButton;

@end
@implementation VideoPlayViewController

- (void)back {
    
    [self.liveplayer shutdown]; // 退出播放并释放相关资源
    [self.liveplayer.view removeFromSuperview];
    self.liveplayer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)favous {
    
    if (![[MineManager sharedInstance] getMyInfo]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadUserLogin object:nil];
        return;
    }
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *title = [self commNaviTitle:_videoModel.videoName color:UIColor_navititle];
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
    
    //todo
    //收藏
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, v.height-0.5, v.width, 0.5)];
    line.backgroundColor = UIColor_line_d2d2d2;
    [v addSubview:line];
    
    return v;
}

- (void)playAction {
    
    if (!played) {
        
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN) {
            
            //NSLocalizedString
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"notice", nil) message:NSLocalizedString(@"continue playing in 4g", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"wait moment", nil) style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"continue watching", nil) style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.liveplayer play];
                played=YES;
                [[VideoManager sharedInstance] addVideoPlayCount:_videoModel.videoId completion:nil];
                [self.stateButton setImage:[UIImage imageNamed:@"play_bar_pause.png"] forState:UIControlStateNormal];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        [self.liveplayer play];
        played=YES;
        [[VideoManager sharedInstance] addVideoPlayCount:_videoModel.videoId completion:nil];
        [self.stateButton setImage:[UIImage imageNamed:@"play_bar_pause.png"] forState:UIControlStateNormal];
        
    } else {
        [self.liveplayer pause];
        played=NO;
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
    self.liveplayer = [[NELivePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.videoModel.videoOrigUrl]];
    if (self.liveplayer == nil) {
        NSLog(@"player initilize failed, please tay again! url:%@",self.videoModel.videoOrigUrl);
    }
    self.liveplayer.view.frame = CGRectMake(0, naviBar.maxY, K_UIScreenWidth, K_UIScreenHeight - naviBar.maxY - 40);
    [self.view addSubview:_liveplayer.view];
    
    UIImageView *userBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_userhead_bg_gray.png"]];
    userBg.origin = CGPointMake(32, _liveplayer.view.y + 35);
    [self.view addSubview:userBg];
    
    UIImageView *userFace = [[UIImageView alloc] init];
    userFace.backgroundColor = [UIColor whiteColor];
    userFace.size = CGSizeMake(40, 40);
    userFace.center = CGPointMake(userBg.x, userBg.centerY);
    userFace.clipsToBounds = YES;
    userFace.layer.cornerRadius = userFace.width/2;
    [userFace sd_setImageWithURL:[NSURL URLWithString:_videoModel.headImg]];
    [self.view addSubview:userFace];
    
    UILabel *nameLbl = [UILabel createLabelWithFrame:CGRectZero text:_videoModel.authorName textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
    [nameLbl sizeToFit];
    nameLbl.width = 110;
    nameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    nameLbl.x = userFace.maxX + 8;
    nameLbl.centerY = userBg.centerY;
    [self.view addSubview:nameLbl];

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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"notice", nil) message:NSLocalizedString(@"continue playing in 4g", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"wait moment", nil) style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"continue watching", nil) style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
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
            [self.liveplayer pause];
            played=NO;
            [self.stateButton setImage:[UIImage imageNamed:@"play_bar_play.png"] forState:UIControlStateNormal];
            alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"notice", nil) message:@"视频结束" preferredStyle:UIAlertControllerStyleAlert];
            action = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert OK", nil) style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
        case NELPMovieFinishReasonPlaybackError:
        {
            [self.liveplayer pause];
            played=NO;
            [self.stateButton setImage:[UIImage imageNamed:@"play_bar_play.png"] forState:UIControlStateNormal];
            alertController = [UIAlertController alertControllerWithTitle:@"注意" message:NSLocalizedString(@"play failed", nil) preferredStyle:UIAlertControllerStyleAlert];
            action = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert OK", nil) style:UIAlertActionStyleDefault handler:nil];
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


@end
