//
//  DataManager.m
//  freemansec
//
//  Created by adamwu on 2017/8/15.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "DataManager.h"


static DataManager *instance;
const static NSInteger MY_DB_VER = 1; //initversion:0
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
            [self upgradeFrom0To1];
            break;
        default:
            break;
    }
    oldVersion ++;
    
    // 递归判断是否需要升级
    [self upgradeDB:oldVersion];
}

- (void)upgradeFrom0To1 {
    
    if ([_db open]) {
        
        NSString *sql =
        @"CREATE TEMP TABLE 'msg_center_table' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, 'msgid' INTEGER, 'senderuser' VARCHAR(100), 'content' NVARCHAR, 'time' DATETIME, 'isread' VARCHAR(50));";
        BOOL res = [_db executeStatements:sql withResultBlock:^int(NSDictionary *dictionary) {
            
            return 0;
        }];
        if (!res) {
            NNSLog(@"error when dbupdate upgradeFrom0To1");
        } else {
            NNSLog(@"succ to dbupdate upgradeFrom0To1");
        }
        
        [_db close];
    }
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

- (BOOL)insertMsg:(MsgModel*)model {
    
    BOOL success = NO;
    if ([_db open]) {
        success = [_db executeUpdate:@"INSERT INTO msg_center_table (msgid, senderuser, content, time, isread) VALUES (?, ?, ?, ?, ?)",
                   [NSNumber numberWithInteger:[model.msgId integerValue]],
                   model.senderUser,
                   model.content,
                   [LogicManager getDateByStr:model.time format:@"yyyy/M/d H:m:s"], //todo
                   model.isRead];
    }
    [_db close];
    
    return success;
}

- (NSMutableArray*)getMsgListOrderByMsgIdDESC {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    if ([_db open]) {
        
        FMResultSet *s = [_db executeQuery:@"SELECT * FROM ideal ORDER BY msgid DESC"];
        
        while ([s next]) {
            
            MsgModel * model = [[MsgModel alloc] init];
            model.msgId = [NSString stringWithFormat:@"%d",[s intForColumn:@"msgid"]];
            model.senderUser = [s stringForColumn:@"senderuser"];
            model.content = [s stringForColumn:@"content"];
            model.time = [LogicManager formatDate:[s dateForColumn:@"time"] format:@"yyyy/M/d H:m:s"]; //todo
            model.isRead = [s stringForColumn:@"isread"];
            [array addObject:model];
        }
    }
    [_db close];
    
    return array;
}

- (BOOL)updateAllMsgReaded {
    
    BOOL success = NO;
    if ([_db open]) {
        success = [_db executeUpdate:@"UPDATE msg_center_table SET isread = ? WHERE isread = ?",
                   @"1",@"0"];
    }
    [_db close];
    
    return success;
}
@end
