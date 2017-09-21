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
@property (nonatomic,strong) NSString<Optional>* cId;
@property (nonatomic,strong) NSString<Optional>* playCount;
@property (nonatomic,strong) NSString<Optional>* type; //0 主播 1 官方
@property (nonatomic,strong) NSString<Optional>* origVideoKey;
@property (nonatomic,strong) NSString<Optional>* videoName;
@property (nonatomic,strong) NSString<Optional>* createTime; //2017/09/15 15:25:04
@property (nonatomic,strong) NSString<Optional>* origUrl;
@property (nonatomic,strong) NSString<Optional>* snapshotUrl;
@property (nonatomic,strong) NSString<Optional>* authorName;
@property (nonatomic,strong) NSString<Optional>* headImg;
@property (nonatomic,strong) NSString<Optional>* isFavour;
@end
