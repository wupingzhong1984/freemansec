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
#import "PlayerView.h"
#import "NTESBundleSetting.h"
#import "NTESChatroomManager.h"

@interface UserLivePlayViewController ()
{
    BOOL liveStreamOK;
    BOOL isInChatroom;
    BOOL played;
    
}
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) PlayerView *playerView;
@property (nonatomic, strong) UILabel *roomPCount;

@property (nonatomic,strong) ChatroomInfoModel *roomInfo;
@property (nonatomic,strong) NSTimer *roomInfoRefreshTimer;
@property (nonatomic,strong) NIMChatroom *chatroom;
@property (nonatomic,strong) NIMChatroomMember *roomMemberMe;
@end

@implementation UserLivePlayViewController

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startPlay {
    
    if (!liveStreamOK || played || [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) return;
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN) {
        
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您当前在非WIFI状态下，是否继续使用流量观看？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"一会再说" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续观看" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.playerView.player play];
            played = YES;
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.playerView.player play];
    played = YES;
    
}

- (void)enterChatRoom {
    
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
                                                     isInChatroom = YES;
                                                     
                                                     //todo
                                                     //load chatroom view
                                                 }
                                                 else
                                                 {
                                                     NSString *toast = [NSString stringWithFormat:@"进入失败 code:%zd",error.code];
                                                     [wself.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                                     NNSLog(@"enter room %@ failed %@",chatroom.roomId,error);
                                                 }
                                                 
                                             }];
}

- (void)closeAction {
    
    if (played) {
        
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"正在观看直播，是否确定退出？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.playerView.player pause];
            played = NO;
            [[[NIMSDK sharedSDK] chatroomManager] exitChatroom:_roomInfo.roomId completion:nil];
            [self back];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        played = NO;
        [[[NIMSDK sharedSDK] chatroomManager] exitChatroom:_roomInfo.roomId completion:nil];
        [self back];
    }
}

- (void)IMAction {
    
    if (!isInChatroom) {
        //NSLocalizedString
        [self presentViewController:[Utility createNoticeAlertWithContent:@"聊天室异常，暂时无法聊天。" okBtnTitle:nil] animated:YES completion:nil];
        return;
    }
    
    //todo
//    [self.view addSubview:self.inputView];
//    [_inputTF becomeFirstResponder];
}

- (void)setupSubViews {
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerView = [[PlayerView alloc] init];
    _playerView.backgroundColor = [UIColor blackColor];
    self.playerView.player = _player;
    self.playerView.frame = self.view.bounds;
    [self.view addSubview:_playerView];
    UIImageView *userBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_userhead_bg_gray.png"]];
    userBg.origin = CGPointMake(32, 35);
    [self.view addSubview:userBg];
    
    UIImageView *userFace = [[UIImageView alloc] init];
    userFace.backgroundColor = [UIColor whiteColor];
    userFace.size = CGSizeMake(40, 40);
    userFace.center = CGPointMake(userBg.x, userBg.centerY);
    userFace.clipsToBounds = YES;
    userFace.layer.cornerRadius = userFace.width/2;
    [userFace setImageWithURL:[NSURL URLWithString:[[MineManager sharedInstance] getMyInfo].headImg]];
    [self.view addSubview:userFace];
    
    UILabel *nameLbl = [UILabel createLabelWithFrame:CGRectZero text:[[MineManager sharedInstance] getMyInfo].nickName textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
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
    
    UIButton *imBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imBtn setImage:[UIImage imageNamed:@"live_im_icon.png"] forState:UIControlStateNormal];
    imBtn.size = [imBtn imageForState:UIControlStateNormal].size;
    imBtn.y = K_UIScreenHeight-48;
    imBtn.centerX = K_UIScreenWidth/2-44;
    [imBtn addTarget:self action:@selector(IMAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imBtn];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"live_close_icon.png"] forState:UIControlStateNormal];
    closeBtn.size = imBtn.size;
    closeBtn.y = imBtn.y;
    closeBtn.centerX = K_UIScreenWidth/2 + 44;
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSURL *videoUrl = [NSURL URLWithString:self.userLiveChannelModel.rtmpPullUrl];
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    
    [self setupSubViews];
    
    //todo
    //get roomid
    [self enterChatRoom];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(livePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    
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
    
    [self.playerView.player pause];
    played = NO;
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            liveStreamOK = YES;
            
            if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi) {
                
                [self.playerView.player play];
                played = YES;
                
            } else if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN) {
                
                //NSLocalizedString
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您当前在非WIFI状态下，是否继续使用流量观看？" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"一会再说" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"继续观看" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.playerView.player play];
                    played = YES;
                    
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            //NSLocalizedString
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该频道暂时无法观看。" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self back];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
    }
}

- (void)livePlayDidEnd:(NSNotification *)notification {
    NSLog(@"Play end");
    
    [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该直播已停止。" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self back];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
