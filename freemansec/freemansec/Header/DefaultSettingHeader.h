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

#define BASE_URL @"http://mzcj.dhteam.net"

#define TEST_LIVE_URL @"http://9654.liveplay.myqcloud.com/9654_freeman.m3u8"


#define kNotificationUpdateStatusBar @"kNotificationUpdateStatusBar"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define UIColor_line_d2d2d2 (UIColorFromRGB(0xd2d2d2))
#define UIColor_vc_bgcolor_lightgray (UIColorFromRGB(0xf2f2f2))
#define UIColor_textfield_placecolor (UIColorFromRGB(0xc0c0c0)) //light gray

#define LIVE_TYPE_NAME_LIST [NSArray arrayWithObjects:@"郭sir专区",@"皇牌节目",@"财经访谈",@"股市新闻",@"财经互动",@"其他",nil] //NSLocalizedString
