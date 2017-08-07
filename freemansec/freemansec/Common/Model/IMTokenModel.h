//
//  IMTokenModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/7.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface IMTokenModel : JSONModel

@property (nonatomic,strong) NSString<Optional> *token;
@property (nonatomic,strong) NSString<Optional> *accId;
@end
