//
//  MyVideoModel.h
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MyVideoModel : JSONModel
@property (nonatomic,strong) NSString<Optional>* vid;
@property (nonatomic,strong) NSString<Optional>* img;
@property (nonatomic,strong) NSString<Optional>* title;
@property (nonatomic,strong) NSString<Optional>* date;
@property (nonatomic,strong) NSString<Optional>* playCount;

@end
