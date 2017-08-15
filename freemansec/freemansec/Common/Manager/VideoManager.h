//
//  VideoManager.h
//  freemansec
//
//  Created by adamwu on 2017/7/23.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^VideoKindListCompletion)(NSArray* _Nullable kindList, NSError* _Nullable error);
typedef void(^VideoListCompletion)(NSArray* _Nullable videoList, NSError* _Nullable error);


@interface VideoManager : NSObject

+ (VideoManager* _Nonnull)sharedInstance;

+ (BOOL)videoKindNeedUpdate;
+ (void)updateVideoKindLastUpdateTime:(NSDate*_Nullable)time;

//- (void)getVideoKindCompletion:(VideoKindListCompletion _Nullable)completion;
//- (void)getVideoListByKindId:(NSString*_Nullable)kindId completion:(VideoListCompletion _Nullable)completion;

- (void)getVideoListPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize completion:(VideoListCompletion _Nullable)completion;
@end
