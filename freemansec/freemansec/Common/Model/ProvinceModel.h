//
//  ProvinceModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/9.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface ProvinceModel : JSONModel
@property (nonatomic,strong) NSString<Optional> *provinceId;
@property (nonatomic,strong) NSString<Optional> *name;
@end
