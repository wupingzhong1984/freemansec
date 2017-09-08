//
//  UserLiveRootViewController.m
//  freemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserLiveRootViewController.h"
#import "UpdateUserLiveTitleView.h"
#import "NEMediaCaptureEntity.h"
#import "NEAuthorizeManager.h"
#import "NEReachability.h"
#import "MyInfoModel.h"
#import "NTESBundleSetting.h"
#import "NTESChatroomManager.h"
#import "FSChatroomViewController.h"
#import "NTESLoginManager.h"

@interface UserLiveRootViewController ()
<NIMChatroomManagerDelegate,
NIMSessionViewControllerDelegate>{
    
    LSVideoParaCtx paraCtx;
    BOOL _isLiving;//是否正在直播
    BOOL _needStartLive;//是否需要开启直播
    LSCameraPosition _isBackCameraPosition;//前置或后置摄像头
//    BOOL _isRecording;//是否正在录制
    
    BOOL _isAccess;
    
//    BOOL keyboardDidShow;
    
    BOOL isInChatroom;

}
@property (nonatomic,strong) UILabel *roomPCount;

@property (nonatomic,strong) NSString *pushUrl;

@property (nonatomic,strong) UpdateUserLiveTitleView *updateUserLiveTitleView;

//直播SDK API
@property (nonatomic,strong) LSMediaCapture *mediaCapture;
@property (nonatomic, strong) UIView *localPreview;//相机预览视图

@property (nonatomic,strong) ChatroomInfoModel *roomInfo;
@property (nonatomic,strong) NSTimer *roomInfoRefreshTimer;
@property (nonatomic,strong) NIMChatroom *chatroom;
@property (nonatomic,strong) NIMChatroomMember *roomMemberMe;
@property (nonatomic,strong) FSChatroomViewController *chatroomViewController;

@property (nonatomic,strong) UIButton *imBtn;
@property (nonatomic,strong) UIButton *cameraBtn;
@property (nonatomic,strong) UIButton *closeBtn;
@end

@implementation UserLiveRootViewController

- (void)back {
    
    [_roomInfoRefreshTimer invalidate];
    if (isInChatroom) {
        [[[NIMSDK sharedSDK] chatroomManager] exitChatroom:_roomInfo.roomId completion:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showErrorAlert:(NSError*)error {
    NSString *errMsg = @"";
    if(error == nil){
        errMsg = @"推流过程中发生错误，请尝试重新开启";
        
    }else if([error class] == [NSError class]){
        errMsg = [error localizedDescription];
    }else{
        NSLog(@"error = %@", error);
    }
    
    _isLiving = NO;
    
    [self presentViewController:[Utility createErrorAlertWithContent:errMsg okBtnTitle:nil] animated:YES completion:nil];
}

- (void)unInitLiveStream{
    //释放占有的系统资源
    [_mediaCapture unInitLiveStream];
    _mediaCapture = nil;
}

- (void)cameraSwitchAction {
    
    _isBackCameraPosition = [_mediaCapture switchCamera:^{
        NSLog(@"切换摄像头");
    }];
}

- (void)IMAction {
    
    if (!isInChatroom) {
        //NSLocalizedString
        [self presentViewController:[Utility createNoticeAlertWithContent:@"聊天室异常" okBtnTitle:nil] animated:YES completion:nil];
        return;
    }
    
    [self.view sendSubviewToBack:_cameraBtn];
    [self.view sendSubviewToBack:_imBtn];
    [self.view sendSubviewToBack:_closeBtn];
    
    _chatroomViewController.sessionInputView.hidden = NO;
    [_chatroomViewController.sessionInputView.toolBar.inputTextView becomeFirstResponder];
    
}

- (void)closeAction {
    
    if (_isLiving) {
        
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前正在直播，是否确定退出？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __weak UserLiveRootViewController *weakSelf = self;
            [_mediaCapture stopLiveStream:^(NSError *error) {
                [[UserLiveManager sharedInstance] closeLivePushCompletion:^(NSError * _Nullable error) {
                    
                }];
                [weakSelf unInitLiveStream];
                [weakSelf back];
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
       
        [self unInitLiveStream];
        [self back];
    }
}

- (void)initLSVideoParaCtxAndCamera {
    
    [NEMediaCaptureEntity sharedInstance].encodeType = 0;
    //默认高清 以后可根据网络状况比如wifi或4G或3G来建议用户选择不同质量
    paraCtx.interfaceOrientation = LS_CAMERA_ORIENTATION_PORTRAIT;
    paraCtx.cameraPosition = LS_CAMERA_POSITION_FRONT;
    paraCtx.bitrate = 500000;
    paraCtx.fps = 15;    //fps ,就是帧率，建议在10~24之间
    paraCtx.videoStreamingQuality = LS_VIDEO_QUALITY_HIGH;
    paraCtx.isCameraZoomPinchGestureOn = YES;
    paraCtx.isCameraFlashEnabled = YES;
    paraCtx.isVideoFilterOn = NO;
    paraCtx.filterType = LS_GPUIMAGE_ZIRAN;
    paraCtx.isQosOn = YES;
    paraCtx.isFrontCameraMirroredPreView = YES;
    paraCtx.isFrontCameraMirroredCode = NO;
    paraCtx.isVideoWaterMarkEnabled = YES;
    paraCtx.videoRenderMode = LS_VIDEO_RENDER_MODE_SCALE_16x9;//默认设置为16:9
    paraCtx.codec = LS_VIDEO_CODEC_H264;
    [NEMediaCaptureEntity sharedInstance].videoParaCtx = paraCtx;
    
    _needStartLive = NO;
    _isLiving = NO;
    _isAccess = YES;
//    _isRecording = NO;
}

- (void)setupSubviews {
    
    //====================视频预览====================//
    self.localPreview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreenWidth,  K_UIScreenHeight)];
    self.localPreview.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:_localPreview atIndex:0];
    
    UIImageView *userBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_userhead_bg_gray.png"]];
    userBg.origin = CGPointMake(32, 35);
    [self.view addSubview:userBg];
    
    UIImageView *userFace = [[UIImageView alloc] init];
    userFace.backgroundColor = [UIColor whiteColor];
    userFace.size = CGSizeMake(40, 40);
    userFace.center = CGPointMake(userBg.x, userBg.centerY);
    userFace.clipsToBounds = YES;
    userFace.layer.cornerRadius = userFace.width/2;
    [userFace sd_setImageWithURL:[NSURL URLWithString:[[MineManager sharedInstance] getMyInfo].headImg]];
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
    
    self.imBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imBtn setImage:[UIImage imageNamed:@"live_im_icon.png"] forState:UIControlStateNormal];
    _imBtn.size = [_imBtn imageForState:UIControlStateNormal].size;
    _imBtn.y = K_UIScreenHeight-48;
    _imBtn.centerX = K_UIScreenWidth/2;
    [_imBtn addTarget:self action:@selector(IMAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imBtn];
    
    self.cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cameraBtn setImage:[UIImage imageNamed:@"live_camera_icon.png"] forState:UIControlStateNormal];
    _cameraBtn.size = _imBtn.size;
    _cameraBtn.y = _imBtn.y;
    _cameraBtn.x = _imBtn.x - 44;
    [_cameraBtn addTarget:self action:@selector(cameraSwitchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraBtn];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"live_close_icon.png"] forState:UIControlStateNormal];
    _closeBtn.size = _imBtn.size;
    _closeBtn.y = _imBtn.y;
    _closeBtn.x = _imBtn.x + 44;
    [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    
    //请注意：监听对象已修改，不再是_mediaCapture，同时去除原先的SDK_dellloc通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onStartLiveStream:) name:LS_LiveStreaming_Started object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFinishedLiveStream:) name:LS_LiveStreaming_Finished object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onBadNetworking:) name:LS_LiveStreaming_Bad object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundStopLiveStream:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNetworkConnectChanged:) name:ne_kReachabilityChangedNotification object:nil];
    
    
}

-(void)LiveStreamErrorInterrup{
    [_mediaCapture stopLiveStream:^(NSError *error) {
        if (error == nil) {
            [[UserLiveManager sharedInstance] closeLivePushCompletion:^(NSError * _Nullable error) {
                
            }];
            dispatch_async(dispatch_get_main_queue(), ^(void){[self showErrorAlert:error];});
        }
    }];
}

- (void)startPush {
    
    //初始化直播参数，并创建音视频直播
    LSLiveStreamingParaCtx streamparaCtx;
    NSUInteger encodeType = [NEMediaCaptureEntity sharedInstance].encodeType;
    switch (encodeType) {
        case 0:
            streamparaCtx.eHaraWareEncType = LS_HRD_NO;
            break;
        case 2:
            streamparaCtx.eHaraWareEncType = LS_HRD_VIDEO;
            break;
        default:
            streamparaCtx.eHaraWareEncType = LS_HRD_NO;
            break;
    }
    streamparaCtx.eOutFormatType               = LS_OUT_FMT_RTMP;
    streamparaCtx.eOutStreamType               = LS_HAVE_AV; //这里可以设置推音视频流／音频流／视频流，如果只推送视频流，则不支持伴奏播放音乐
    streamparaCtx.uploadLog                    = YES;//是否上传sdk日志
    
    streamparaCtx.sLSVideoParaCtx = [NEMediaCaptureEntity sharedInstance].videoParaCtx;
    streamparaCtx.sLSAudioParaCtx.bitrate       = 64000;
    streamparaCtx.sLSAudioParaCtx.codec         = LS_AUDIO_CODEC_AAC;
    streamparaCtx.sLSAudioParaCtx.frameSize     = 2048;
    streamparaCtx.sLSAudioParaCtx.numOfChannels = 1;
    streamparaCtx.sLSAudioParaCtx.samplerate    = 44100;
    
    _mediaCapture = [[LSMediaCapture alloc]initLiveStream:_pushUrl withLivestreamParaCtx:streamparaCtx];
    if (_mediaCapture == nil) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"初始化失败" forKey:NSLocalizedDescriptionKey];
        [self showErrorAlert:[NSError errorWithDomain:@"LSMediaCaptureErrorDomain" code:0 userInfo:userInfo]];
    }
    
    BOOL success = YES;
    success = [[NEAuthorizeManager sharedInstance] requestMediaCapturerAccessWithCompletionHandler:^(BOOL value, NSError* error){
        if (error) {
            [self showErrorAlert:error];
        }
    }];
    if (success == NO) {
        _isAccess = NO;
        return;
    }
    
    if (streamparaCtx.eOutStreamType != LS_HAVE_AUDIO) {
        //打开摄像头预览
        [_mediaCapture startVideoPreview:self.localPreview];
    }
    
    
    [_mediaCapture getSDKVersionID];
    
    _mediaCapture.onZoomScaleValueChanged = ^(CGFloat value)
    {
        
    };

    if (_isAccess) {
        
        if(!_isLiving)
        {
            //直播开始之前，需要设置直播出错反馈回调，当然也可以不设置
            __weak UserLiveRootViewController *weakSelf = self;
            _mediaCapture.onLiveStreamError = ^(NSError* error){
                if (error != nil) {
                    [weakSelf LiveStreamErrorInterrup];
                }
            };
            //调用统计数据回调
//            _mediaCapture.onStatisticInfoGot = ^(LSStatistics* statistics){
//                if (statistics != nil) {
//                    LSStatistics statis;
//                    memcpy(&statis, statistics, sizeof(LSStatistics));
//                    dispatch_async(dispatch_get_main_queue(),^(void){[weakSelf showStatInfo:statis];});
//                }
//            };
            //开始直播
            NSError *__autoreleasing error = nil;
            [_mediaCapture startLiveStreamWithError:&error];
            if (error != nil) {
                [weakSelf showErrorAlert:error ];
            }
        }
    }
}

- (void)updateUserLiveTitleViewCancel {
    
    [_updateUserLiveTitleView.titleTF resignFirstResponder];
    [_updateUserLiveTitleView removeFromSuperview];
    [self back];
}

- (void)updateUserLiveTitleViewStartLive {
    
    if (!_updateUserLiveTitleView.titleTF.text.length) {
        [self presentViewController:[Utility createNoticeAlertWithContent:@"请输入标题" okBtnTitle:nil] animated:YES completion:nil];
        return;
    }
    
    [_updateUserLiveTitleView.titleTF resignFirstResponder];
    [self requestLiveTitle:_updateUserLiveTitleView.titleTF.text];
}

- (void)updateRoomUserCount {
    
    UIView *v1 = [self.view viewWithTag:101];
    UIView *v2 = [self.view viewWithTag:102];
    _roomPCount.text = _roomInfo.onlineUserCount;
    [_roomPCount sizeToFit];
    
    v1.width = _roomPCount.width + v2.width + 30;
    v1.x = K_UIScreenWidth - 20 - v1.width;
    v2.x = 10;
    _roomPCount.x = v2.maxX + 10;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置常亮不锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initLSVideoParaCtxAndCamera];
    [self setupSubviews];
    
    //test
//    self.pushUrl = [[MineManager sharedInstance] getMyInfo].pushUrl;
//    [self startPush];
//    [self requestGetChatRoomWhenLiveStart];
//    return;
    
    self.updateUserLiveTitleView = [[UpdateUserLiveTitleView alloc] init];
    _updateUserLiveTitleView.titleTF.text = [[MineManager sharedInstance] getMyInfo].liveTitle;
    _updateUserLiveTitleView.roomIdLbl.text = [NSString stringWithFormat:@"房间号%@",[[MineManager sharedInstance] getMyInfo].liveId];
    [_updateUserLiveTitleView.bgBtn addTarget:self action:@selector(updateUserLiveTitleViewCancel) forControlEvents:UIControlEventTouchUpInside];
    [_updateUserLiveTitleView.cancelBtn addTarget:self action:@selector(updateUserLiveTitleViewCancel) forControlEvents:UIControlEventTouchUpInside];
    [_updateUserLiveTitleView.startLiveBtn addTarget:self action:@selector(updateUserLiveTitleViewStartLive) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_updateUserLiveTitleView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)requestLiveTitle:(NSString*)title {
    
    [[MineManager sharedInstance] updateMyLiveTitle:title liveTypeId:[[MineManager sharedInstance] getMyInfo].liveTypeId completion:^(NSError * _Nullable error) {
        
        if (error) {
            
            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"错误"
                                                message:[error.userInfo objectForKey:NSLocalizedDescriptionKey]
                                         preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self updateUserLiveTitleViewCancel];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
            
        } else {
            
            [_updateUserLiveTitleView removeFromSuperview];
            self.updateUserLiveTitleView = nil;
            
            MyInfoModel *myInfo = [[MineManager sharedInstance] getMyInfo];
            myInfo.liveTitle = title;
            [[MineManager sharedInstance] updateMyInfo:myInfo];
            
            self.pushUrl = [[MineManager sharedInstance] getMyInfo].pushUrl;
            [self startPush];
            
            [self requestGetChatRoomWhenLiveStart];
        }
    }];
}

-(void)requestGetChatRoomWhenLiveStart {
    
    //get chatroom
    [[UserLiveManager sharedInstance] getChatroomInfoCompletion:^(ChatroomInfoModel * _Nullable info, NSError * _Nullable error) {
        
        if (error) {
            
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            
        } else {
            
            if (!info) {
                
                [self requestCreateChatRoom];
                
            } else {
                
                self.roomInfo = info;
                [self updateRoomUserCount];
                
                if (!isInChatroom) {
                    
                    [self enterChatRoom];
                }
                
                self.roomInfoRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    [self requestRefreshChatRoomInfo];
                }];
            }
        }
    }];
}

-(void)requestCreateChatRoom {
    
    [[UserLiveManager sharedInstance] createChatroom:[[MineManager sharedInstance] getMyInfo].liveTitle
                                        announcement:@""
                                        broadCastUrl:[[MineManager sharedInstance] getMyInfo].rtmpPullUrl
                                          completion:^(NSString * _Nullable roomId, NSError * _Nullable error) {
        
        if (error) {
            
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            
        } else {
            
            self.roomInfo = [[ChatroomInfoModel alloc] init];
            _roomInfo.roomId = roomId;
            [self requestRefreshChatRoomInfo];
            [self enterChatRoom];
            
            self.roomInfoRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self requestRefreshChatRoomInfo];
            }];
        }
    }];
}

-(void)requestRefreshChatRoomInfo {
    
    [[UserLiveManager sharedInstance] getChatroomInfoCompletion:^(ChatroomInfoModel * _Nullable info, NSError * _Nullable error) {
        
        if (error || !info) {
            
//            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
            
        } else {
            
            self.roomInfo = info;
            [self updateRoomUserCount];
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
                                                                                               [self.view bringSubviewToFront:_cameraBtn];
                                                                                               [self.view bringSubviewToFront:_closeBtn];
                                                                
                                                                                               isInChatroom = YES;
                                                                                           }
                                                                                           else
                                                                                           {
                                                                                               NSString *toast = [NSString stringWithFormat:@"进入聊天室失败 code:%zd",error.code];
                                                                                               [wself.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                                                                               NNSLog(@"enter room %@ failed %@",chatroom.roomId,error);
                                                                                           }
                                                                                           
                                                                                       }];

                                          }
                                          else
                                          {
                                              NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];
                                              [self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                          }
                                      }];
}

#pragma mark -网络监听通知
- (void)didNetworkConnectChanged:(NSNotification *)notify{
    NEReachability *reachability = notify.object;
    NENetworkStatus status = [reachability ne_currentReachabilityStatus];
    
    if (status == ReachableViaWiFi) {
        NNSLog(@"切换为WiFi网络");
        //开始直播
        __weak typeof(self) weakSelf = self;
        NSError *error = nil;
        [_mediaCapture startLiveStreamWithError:&error];
        if (error != nil) {
            [weakSelf showErrorAlert:error ];
        }
    } else if (status == ReachableViaWWAN) {
        NNSLog(@"切换为移动网络");
        //提醒用户当前网络为移动网络，是否开启直播
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络为移动网络，是否开启直播？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //开始直播
            __weak typeof(self) weakSelf = self;
            NSError *error = nil;
            [_mediaCapture startLiveStreamWithError:&error];
            if (error != nil) {
                [weakSelf showErrorAlert:error ];
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //取消直播
            __weak typeof(self) weakSelf = self;
            [_mediaCapture stopLiveStream:^(NSError *error) {
                
                [[UserLiveManager sharedInstance] closeLivePushCompletion:^(NSError * _Nullable error) {
                    
                }];
                [weakSelf unInitLiveStream];
                [weakSelf back];
            }];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else if(status == NotReachable) {
        NSLog(@"网络已断开");
        //释放资源
        if (_isLiving) {
            
            [_mediaCapture stopLiveStream:^(NSError *error) {
                if(error == nil)
                {
                    
                    [[UserLiveManager sharedInstance] closeLivePushCompletion:^(NSError * _Nullable error) {
                        
                    }];
                    _isLiving = NO;
                    //NSLocalizedString
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络已断开" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self unInitLiveStream];
                        [self back];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }
    }
}

-(void)callEnterForeground:(NSNotification*)NSNotification
{
    __weak typeof(self) weakSelf = self;
    //回到前台的时候，如果需要开启直播则打开直播
    if (_isLiving == NO  && _needStartLive){
        NSError *error = nil;
        [_mediaCapture startLiveStreamWithError:&error];
        if (error != nil) {
            [weakSelf showErrorAlert:error ];
        }
    }
}

//切到后台，默认是已经打开了直播，也就是onlivestreamstart消息已经收到的情况，如果正在打开直播，而用户就要切到后台，也没关系吧，
-(void)backgroundStopLiveStream:(NSNotification*)notification
{
    UIApplication *app = [UIApplication sharedApplication];
    // 定义一个UIBackgroundTaskIdentifier类型(本质就是NSUInteger)的变量
    // 该变量将作为后台任务的标识符
    __block UIBackgroundTaskIdentifier backTaskId;
    backTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"===在额外申请的10分钟内依然没有完成任务===");
        // 结束后台任务
        [app endBackgroundTask:backTaskId];
    }];
    if(backTaskId == UIBackgroundTaskInvalid){
        NSLog(@"===iOS版本不支持后台运行,后台任务启动失败===");
        return;
    }
    
    // 将代码块以异步方式提交给系统的全局并发队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"===额外申请的后台任务时间为: %f===",app.backgroundTimeRemaining);
        if(_isLiving){
            // 其他内存清理的代码也可以在此处完成
            [_mediaCapture stopLiveStream:^(NSError *error) {
                if (error == nil) {
                    [[UserLiveManager sharedInstance] closeLivePushCompletion:^(NSError * _Nullable error) {
                        
                    }];
                    NNSLog(@"退到后台的直播结束了");
                    _isLiving = NO;
                    _needStartLive = YES;
                    [app endBackgroundTask:backTaskId];
                }
                else{
                    NNSLog(@"退到后台的结束直播发生错误");
                    [app endBackgroundTask:backTaskId];
                }
            }];
        }
        
    });
}

//网络不好的情况下，连续一段时间收到这种错误，可以提醒应用层降低分辨率
-(void)onBadNetworking:(NSNotification*)notification
{
    //     NSLog(@"live streaming on bad networking");
}

//收到此消息，说明直播真的开始了
-(void)onStartLiveStream:(NSNotification*)notification
{
    NNSLog(@"on start live stream");//只有收到直播开始的 信号，才可以关闭直播
    dispatch_async(dispatch_get_main_queue(), ^(void){
        _isLiving = YES;
        
        [[UserLiveManager sharedInstance] startLivePushByTitle:[[MineManager sharedInstance] getMyInfo].liveTitle completion:^(NSError * _Nullable error) {
            
        }];
        
        __weak UserLiveRootViewController *weakSelf = self;
        [weakSelf.mediaCapture snapShotWithCompletionBlock:^(UIImage *latestFrameImage) {
            
            CGImageRef sourceImageRef = [latestFrameImage CGImage];
            CGRect newImgRect = (CGRect){0,(latestFrameImage.size.height - latestFrameImage.size.width*3/4)/2,latestFrameImage.size.width,latestFrameImage.size.width*3/4};
            CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, newImgRect);
            UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
            
            [[MineManager sharedInstance] updateMyLiveImg:newImage completion:^(NSError * _Nullable error) {
                
                if (error) {
                    NNSLog(@"上传封面失败");
                } else {
                    
                    [[MineManager sharedInstance] refreshUserInfoCompletion:^(MyInfoModel * _Nullable myInfo, NSError * _Nullable error) {
                        
                        if (myInfo) {
                            
                            [[MineManager sharedInstance] updateMyInfo:myInfo];
                        }
                    }];
                }
            }];
        }];
        //
    });
}
//直播结束的通知消息
-(void)onFinishedLiveStream:(NSNotification*)notification
{
    NNSLog(@"on finished live stream");
    dispatch_async(dispatch_get_main_queue(), ^(void){
        _isLiving = NO;
        //        [self startButtonPressed:_selectView.startBtn];
    });
}


//- (void)keyboardDidShow:(NSNotification*)notice {
//    
//    keyboardDidShow = YES;
//    //获取键盘的高度
//    NSDictionary *userInfo =[notice userInfo];
//    
//    NSValue*aValue =[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    
//    CGRect keyboardRect = [aValue CGRectValue];
//    NNSLog(@"键盘高度是  %f",keyboardRect.size.height);
//    
//    self.inputView.y = keyboardRect.size.height - self.inputView.height;
//    self.IMAreaView.y = self.inputView.y - self.IMAreaView.height - 10;
//}
//
//- (void)keyboardWillHide:(NSNotification*)notice {
//    
//    keyboardDidShow = NO;
//    self.inputView.y = K_UIScreenHeight;
//    self.IMAreaView.y = K_UIScreenHeight - 190;
//}
//
//- (void)keyboardWillChangeFrame:(NSNotification*)notice {
//    
//    if (keyboardDidShow) {
//        
//        NSDictionary *userInfo = notice.userInfo;
//        
//        // 动画的持续时间
//        double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        
//        // 键盘的frame
//        CGRect keyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        
//        // 执行动画
//        [UIView animateWithDuration:duration animations:^{
//            
//            self.inputView.y = keyboardRect.size.height - self.inputView.height;
//            self.IMAreaView.y = self.inputView.y - self.IMAreaView.height - 10;
//        }];
//
//    }
//}

-(void)NIMSessionViewControllerDelegateEndEditing {
    
    _chatroomViewController.sessionInputView.hidden = YES;
    [self.view bringSubviewToFront:_cameraBtn];
    [self.view bringSubviewToFront:_imBtn];
    [self.view bringSubviewToFront:_closeBtn];
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_roomInfo.roomId completion:nil];
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
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
