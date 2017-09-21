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

- (void)getVideoListPageNum:(NSInteger)pageNum completion:(VideoListCompletion _Nullable)completion {
    
    VideoHttpService* service = [[VideoHttpService alloc] init];
    [service getVideoListPageNum:[NSString stringWithFormat:@"%d",(int)pageNum] completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

- (void)addVideoPlayCount:(NSString*_Nullable)videoId completion:(AddVideoPlayCountCompletion _Nullable)completion {
    
    VideoHttpService* service = [[VideoHttpService alloc] init];
    [service addVideoPlayCount:videoId completion:^(id obj, NSError *err) {
        
        completion(err);
    }];
}
@end
