//
//  CityModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/9.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface CityModel : JSONModel
@property (nonatomic,strong) NSString<Optional> *cityId;
@property (nonatomic,strong) NSString<Optional> *name;
@end
