//
//  DataManager.h
//  freemansec
//
//  Created by adamwu on 2017/8/15.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "MyInfoModel.h"

@interface DataManager : NSObject

@property (strong, nonatomic) FMDatabase * db;

+ (DataManager *)sharedInstance;

- (void)updateDB;

- (BOOL)insertMyInfo:(MyInfoModel*)model;
- (MyInfoModel*)getMyInfoByUserId:(NSString*)userId;
- (BOOL)deleteMyInfoByUserId:(NSString*)userId;

@end
