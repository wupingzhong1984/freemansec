//
//  LiveProgramModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/31.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface LiveProgramModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* programId;
@property (nonatomic, strong) NSString<Optional>* weekDay;
@property (nonatomic, strong) NSString<Optional>* startTime;
@property (nonatomic, strong) NSString<Optional>* endTime;
@property (nonatomic, strong) NSString<Optional>* categoryName;
@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic, strong) NSString<Optional>* desc;
@property (nonatomic, strong) NSString<Optional>* anchorName;
@property (nonatomic, strong) NSString<Optional>* liveImg;
@property (nonatomic, strong) NSString<Optional>* liveLink;
@property (nonatomic, strong) NSString<Optional>* status;
@end
