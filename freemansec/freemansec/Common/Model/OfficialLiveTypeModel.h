//
//  OfficialLiveTypeModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/7.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface OfficialLiveTypeModel : JSONModel

@property (nonatomic,strong) NSString<Optional> *liveTypeId;
@property (nonatomic,strong) NSString<Optional> *liveTypeName;
@property (nonatomic,strong) NSString<Optional> *liveTypeImg;
@end
