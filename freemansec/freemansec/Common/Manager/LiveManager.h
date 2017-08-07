//
//  LiveManager.h
//  freemansec
//
//  Created by adamwu on 2017/7/17.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LiveChannelListCompletion)(NSArray* _Nullable channelList, NSError* _Nullable error);

@interface LiveManager : NSObject

+ (LiveManager* _Nonnull)sharedInstance;

+ (BOOL)liveBannerNeedUpdate;
+ (void)updateLiveBannerLastUpdateTime:(NSDate*_Nullable)time;
+ (NSMutableArray*_Nonnull)getOfficialLiveTypeList;

-(void)getLiveBannerCompletion:(LiveChannelListCompletion _Nullable)completion;

-(void)getLiveListByLiveTypeId:(NSString* _Nonnull)typeId
                    completion:(LiveChannelListCompletion _Nullable)completion;

@end
