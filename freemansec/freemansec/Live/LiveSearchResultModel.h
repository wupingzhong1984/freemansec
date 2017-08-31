//
//  LiveSearchResultModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/13.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface LiveSearchResultModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* liveId;
@property (nonatomic, strong) NSString<Optional>* liveTypeId;
@property (nonatomic, strong) NSString<Optional>* liveTypeName;
@property (nonatomic, strong) NSString<Optional>* liveName;
@property (nonatomic, strong) NSString<Optional>* liveImg;
@property (nonatomic, strong) NSString<Optional>* liveIntroduce;
@property (nonatomic, strong) NSString<Optional>* livelink;
@property (nonatomic, strong) NSString<Optional>* anchorId;
@property (nonatomic, strong) NSString<Optional>* nickName;
@property (nonatomic, strong) NSString<Optional>* headImg;
@property (nonatomic, strong) NSString<Optional>* cid;  //个人频道id
@property (nonatomic, strong) NSString<Optional>* httpPullUrl;
@property (nonatomic, strong) NSString<Optional>* hlsPullUrl;
@property (nonatomic, strong) NSString<Optional>* rtmpPullUrl;
@property (nonatomic, strong) NSString<Optional>* pushUrl;
@property (nonatomic, strong) NSString<Optional>* addTime;//2017/7/28 18:21:48
@property (nonatomic, strong) NSString<Optional>* isDelete;
@property (nonatomic, strong) NSString<Optional>* isAttent;
@property (nonatomic, strong) NSString<Optional>* state; //1,3 可播
@property (nonatomic, strong) NSString<Optional>* onlineusercount;
@end
