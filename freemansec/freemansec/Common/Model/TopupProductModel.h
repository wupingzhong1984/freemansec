//
//  TopupProductModel.h
//  freemansec
//
//  Created by adamwu on 2017/11/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface TopupProductModel : JSONModel
@property (nonatomic,strong) NSString<Optional> *productId;
@property (nonatomic,strong) NSString<Optional> *productName; //"42金币"
@property (nonatomic,strong) NSString<Optional> *cost; //"6.00"
@property (nonatomic,strong) NSString<Optional> *costDesc; //"RMB 6" "HKD 8"
@property (nonatomic,strong) NSString<Optional> *iApAppleId; //10位纯数字
@end
