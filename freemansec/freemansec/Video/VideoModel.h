//
//  VideoModel.h
//  freemansec
//
//  Created by adamwu on 2017/7/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface VideoModel : JSONModel
@property (nonatomic,strong) NSString<Optional>* videoId;
@property (nonatomic,strong) NSString<Optional>* videoName;
@property (nonatomic,strong) NSString<Optional>* desc;
@property (nonatomic,strong) NSString<Optional>* duration; //秒
@property (nonatomic,strong) NSString<Optional>* snapshotUrl;
@property (nonatomic,strong) NSString<Optional>* videoOrigUrl;
@property (nonatomic,strong) NSString<Optional>* createTime; //时间戳 毫秒数

@property (nonatomic,strong) NSString<Optional>* authorName;
@property (nonatomic,strong) NSString<Optional>* headImg;
@property (nonatomic,strong) NSString<Optional>* playCount;
@end
