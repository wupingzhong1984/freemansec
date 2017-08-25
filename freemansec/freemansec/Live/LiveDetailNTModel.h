//
//  LiveDetailNTModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/26.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface LiveDetailNTModel : JSONModel
@property (nonatomic, strong) NSString<Optional>* needRecord;
@property (nonatomic, strong) NSString<Optional>* uid;
@property (nonatomic, strong) NSString<Optional>* duration;
@property (nonatomic, strong) NSString<Optional>* status;
@property (nonatomic, strong) NSString<Optional>* name;
@property (nonatomic, strong) NSString<Optional>* filename;
@property (nonatomic, strong) NSString<Optional>* format;
@property (nonatomic, strong) NSString<Optional>* type;
@property (nonatomic, strong) NSString<Optional>* ctime;
@property (nonatomic, strong) NSString<Optional>* cid;
@property (nonatomic, strong) NSString<Optional>* recordStatus;
@end
