//
//  LiveGiftModel.h
//  freemansec
//
//  Created by adamwu on 2017/11/23.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface LiveGiftModel : JSONModel
@property (nonatomic,strong) NSString<Optional> *giftId;
@property (nonatomic,strong) NSString<Optional> *giftName;
@property (nonatomic,strong) NSString<Optional> *giftImg;
@property (nonatomic,strong) NSString<Optional> *coin;
@end
