//
//  UserLiveManager.h
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UpdateMyLiveTitleCompletion)(NSError* _Nullable error);

@interface UserLiveManager : NSObject

+ (UserLiveManager* _Nonnull)sharedInstance;

- (void)updateMyLiveWTitle:(NSString* _Nonnull)title completion:(UpdateMyLiveTitleCompletion _Nullable)completion;

@end
