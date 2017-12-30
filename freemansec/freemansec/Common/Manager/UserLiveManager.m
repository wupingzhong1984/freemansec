//
//  UserLiveManager.m
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserLiveManager.h"
#import "UserLiveHttpService.h"
#import "NSString-MD5.h"

@interface UserLiveManager ()
@property (nonatomic,strong) NSMutableArray *giftArray;
@end

@implementation UserLiveManager

static UserLiveManager *instance;

- (id)init
{
    self = [super init];
    _giftArray = [[NSMutableArray alloc] init];
    return self;
}

+ (UserLiveManager*)sharedInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)createChatroom:(NSString* _Nullable)roomName announcement:(NSString* _Nullable)announcement broadCastUrl:(NSString*_Nullable)broadCasturl completion:(CreateChatroomCompletion _Nullable)completion {
    
    UserLiveHttpService *service = [[UserLiveHttpService alloc] init];
    [service createChatroom:roomName announcement:announcement broadCastUrl:broadCasturl accId:[MineManager sharedInstance].IMToken.accId completion:^(id obj, NSError *err) {
        
        if (err) {
            
            completion(nil,err);
        } else {
            
            NSString *roomId = (NSString*)obj;
            completion(roomId,err);
        }
        
    }];
}

- (void)getChatroomInfoCompletion:(GetChatroomInfoCompletion _Nullable)completion {
    
    UserLiveHttpService *service = [[UserLiveHttpService alloc] init];
    [service getChatroomInfoNeedOnlineUserCount:@"true" accId:[MineManager sharedInstance].IMToken.accId completion:^(id obj, NSError *err) {
        
        if (err) {
            
            completion(nil,err);
        } else {
            
            ChatroomInfoModel *model = (ChatroomInfoModel*)obj;
            completion(model,err);
        }
    }];
}

- (NSString*)randomMsgId:(NSString*)roomId {
    
    NSString *base = [NSString stringWithFormat:@"%@_%@_%@",
                      [MineManager sharedInstance].IMToken.accId,roomId,[LogicManager formatDate:[NSDate date] format:@"yyyyMMddHHmmssnnnn"]];
    return [base stringToMD5:base];
}

- (void)sendChatroomMsg:(NSString*_Nullable)content msgType:(NSString*_Nullable)msgType roomId:(NSString*_Nullable)roomId completion:(SendMsgCompletion _Nullable)completion {
    
    UserLiveHttpService *service = [[UserLiveHttpService alloc] init];
    [service sendChatroomMsg:content msgType:msgType roomId:roomId msgId:[self randomMsgId:roomId] accId:[MineManager sharedInstance].IMToken.accId completion:^(id obj, NSError *err) {
        
        completion(err);
    }];
    
}

- (void)startLivePushByTitle:(NSString*)title completion:(StartLivePushCompletion _Nullable)completion {
    
    UserLiveHttpService *service = [[UserLiveHttpService alloc] init];
    [service startLivePushByCid:[[MineManager sharedInstance] getMyInfo].cId title:title completion:^(id obj, NSError *err) {
        
        completion(err);
    }];
}

- (void)closeLivePushCompletion:(CloseLivePushCompletion _Nullable)completion {
    UserLiveHttpService *service = [[UserLiveHttpService alloc] init];
    [service closeLivePushByCid:[[MineManager sharedInstance] getMyInfo].cId completion:^(id obj, NSError *err) {
        
        completion(err);
    }];
}

- (void)updateGiftArray:(NSArray*)array {
    
    [_giftArray removeAllObjects];
    if (!array) {
        return;
    }
    [_giftArray addObjectsFromArray:array];
}

- (NSMutableArray*)getNewestGiftArray {
    
    return _giftArray;
}
@end
