//
//  MyAttentionModel.h
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface MyAttentionModel : JSONModel
@property (nonatomic,strong) NSString<Optional>* cId;
@property (nonatomic,strong) NSString<Optional>* liveId;
@property (nonatomic,strong) NSString<Optional>* liveTypeName;
@property (nonatomic,strong) NSString<Optional>* liveTypeId;
@property (nonatomic,strong) NSString<Optional>* liveTitle;
@property (nonatomic,strong) NSString<Optional>* liveImg;
@property (nonatomic,strong) NSString<Optional>* introduce;
@property (nonatomic,strong) NSString<Optional>* nickName;
@property (nonatomic,strong) NSString<Optional>* headImg;
@end
