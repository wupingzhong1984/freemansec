//
//  MineManager.h
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MyVideoListCompletion)(NSArray* _Nullable videoList, NSError* _Nullable error);
typedef void(^MyFavourListCompletion)(NSArray* _Nullable favourList, NSError* _Nullable error);
typedef void(^MyAttentionListCompletion)(NSArray* _Nullable attentionList, NSError* _Nullable error);

@interface MineManager : NSObject

+ (MineManager* _Nonnull)sharedInstance;

- (void)getMyVideoListCompletion:(MyVideoListCompletion _Nullable)completion;
- (void)getMyFavourListCompletion:(MyFavourListCompletion _Nullable)completion;
- (void)getMyAttentionListCompletion:(MyAttentionListCompletion _Nullable)completion;
@end
