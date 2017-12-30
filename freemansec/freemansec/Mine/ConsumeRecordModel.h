//
//  ConsumeRecordModel.h
//  freemansec
//
//  Created by adamwu on 2017/11/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface ConsumeRecordModel : JSONModel

@property (nonatomic,strong) NSString<Optional>* typeStr; //“充值”，“消费“
@property (nonatomic,strong) NSString<Optional>* typeId; //1:充值  2:消费
@property (nonatomic,strong) NSString<Optional>* amount;
@property (nonatomic,strong) NSString<Optional>* addTime;
@property (nonatomic,strong) NSString<Optional>* desc;

@end
