//
//  FSChatroomConfig.m
//  freemansec
//
//  Created by adamwu on 2017/8/19.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "FSChatroomConfig.h"
#import "FSChatroomMessageDataProvider.h"

@interface FSChatroomConfig()

@property (nonatomic,strong) FSChatroomMessageDataProvider *provider;

@end
@implementation FSChatroomConfig

- (instancetype)initWithChatroom:(NSString *)roomId{
    self = [super init];
    if (self) {
        self.provider = [[FSChatroomMessageDataProvider alloc] initWithChatroom:roomId];
    }
    return self;
}

- (id<NIMKitMessageProvider>)messageDataProvider{
    return self.provider;
}


- (NSArray<NSNumber *> *)inputBarItemTypes{
    return @[
             @(NIMInputBarItemTypeTextAndRecord),
             @(NIMInputBarItemTypeEmoticon)
             ];
}


- (NSArray *)mediaItems
{
    return @[
             [NIMMediaItem item:@"onTapMediaItemJanKenPon:"
                    normalImage:[UIImage imageNamed:@"icon_jankenpon_normal"]
                  selectedImage:[UIImage imageNamed:@"icon_jankenpon_pressed"]
                          title:@"石头剪刀布"]];
}


- (BOOL)disableCharlet{
    return YES;
}

- (BOOL)autoFetchWhenOpenSession
{
    return NO;
}

- (BOOL)shouldHandleReceipt
{
    return NO;
}

@end
