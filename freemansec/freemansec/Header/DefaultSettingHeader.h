//
//  DefaultSettingHeader.h
//  freemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#ifndef DefaultSettingHeader_h
#define DefaultSettingHeader_h


#endif /* DefaultSettingHeader_h */

#ifdef DEBUG

#define NNSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define NNSLog(...)

#endif

#define K_UIScreenWidth [UIScreen mainScreen].bounds.size.width
#define K_UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define K_UISreenWidthScale    K_UIScreenWidth/375  //以iphone6 屏幕为基准
#define K_UIScale(x)           x*K_UISreenWidthScale

#define BASE_URL @"http://mzcj.dhteam.net"

#define NETEASE_APP_KEY @"728d3efc69a56832f570c12c5fa7d780"  //test
#define NETEASE_APP_SECRET @"9f252a052b49" //test

#define UMENG_APPKEY @"598c20e49f06fd5a22000229"

#define TEST_LIVE_URL @"http://9654.liveplay.myqcloud.com/9654_freeman.m3u8"


#define DBPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"freemansec.sqlite"]

#define kNotificationUpdateStatusBar @"kNotificationUpdateStatusBar"



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define UIColor_line_d2d2d2 (UIColorFromRGB(0xd2d2d2))
#define UIColor_navibg [UIColor whiteColor]
#define UIColor_navititle [UIColor blackColor]
#define UIColor_vc_bgcolor_lightgray (UIColorFromRGB(0xf2f2f2))
#define UIColor_textfield_placecolor (UIColorFromRGB(0xc0c0c0)) //light gray
#define UIColor_0a6ed2 (UIColorFromRGB(0x0a6ed2))
#define UIColor_82b432 (UIColorFromRGB(0x82b432))
#define UIColor_9f9f9f (UIColorFromRGB(0x9f9f9f))

typedef enum {
    RPKForgetPwd,
    RPKResetPwd
} ResetPwdKind;

#define IOS8            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define NTESNotificationLogout @"NTESNotificationLogout"
#define UICommonTableBkgColor UIColorFromRGB(0xe4e7ec)
#define Message_Font_Size   14        // 普通聊天文字大小
#define Notification_Font_Size   10   // 通知文字大小
#define Chatroom_Message_Font_Size 16 // 聊天室聊天文字大小
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
