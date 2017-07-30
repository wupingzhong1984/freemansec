//
//  MyAttentionModel.h
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface MyAttentionModel : JSONModel
@property (nonatomic,strong) NSString<Optional>* liveId;
@property (nonatomic,strong) NSString<Optional>* img;
@property (nonatomic,strong) NSString<Optional>* title;
@property (nonatomic,strong) NSString<Optional>* liveType;
@property (nonatomic,strong) NSString<Optional>* anchorName;
@end
