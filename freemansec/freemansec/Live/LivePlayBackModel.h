//
//  LivePlayBackModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/31.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface LivePlayBackModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* playbackId;
@property (nonatomic, strong) NSString<Optional>* categoryName;
@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic, strong) NSString<Optional>* desc;
@property (nonatomic, strong) NSString<Optional>* url;
@property (nonatomic, strong) NSString<Optional>* liveImg;
@property (nonatomic, strong) NSString<Optional>* createTime;
@property (nonatomic, strong) NSString<Optional>* playCount;
@end
