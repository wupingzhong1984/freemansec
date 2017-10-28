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
typedef void(^AddVideoPlayCountCompletion)(NSError* _Nullable error);
typedef void(^VideoList2Completion)(NSArray* _Nullable videoList, NSError* _Nullable error);
@interface VideoManager : NSObject

+ (VideoManager* _Nonnull)sharedInstance;


//- (void)getVideoKindCompletion:(VideoKindListCompletion _Nullable)completion;
//- (void)getVideoListByKindId:(NSString*_Nullable)kindId completion:(VideoListCompletion _Nullable)completion;

- (void)getVideoListPageNum:(NSInteger)pageNum completion:(VideoListCompletion _Nullable)completion;


- (void)addVideoPlayCount:(NSString*_Nullable)videoId completion:(AddVideoPlayCountCompletion _Nullable)completion;


- (void)getVideoListByType:(NSString*_Nullable)type typeId:(NSString*_Nullable)typeId user:(NSString*_Nullable)user completion:(VideoList2Completion _Nullable)completion;
@end
