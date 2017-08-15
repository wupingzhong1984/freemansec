//
//  VideoManager.m
//  freemansec
//
//  Created by adamwu on 2017/7/23.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "VideoManager.h"
#import "VideoHttpService.h"

static VideoManager *instance;

@implementation VideoManager

- (id)init
{
    self = [super init];
    
    return self;
}

+ (VideoManager*)sharedInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (BOOL)videoKindNeedUpdate {
    
    NSDate *lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"videokindlastupdatetime"];
    if (!lastUpdateTime || [[NSDate date] timeIntervalSinceDate:lastUpdateTime] > 3600) {
        
        return YES;
    }
    
    return NO;
}

+ (void)updateVideoKindLastUpdateTime:(NSDate*_Nullable)time {
    
        [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"videokindlastupdatetime"];
}

//- (void)getVideoKindCompletion:(VideoKindListCompletion _Nullable)completion {
//    VideoHttpService* service = [[VideoHttpService alloc] init];
//    [service getVideoKindCompletion:^(id obj, NSError *err) {
//        if(err){
//            
//            completion(nil,err);
//            
//        } else {
//            
//            NSArray* list = obj;
//            completion(list,err);
//        }
//    }];
//}
//- (void)getVideoListByKindId:(NSString*_Nullable)kindId completion:(VideoListCompletion _Nullable)completion {
//    
//    VideoHttpService* service = [[VideoHttpService alloc] init];
//    [service getVideoListByKindId:kindId completion:^(id obj, NSError *err) {
//        if(err){
//            
//            completion(nil,err);
//            
//        } else {
//            
//            NSArray* list = obj;
//            completion(list,err);
//        }
//    }];
//}

- (void)getVideoListPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize completion:(VideoListCompletion _Nullable)completion {
    
    VideoHttpService* service = [[VideoHttpService alloc] init];
    [service getVideoListPageNum:[NSString stringWithFormat:@"%d",(int)pageNum] pageSize:[NSString stringWithFormat:@"%d",(int)pageSize] status:@"40" type:@"0" completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}
@end
