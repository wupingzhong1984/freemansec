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
@property (nonatomic,strong) NSString<Optional>* videoId;
@property (nonatomic,strong) NSString<Optional>* videoImg;
@property (nonatomic,strong) NSString<Optional>* videoName;
@property (nonatomic,strong) NSString<Optional>* date;
@property (nonatomic,strong) NSString<Optional>* playCount;

@end
