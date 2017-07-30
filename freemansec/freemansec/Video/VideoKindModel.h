//
//  VideoKindModel.h
//  freemansec
//
//  Created by adamwu on 2017/7/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface VideoKindModel : JSONModel

@property (nonatomic,strong) NSString<Optional>* kindId;
@property (nonatomic,strong) NSString<Optional>* kindName;

@end
