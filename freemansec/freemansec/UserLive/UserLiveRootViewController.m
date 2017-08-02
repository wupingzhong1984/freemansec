//
//  UserLiveRootViewController.m
//  freemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserLiveRootViewController.h"
#import "UpdateUserLiveTitleView.h"
#import "UserLiveManager.h"
#import "UserLiveChannelModel.h"
#import "NEMediaCaptureEntity.h"
#import "NEAuthorizeManager.h"
#import "NEReachability.h"

@interface UserLiveRootViewController () {
    
    LSVideoParaCtx paraCtx;
    BOOL _isLiving;//是否正在直播
    BOOL _needStartLive;//是否需要开启直播
    LSCameraPosition _isBackCameraPosition;//前置或后置摄像头
//    BOOL _isRecording;//是否正在录制
    
    BOOL _isAccess;

}

@property (nonatomic,strong) UserLiveChannelModel *channelModel;

@property (nonatomic,strong) UpdateUserLiveTitleView *updateUserLiveTitleView;

//直播SDK API
@property (nonatomic,strong) LSMediaCapture *mediaCapture;
@property (nonatomic, strong) UIView *localPreview;//相机预览视图
@end

@implementation UserLiveRootViewController

- (void)back {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    //NSLocalizedString
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:errMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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
    
    //todo
}

- (void)closeBtnAction {
    
    if (_isLiving) {
        
        //NSLocalizedString
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前正在直播，是否确定退出？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __weak UserLiveRootViewController *weakSelf = self;
            [_mediaCapture stopLiveStream:^(NSError *error) {
                [weakSelf unInitLiveStream];
                [weakSelf back];
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
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
    paraCtx.isVideoFilterOn = YES;
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
    
    _mediaCapture = [[LSMediaCapture alloc]initLiveStream:_channelModel.pushUrl withLivestreamParaCtx:streamparaCtx];
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
    
    [_updateUserLiveTitleView removeFromSuperview];
    [self back];
}

- (void)updateUserLiveTitleViewStartLive {
    
    [self requestLiveTitle:_updateUserLiveTitleView.titleTF.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置常亮不锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initLSVideoParaCtxAndCamera];
    [self setupSubviews];
    
    self.updateUserLiveTitleView = [[UpdateUserLiveTitleView alloc] init];
    [_updateUserLiveTitleView.bgBtn addTarget:self action:@selector(updateUserLiveTitleViewCancel) forControlEvents:UIControlEventTouchUpInside];
    [_updateUserLiveTitleView.cancelBtn addTarget:self action:@selector(updateUserLiveTitleViewCancel) forControlEvents:UIControlEventTouchUpInside];
    [_updateUserLiveTitleView.startLiveBtn addTarget:self action:@selector(updateUserLiveTitleViewStartLive) forControlEvents:UIControlEventTouchUpInside];
    
    //test
    self.channelModel = [[UserLiveChannelModel alloc] init];
    _channelModel.pushUrl = @"rtmp://pe25ff8be.live.126.net/live/52d6911fc91b417c84f2cc8e790fe689?wsSecret=02096929813efd8ebf4c01b7da1a8abb&wsTime=1501655352";
    [self startPush];
    
    //[self.view addSubview:_updateUserLiveTitleView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)requestLiveTitle:(NSString*)title {
    
    [[UserLiveManager sharedInstance] getLivePushStreamWithLiveTitle:title completion:^(UserLiveChannelModel *channelModel, NSError * _Nullable error) {
        
        if (error) {
            
            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"提示"
                                                message:[error.userInfo objectForKey:NSLocalizedDescriptionKey]
                                         preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self updateUserLiveTitleViewCancel];
            }]];
            
        } else {
            
            [_updateUserLiveTitleView removeFromSuperview];
            self.updateUserLiveTitleView = nil;
            
            self.channelModel = channelModel;
            [self startPush];
        }
    }];
}

#pragma mark -网络监听通知
- (void)didNetworkConnectChanged:(NSNotification *)notify{
    NEReachability *reachability = notify.object;
    NENetworkStatus status = [reachability ne_currentReachabilityStatus];
    
    if (status == ReachableViaWiFi) {
        NSLog(@"切换为WiFi网络");
        //开始直播
        __weak typeof(self) weakSelf = self;
        NSError *error = nil;
        [_mediaCapture startLiveStreamWithError:&error];
        if (error != nil) {
            [weakSelf showErrorAlert:error ];
        }
    } else if (status == ReachableViaWWAN) {
        NSLog(@"切换为移动网络");
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
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else if(status == NotReachable) {
        NSLog(@"网络已断开");
        //释放资源
        if (_isLiving) {
            
            [_mediaCapture stopLiveStream:^(NSError *error) {
                if(error == nil)
                {
                    _isLiving = NO;
                    //NSLocalizedString
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络已断开" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
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
                    NSLog(@"退到后台的直播结束了");
                    _isLiving = NO;
                    _needStartLive = YES;
                    [app endBackgroundTask:backTaskId];
                }
                else{
                    NSLog(@"退到后台的结束直播发生错误");
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
    NSLog(@"on start live stream");//只有收到直播开始的 信号，才可以关闭直播
    dispatch_async(dispatch_get_main_queue(), ^(void){
        _isLiving = YES;
        
        
        //当直播开始时，获取当前最新的一张图片，用户可以自由选择是否截图
        //        __weak MediaCaptureViewController *weakSelf = self;
        //        [weakSelf.mediaCapture snapShotWithCompletionBlock:^(UIImage *latestFrameImage) {
        //
        //            UIImageWriteToSavedPhotosAlbum(latestFrameImage, weakSelf, nil, nil);
        //
        //        }];
        //
    });
}
//直播结束的通知消息
-(void)onFinishedLiveStream:(NSNotification*)notification
{
    NSLog(@"on finished live stream");
    dispatch_async(dispatch_get_main_queue(), ^(void){
        _isLiving = NO;
        //        [self startButtonPressed:_selectView.startBtn];
    });
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
