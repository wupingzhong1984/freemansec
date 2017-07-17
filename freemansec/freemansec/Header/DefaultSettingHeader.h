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


#define LIVE_SECTION_LIST [NSArray arrayWithObjects:@"郭sir专区",@"皇牌节目",@"财经访谈",@"股市新闻",@"财经互动",@"其他",nil]
