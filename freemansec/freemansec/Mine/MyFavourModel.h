//
//  MyFavourModel.h
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface MyFavourModel : JSONModel
@property (nonatomic,strong) NSString<Optional>* fId;
@property (nonatomic,strong) NSString<Optional>* img;
@property (nonatomic,strong) NSString<Optional>* title;
@property (nonatomic,strong) NSString<Optional>* anchorName;
@property (nonatomic,strong) NSString<Optional>* playCount;
@property (nonatomic,strong) NSString<Optional>* fType; //官方流录播。用户直播录播
@end
