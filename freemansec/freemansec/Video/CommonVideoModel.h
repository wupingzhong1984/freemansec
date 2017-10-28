//
//  CommonVideoModel.h
//  freemansec
//
//  Created by adamwu on 2017/10/29.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface CommonVideoModel : JSONModel
@property (nonatomic,strong) NSString<Optional>* videoId;
@property (nonatomic,strong) NSString<Optional>* videoName;
@property (nonatomic,strong) NSString<Optional>* headImg;
@property (nonatomic,strong) NSString<Optional>* nickName;
@property (nonatomic,strong) NSString<Optional>* playCount;
@property (nonatomic,strong) NSString<Optional>* liveType;
@property (nonatomic,strong) NSString<Optional>* addTime; //2017-08-17
@end
