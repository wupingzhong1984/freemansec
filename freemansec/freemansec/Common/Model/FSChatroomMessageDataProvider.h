//
//  FSChatroomMessageDataProvider.h
//  freemansec
//
//  Created by adamwu on 2017/8/19.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSChatroomMessageDataProvider : NSObject<NIMKitMessageProvider>
- (instancetype)initWithChatroom:(NSString *)roomId;
@end
