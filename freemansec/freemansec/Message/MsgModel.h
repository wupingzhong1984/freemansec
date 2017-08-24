//
//  MsgModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface MsgModel : JSONModel
@property (nonatomic,strong) NSString<Optional>* senderUser;
@property (nonatomic,strong) NSString<Optional>* content;
@property (nonatomic,strong) NSString<Optional>* time;
@end
