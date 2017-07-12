//
//  DefaultSettingHeader.h
//  freeemansec
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
