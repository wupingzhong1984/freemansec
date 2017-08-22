//
//  DataManager.m
//  freemansec
//
//  Created by adamwu on 2017/8/15.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "DataManager.h"


static DataManager *instance;
const static NSInteger MY_DB_VER = 0; //initversion:0
#define DB_VERSION_KEY @"dbversionkey"

@implementation DataManager

- (id)init
{
    self = [super init];
    
    _db = [FMDatabase databaseWithPath:DBPATH];
    
    return self;
}

+ (DataManager *)sharedInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)updateDB {
    
    // 升级操作
    NSInteger ver = [[NSUserDefaults standardUserDefaults] integerForKey:DB_VERSION_KEY];
    if(ver < MY_DB_VER) {
        //升级
        [self upgradeDB:ver];
        
        // 保存新的版本号到库中 -这里大家可以使用NSUserDefault存储
        [[NSUserDefaults standardUserDefaults] setInteger:MY_DB_VER forKey:DB_VERSION_KEY];
    }
}

- (void)upgradeDB:(NSInteger)oldVersion {
    
    if (oldVersion >= MY_DB_VER) {
        return;
    }
    switch (oldVersion) {
        case 0:
//            [self upgradeFrom0To1];
            break;
        default:
            break;
    }
    oldVersion ++;
    
    // 递归判断是否需要升级
    [self upgradeDB:oldVersion];
}


- (BOOL)insertMyInfo:(MyInfoModel*)model {
    
    BOOL success = NO;
    if ([_db open]) {
        success = [_db executeUpdate:@"INSERT INTO myinfo (userloginid, userid, nickname, phone, email, realnameverifystate, headimg, sex, registertype, province, city, area, cid, liveid, livetitle, liveimg, livetypeid, livetypename, pushurl, rtmppullurl, hlspullurl, httppullurl) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                   model.userLoginId,
                   model.userId,
                   model.nickName,
                   model.phone,
                   model.email,
                   model.realNameVerifyState,
                   model.headImg,
                   model.sex,
                   model.registerType,
                   model.province,
                   model.city,
                   model.area,
                   model.cId,
                   model.liveId,
                   model.liveTitle,
                   model.liveImg,
                   model.liveTypeId,
                   model.liveTypeName,
                   model.pushUrl,
                   model.rtmpPullUrl,
                   model.hlsPullUrl,
                   model.httpPullUrl];
    }
    [_db close];
    
    return success;
}

- (MyInfoModel*)getMyInfoByUserId:(NSString*)userId {
    
    MyInfoModel *model;
    
    if ([_db open]) {
        
        FMResultSet *s = [_db executeQuery:@"SELECT * FROM myinfo WHERE userid = ?",userId];
        
        if ([s next]) {
            
            model = [[MyInfoModel alloc] init];
            model.userLoginId = [s stringForColumn:@"userloginid"];
            model.userId = [s stringForColumn:@"userid"];
            model.nickName = [s stringForColumn:@"nickname"];
            model.phone = [s stringForColumn:@"phone"];
            model.email = [s stringForColumn:@"email"];
            model.realNameVerifyState = [s stringForColumn:@"realnameverifystate"];
            model.headImg = [s stringForColumn:@"headimg"];
            model.sex = [s stringForColumn:@"sex"];
            model.registerType = [s stringForColumn:@"registertype"];
            model.province = [s stringForColumn:@"province"];
            model.city = [s stringForColumn:@"city"];
            model.area = [s stringForColumn:@"area"];
            model.cId = [s stringForColumn:@"cid"];
            model.liveId = [s stringForColumn:@"liveid"];
            model.liveTitle = [s stringForColumn:@"livetitle"];
            model.liveImg = [s stringForColumn:@"liveimg"];
            model.liveTypeId = [s stringForColumn:@"livetypeid"];
            model.liveTypeName = [s stringForColumn:@"livetypename"];
            model.pushUrl = [s stringForColumn:@"pushurl"];
            model.rtmpPullUrl = [s stringForColumn:@"rtmppullurl"];
            model.hlsPullUrl = [s stringForColumn:@"hlspullurl"];
            model.httpPullUrl = [s stringForColumn:@"httppullurl"];
        }
    }
    [_db close];
    
    return model;
}


- (BOOL)deleteMyInfoByUserId:(NSString*)userId {
    
    BOOL success = NO;
    if ([_db open]) {
        success = [_db executeUpdate:@"DELETE FROM myinfo WHERE userid = ?",userId];
    }
    [_db close];
    
    return success;
}

@end
