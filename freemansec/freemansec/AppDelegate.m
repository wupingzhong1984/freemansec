//
//  AppDelegate.m
//  freemansec
//
//  Created by adamwu on 2017/7/12.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "LoginViewController.h"
#import "CustomNaviController.h"
#import "FMDatabase.h"
#import "NTESSDKConfigDelegate.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NIMKit.h"
#import "NTESCellLayoutConfig.h"

@interface AppDelegate ()
<NIMLoginManagerDelegate>
@property (nonatomic,strong) NTESSDKConfigDelegate *sdkConfigDelegate;
@property (nonatomic,strong) NSTimer *msgCenterRefreshTimer;
@end

@implementation AppDelegate

- (void)initDBIfNeed {
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:DBPATH] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
        if ([db open]) {
            NSString * sql =
            @"CREATE TABLE 'myinfo' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, 'userloginid' VARCHAR(50), 'userid' VARCHAR(50), 'nickname' NVARCHAR, 'phone' VARCHAR(50), 'email' VARCHAR(50), 'realnameverifystate' VARCHAR(50), 'headimg' VARCHAR(50), 'sex' VARCHAR(50), 'registertype' VARCHAR(50), 'province' VARCHAR(50), 'city' VARCHAR(50), 'area' VARCHAR(50), 'cid' VARCHAR(50), 'liveid' VARCHAR(50), 'livetitle' NVARCHAR, 'liveimg' NVARCHAR, 'livetypeid' VARCHAR(50), 'livetypename' VARCHAR(50), 'pushurl' NVARCHAR, 'rtmppullurl' NVARCHAR, 'hlspullurl' NVARCHAR, 'httppullurl' NVARCHAR);";
            
            
            BOOL res = [db executeStatements:sql withResultBlock:^int(NSDictionary *dictionary) {
                
                return 0;
            }];
            if (!res) {
                NNSLog(@"error when creating db table");
            } else {
                NNSLog(@"succ to creating db table");
            }
            [db close];
        } else {
            NNSLog(@"error when open db");
        }
    }
}


- (void)configUSharePlatforms {
    
    /*设置微信的appKey和appSecret
    [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
    */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx8318243c316dae42" appSecret:@"46a4ed564bb756c1e8f31f513558c3b8" redirectURL:nil];
    
    //todo
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"257024282"  appSecret:@"7cdee95d6d925c22452ff6b6640eba59" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    //ok
    /* 设置Facebook的appKey和UrlString */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"222519288272132"  appSecret:@"1a1463d837e9d2c6079ef3693e642c9b" redirectURL:nil];
    //key 1a1463d837e9d2c6079ef3693e642c9b
}

- (void)configUShareSettings {
    
    
}

- (void)configNIM {
    
    [self setupNIMSDK];
    [self commonInitListenEvents];
}

- (void)setupNIMSDK
{
    //在注册 NIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数
    self.sdkConfigDelegate = [[NTESSDKConfigDelegate alloc] init];
    [[NIMSDKConfig sharedConfig] setDelegate:self.sdkConfigDelegate];
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    [[NIMSDKConfig sharedConfig] setMaxAutoLoginRetryTimes:10];
    
    
    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:NETEASE_APP_KEY];
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    
    //注册 NIMKit 自定义排版配置
    [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig new]];
}

- (void)commonInitListenEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:NTESNotificationLogout
                                               object:nil];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [self initDBIfNeed];
    
    [LiveManager updateLiveBannerLastUpdateTime:nil];
    [VideoManager updateVideoKindLastUpdateTime:nil];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    CustomTabBarController *tabBarVC = [[CustomTabBarController alloc]init];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    
    [self configUSharePlatforms];
    
    [self configUShareSettings];
    
    [self configNIM];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLoadUserLogin object:nil];
    
    [_msgCenterRefreshTimer invalidate];
    self.msgCenterRefreshTimer = nil;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)appearLogin {
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:vc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appearLogin) name:kNotificationLoadUserLogin object:nil];
    
    self.msgCenterRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if ([[MineManager sharedInstance] getMyInfo]) {
            
            [[MessageManager sharedInstance] getNewMsgCountCompletion:^(NSInteger count, NSError * _Nullable error) {
                if (count > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowMsgCenterTabRedPoint object:nil userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",(int)count] forKey:@"msgcenternewmsgcount"]];
                }
            }];
        }
    }];
    
    [[DataManager sharedInstance] updateDB];
    
    if([[MineManager sharedInstance] getMyInfo]) {
        
        [[MineManager sharedInstance] refreshUserInfoCompletion:^(MyInfoModel * _Nullable myInfo, NSError * _Nullable error) {
            
            if (myInfo) {
                
                [[MineManager sharedInstance] updateMyInfo:myInfo];
            }
        }];
    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
@end
