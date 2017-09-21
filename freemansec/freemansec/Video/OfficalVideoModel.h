//
//  OfficalVideoModel.h
//  freemansec
//
//  Created by adamwu on 2017/9/20.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface OfficalVideoModel : JSONModel
@property (nonatomic,strong) NSString<Optional>* videoId;
@property (nonatomic,strong) NSString<Optional>* videoCategory;
@property (nonatomic,strong) NSString<Optional>* videoName;
@property (nonatomic,strong) NSString<Optional>* desc;
@property (nonatomic,strong) NSString<Optional>* origUrl;
@property (nonatomic,strong) NSString<Optional>* snapshotUrl;
@property (nonatomic,strong) NSString<Optional>* createTime; //2017-08-17
@property (nonatomic,strong) NSString<Optional>* playCount;
@end
