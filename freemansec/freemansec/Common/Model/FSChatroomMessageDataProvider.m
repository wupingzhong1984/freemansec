//
//  FSChatroomMessageDataProvider.m
//  freemansec
//
//  Created by adamwu on 2017/8/19.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "FSChatroomMessageDataProvider.h"

@interface FSChatroomMessageDataProvider()

@property (nonatomic,copy)   NSString *roomId;

@end

@implementation FSChatroomMessageDataProvider

- (instancetype)initWithChatroom:(NSString *)roomId
{
    self = [super init];
    if (self)
    {
        _roomId = roomId;
    }
    return self;
}

- (void)pullDown:(NIMMessage *)firstMessage handler:(NIMKitDataProvideHandler)handler
{
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
    option.startTime = firstMessage.timestamp;
    option.limit = 10;
    [[NIMSDK sharedSDK].chatroomManager fetchMessageHistory:self.roomId option:option result:^(NSError *error, NSArray *messages) {
        if (handler) {
            handler(error,messages.reverseObjectEnumerator.allObjects);
        }
    }];
}


- (BOOL)needTimetag{
    return NO;
}
@end
