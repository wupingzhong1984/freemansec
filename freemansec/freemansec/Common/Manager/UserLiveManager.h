//
//  UserLiveManager.h
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLiveChannelModel.h"

typedef void(^UpdateMyUserLiveTitleCompletion)(UserLiveChannelModel* _Nullable channelModel, NSError* _Nullable error);

@interface UserLiveManager : NSObject

+ (UserLiveManager* _Nonnull)sharedInstance;

- (void)getLivePushStreamWithLiveTitle:(NSString* _Nonnull)title completion:(UpdateMyUserLiveTitleCompletion _Nullable)completion;

@end
