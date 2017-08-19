//
//  FSChatroomConfig.h
//  freemansec
//
//  Created by adamwu on 2017/8/19.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "FSSessionConfig.h"

@interface FSChatroomConfig : FSSessionConfig
- (instancetype)initWithChatroom:(NSString *)roomId;
@end
