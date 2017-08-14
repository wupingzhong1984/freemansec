//
//  UserLiveChannelModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface UserLiveChannelModel : JSONModel

@property (nonatomic,strong) NSString<Optional>* cid;
@property (nonatomic,strong) NSString<Optional>* anchorId;
@property (nonatomic,strong) NSString<Optional>* nickName;
@property (nonatomic,strong) NSString<Optional>* headImg;
@property (nonatomic,strong) NSString<Optional>* ctime;
@property (nonatomic,strong) NSString<Optional>* liveName;
@property (nonatomic,strong) NSString<Optional>* liveImg;
@property (nonatomic,strong) NSString<Optional>* pushUrl;
@property (nonatomic,strong) NSString<Optional>* pullUrlHttp;
@property (nonatomic,strong) NSString<Optional>* pullUrlHLS;
@property (nonatomic,strong) NSString<Optional>* pullUrlRtmp;

@end
