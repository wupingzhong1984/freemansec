//
//  FSChatroomViewController.h
//  freemansec
//
//  Created by adamwu on 2017/8/19.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "NIMSessionViewController.h"

@interface FSChatroomViewController : NIMSessionViewController
- (instancetype)initWithChatroom:(NIMChatroom *)chatroom withRect:(CGRect)rect;
@end
