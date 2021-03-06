//
//  LiveChannelModel.h
//  freemansec
//
//  Created by adamwu on 2017/7/13.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface LiveChannelModel : JSONModel
@property (nonatomic, strong) NSString<Optional>* liveId;
@property (nonatomic, strong) NSString<Optional>* liveName;
@property (nonatomic, strong) NSString<Optional>* liveImg;
@property (nonatomic, strong) NSString<Optional>* liveIntroduce;
@property (nonatomic, strong) NSString<Optional>* livelink;
@property (nonatomic, strong) NSString<Optional>* anchorId;
@property (nonatomic, strong) NSString<Optional>* anchorName;
@property (nonatomic, strong) NSString<Optional>* anchorImg;
@property (nonatomic, strong) NSString<Optional>* anchorIntroduce;
@property (nonatomic, strong) NSString<Optional>* isAttent;
@end
