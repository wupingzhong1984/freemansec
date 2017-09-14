//
//  UserLivePlayViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/14.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserLivePlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "Reachability.h"
#import "NTESBundleSetting.h"
#import "NTESChatroomManager.h"
#import "FSChatroomViewController.h"
#import "NTESLoginManager.h"
#import "NELivePlayer.h"
#import "NELivePlayerController.h"

@interface UserLivePlayViewController ()
<NIMChatroomManagerDelegate,
NIMSessionViewControllerDelegate>
{
    BOOL liveStreamOK;
    BOOL isInChatroom;
    BOOL played;
    
}
@property(nonatomic, strong) id<NELivePlayer> liveplayer;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) UILabel *roomPCount;

@property (nonatomic,strong) ChatroomInfoModel *roomInfo;
@property (nonatomic,strong) NSTimer *roomInfoRefreshTimer;
@property (nonatomic,strong) NIMChatroom *chatroom;
@property (nonatomic,strong) NIMChatroomMember *roomMemberMe;
@property (nonatomic,strong) FSChatroomViewController *chatroomViewController;

@property (nonatomic,strong) UIButton *imBtn;
@property (nonatomic,strong) UIButton *markBtn;
@property (nonatomic,strong) UIButton *closeBtn;
@end

@implementation UserLivePlayViewController

- (void)back {
    
    if (isInChatroom) {
        [[[NIMSDK sharedSDK] chatroomManager] exitChatroom:_roomInfo.roomId completion:nil];
    }
    [self.liveplayer shutdown]; // 退出播放并释放相关资源
    [self.liveplayer.view removeFromSuperview];
    self.liveplayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startPlay {
    
    if (!liveStreamOK || played || [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
        return;
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN) {
        
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"notice", nil) message:NSLocalizedString(@"continue playing in 4g", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"wait moment", nil) style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"continue watching", nil) style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.liveplayer play];
            played = YES;
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.liveplayer play];
    played = YES;
    
}

- (void)IMAction {
    
    if (!isInChatroom) {
        //NSLocalizedString
        [self presentViewController:[Utility createNoticeAlertWithContent:NSLocalizedString(@"room error", nil) okBtnTitle:nil] animated:YES completion:nil];
        return;
    }
    
    [self.view sendSubviewToBack:_markBtn];
    [self.view sendSubviewToBack:_imBtn];
    [self.view sendSubviewToBack:_closeBtn];
    
    _chatroomViewController.sessionInputView.hidden = NO;
    [_chatroomViewController.sessionInputView.toolBar.inputTextView becomeFirstResponder];
}


- (void)closeAction {
    
    if (played) {
        
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"notice", nil) message:NSLocalizedString(@"living confirm close", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"alert OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.liveplayer pause];
            played = NO;
            [self back];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"alert cancel", nil) style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        played = NO;
        [self back];
    }
}

- (void)markAction {
    
    if (![_userLiveChannelModel.isAttent boolValue]) {
        
        [[MineManager sharedInstance] addMyAttentionLiveId:_userLiveChannelModel.liveId completion:^(NSError * _Nullable error) {
            
            if (error) {
                [MBProgressHUD showError:NSLocalizedString(@"attention failed", nil)];//NSLocalizedString
            } else {
                [MBProgressHUD showSuccess:NSLocalizedString(@"attention success", nil)];//NSLocalizedString
                _userLiveChannelModel.isAttent = @"1";
                [_markBtn setImage:[UIImage imageNamed:@"live_mark_icon_1.png"] forState:UIControlStateNormal];
                if (_delegate && [_delegate respondsToSelector:@selector(didLiveAttent:)]) {
                    [_delegate didLiveAttent:YES];
                }
            }
        }];
    } else {
        
        [[MineManager sharedInstance] cancelMyAttentionLiveId:_userLiveChannelModel.liveId completion:^(NSError * _Nullable error) {
            
            if (error) {
                [MBProgressHUD showError:NSLocalizedString(@"cancel attention failed", nil)];//NSLocalizedString
            } else {
                [MBProgressHUD showSuccess:NSLocalizedString(@"cancel attention success", nil)];//NSLocalizedString
                _userLiveChannelModel.isAttent = @"0";
                [_markBtn setImage:[UIImage imageNamed:@"live_mark_icon.png"] forState:UIControlStateNormal];
                if (_delegate && [_delegate respondsToSelector:@selector(didLiveAttent:)]) {
                    [_delegate didLiveAttent:NO];
                }
            }
        }];
    }
}

- (void)setupSubViews {
    
    self.liveplayer = [[NELivePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.userLiveChannelModel.rtmpPullUrl]];
    if (self.liveplayer == nil) {
        NSLog(@"player initilize failed, please tay again! url:%@",self.userLiveChannelModel.rtmpPullUrl);
        liveStreamOK = NO;
    }
    self.liveplayer.view.frame = self.view.bounds;
    [self.view addSubview:_liveplayer.view];
    
    
    UIImageView *userBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_userhead_bg_gray.png"]];
    userBg.origin = CGPointMake(32, 35);
    [self.view addSubview:userBg];
    
    UIImageView *userFace = [[UIImageView alloc] init];
    userFace.backgroundColor = [UIColor whiteColor];
    userFace.size = CGSizeMake(40, 40);
    userFace.center = CGPointMake(userBg.x, userBg.centerY);
    userFace.clipsToBounds = YES;
    userFace.layer.cornerRadius = userFace.width/2;
    [userFace sd_setImageWithURL:[NSURL URLWithString:_userLiveChannelModel.headImg]];
    [self.view addSubview:userFace];
    
    UILabel *nameLbl = [UILabel createLabelWithFrame:CGRectZero text:_userLiveChannelModel.nickName textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
    [nameLbl sizeToFit];
    nameLbl.width = 110;
    nameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    nameLbl.x = userFace.maxX + 8;
    nameLbl.centerY = userBg.centerY;
    [self.view addSubview:nameLbl];
    
    UIView *countBg = [[UIView alloc] init];
    countBg.tag = 101;
    countBg.backgroundColor = UIColor_82b432;
    [self.view addSubview:countBg];
    
    UIImageView *countIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_people_count_icon.png"]];
    countIcon.tag = 102;
    [countBg addSubview:countIcon];
    
    self.roomPCount = [UILabel createLabelWithFrame:CGRectZero text:@"0" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
    [_roomPCount sizeToFit];
    [countBg addSubview:_roomPCount];
    
    countBg.size = CGSizeMake(countIcon.width + _roomPCount.width + 30, 20);
    countBg.layer.cornerRadius = countBg.height/2;
    countBg.x = K_UIScreenWidth-20-countBg.width;
    countBg.centerY = userBg.centerY;
    
    countIcon.x = 10;
    countIcon.centerY = countBg.height/2;
    _roomPCount.x = countIcon.maxX + 10;
    _roomPCount.centerY = countIcon.centerY;
    
    self.markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_markBtn setImage:[UIImage imageNamed:[_userLiveChannelModel.isAttent isEqualToString:@"0"]?@"live_mark_icon.png":@"live_mark_icon_1.png"] forState:UIControlStateNormal];
    _markBtn.size = [_markBtn imageForState:UIControlStateNormal].size;
    _markBtn.y = K_UIScreenHeight-48;
    _markBtn.centerX = K_UIScreenWidth/2;
    [_markBtn addTarget:self action:@selector(markAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_markBtn];
    
    self.imBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imBtn setImage:[UIImage imageNamed:@"live_im_icon.png"] forState:UIControlStateNormal];
    _imBtn.size = _markBtn.size;
    _imBtn.y = _markBtn.y;
    _imBtn.x = _markBtn.x - 44;
    [_imBtn addTarget:self action:@selector(IMAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imBtn];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"live_close_icon.png"] forState:UIControlStateNormal];
    _closeBtn.size = _imBtn.size;
    _closeBtn.y = _markBtn.y;
    _closeBtn.x = _markBtn.x + 44;
    [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    
//    if(!liveStreamOK) {
//
//        [self presentViewController:[Utility createNoticeAlertWithContent:@"此频道暂时无法播放。" okBtnTitle:nil] animated:YES completion:nil];
//        return;
//    }
    
    [[LiveManager sharedInstance] queryLiveDetailByCId:_userLiveChannelModel.cid completion:^(LiveDetailNTModel * _Nullable detailModel, NSError * _Nullable error) {
        
        if (error || !detailModel || (![detailModel.status isEqualToString:@"1"] &&
                                      ![detailModel.status isEqualToString:@"3"])) {
            liveStreamOK = NO;
            [self presentViewController:[Utility createNoticeAlertWithContent:@"此频道当前未在直播中。" okBtnTitle:nil] animated:YES completion:nil];
            return;
            
        } else {
            
            
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
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mediaType = @"livestream";
    
    [self setupSubViews];
    
    [self requestGetLiveRoomInfo];
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

    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(backgroundStopLiveStream:)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(callEnterForeground:)
//                                                 name:UIApplicationWillEnterForegroundNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNetworkConnectChanged:) name:kReachabilityChangedNotification object:nil];
    
    [self startPlay];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    [self.liveplayer pause];
    played = NO;
    
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

- (void)requestGetLiveRoomInfo {
    
    [[LiveManager sharedInstance] getChatroomByUserLiveId:_userLiveChannelModel.liveId completion:^(ChatroomInfoModel * _Nullable roomModel, NSError * _Nullable error) {
        
        if (error || !roomModel) {
            
            //NSLocalizedString
            [self presentViewController:[Utility createErrorAlertWithContent:NSLocalizedString(@"room error", nil) okBtnTitle:nil] animated:YES completion:nil];
            
        } else {
            
            self.roomInfo = roomModel;
            [self enterChatRoom];
        }
    }];
}

- (void)enterChatRoom {
    
    
    [[[NIMSDK sharedSDK] loginManager] login:[[MineManager sharedInstance] IMToken].accId
                                       token:[[MineManager sharedInstance] IMToken].token
                                  completion:^(NSError *error) {
                                      
                                      if (error == nil)
                                      {
                                          LoginData *sdkData = [[LoginData alloc] init];
                                          sdkData.account   = [[MineManager sharedInstance] IMToken].accId;
                                          sdkData.token     = [[MineManager sharedInstance] IMToken].token;
                                          [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                                          
                                          [[NTESServiceManager sharedManager] start];
                                          
                                          MyInfoModel *myInfo = [[MineManager sharedInstance] getMyInfo];
                                          
                                          NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
                                          request.roomId = _roomInfo.roomId;
                                          request.roomNickname = myInfo.nickName;
                                          request.roomAvatar = myInfo.headImg;
                                          request.retryCount = [[NTESBundleSetting sharedConfig] chatroomRetryCount];
                                          [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                          __weak typeof(self) wself = self;
                                          [[[NIMSDK sharedSDK] chatroomManager] enterChatroom:request
                                                                                   completion:^(NSError *error,NIMChatroom *chatroom,NIMChatroomMember *me) {
                                                                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                       
                                                                                       if (error == nil)
                                                                                       {
                                                                                           self.chatroom = chatroom;
                                                                                           self.roomMemberMe = me;
                                                                                           [[NTESChatroomManager sharedInstance] cacheMyInfo:me roomId:chatroom.roomId];
                                                                                           
                                                                                           self.chatroomViewController = [[FSChatroomViewController alloc] initWithChatroom:chatroom withRect:CGRectMake(0,K_UIScreenHeight-(667/2+60), K_UIScreenWidth, 667/2+60)];
                                                                                           _chatroomViewController.delegate = self;                                                                                               _chatroomViewController.sessionInputView.hidden = YES;                                 [self.view addSubview:_chatroomViewController.view];
                                                                                           
                                                                                           [self.view bringSubviewToFront:_imBtn];
                                                                                           [self.view bringSubviewToFront:_markBtn];
                                                                                           [self.view bringSubviewToFront:_closeBtn];
                                                                                           
                                                                                           isInChatroom = YES;
                                                                                       }
                                                                                       else
                                                                                       {
                                                                                           isInChatroom = NO;
                                                                                           [self.view bringSubviewToFront:_imBtn];
                                                                                           [self.view bringSubviewToFront:_markBtn];
                                                                                           [self.view bringSubviewToFront:_closeBtn];
                                                                                           NSString *toast = [NSString stringWithFormat:@"进入聊天室失败 code:%zd",error.code];
                                                                                           [wself.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                                                                           NNSLog(@"enter room %@ failed %@",chatroom.roomId,error);
                                                                                       }
                                                                                       
                                                                                   }];
                                          
                                      }
                                      else
                                      {
                                          isInChatroom = NO;
                                          [self.view bringSubviewToFront:_imBtn];
                                          [self.view bringSubviewToFront:_markBtn];
                                          [self.view bringSubviewToFront:_closeBtn];
                                          NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];
                                          [self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                      }
                                  }];
}

- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification {
    
    NSLog(@"NELivePlayerDidPreparedToPlay");
    liveStreamOK = YES;
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi) {
        
        [self.liveplayer play];
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
            if ([self.mediaType isEqualToString:@"livestream"]) {
                alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"notice", nil) message:@"该直播已停止。" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"alert OK", nil) style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.liveplayer pause];
                    played = NO;
                    //  [self back];
                    
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            break;
            
        case NELPMovieFinishReasonPlaybackError:
        {
            alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"notice", nil) message:NSLocalizedString(@"play failed", nil) preferredStyle:UIAlertControllerStyleAlert];
            action = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                [self.liveplayer pause];
                played = NO;
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
            
        case NELPMovieFinishReasonUserExited:
            [self.liveplayer pause];
            played = NO;
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

-(void)NIMSessionViewControllerDelegateEndEditing {
    
    _chatroomViewController.sessionInputView.hidden = YES;
    [self.view bringSubviewToFront:_markBtn];
    [self.view bringSubviewToFront:_imBtn];
    [self.view bringSubviewToFront:_closeBtn];
}
@end
