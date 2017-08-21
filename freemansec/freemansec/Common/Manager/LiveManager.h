//
//  LiveManager.h
//  freemansec
//
//  Created by adamwu on 2017/7/17.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LiveChannelListCompletion)(NSArray* _Nullable channelList, NSError* _Nullable error);
typedef void(^LiveHotWordListCompletion)(NSArray* _Nullable wordList, NSError* _Nullable error);
typedef void(^QuaryLiveListCompletion)(NSArray* _Nullable quaryResultList, NSError* _Nullable error);

@interface LiveManager : NSObject

+ (LiveManager* _Nonnull)sharedInstance;

+ (NSMutableArray*_Nullable)getLiveSearchHistory;
+ (void)saveLiveSearchHistory:(NSMutableArray*_Nullable)searchHistory;

+ (BOOL)liveBannerNeedUpdate;
+ (void)updateLiveBannerLastUpdateTime:(NSDate*_Nullable)time;

+ (NSMutableArray*_Nonnull)getOfficialLiveTypeList;

-(void)getLiveBannerCompletion:(LiveChannelListCompletion _Nullable)completion;

-(void)getLiveListByLiveTypeId:(NSString* _Nonnull)typeId
                    completion:(LiveChannelListCompletion _Nullable)completion;
-(void)getLiveSearchHotWordsCompletion:(LiveHotWordListCompletion _Nullable)completion;
-(void)quaryLiveByWord:(NSString*_Nullable)word pageNum:(NSInteger)num completion:(QuaryLiveListCompletion _Nullable)completion;
-(void)quaryLiveByType:(NSString* _Nullable)typeId pageNum:(NSInteger)num completion:(QuaryLiveListCompletion _Nullable)completion;
@end
