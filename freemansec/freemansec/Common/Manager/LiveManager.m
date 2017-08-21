//
//  LiveManager.m
//  freemansec
//
//  Created by adamwu on 2017/7/17.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveManager.h"
#import "LiveHttpService.h"
#import "OfficialLiveType.h"

static LiveManager *instance;

@interface LiveManager () {
    
    
}
@end
@implementation LiveManager

- (id)init
{
    self = [super init];
    
    return self;
}

+ (LiveManager*)sharedInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (BOOL)liveBannerNeedUpdate {
    
    NSDate *lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"livebannerlastupdatetime"];
    if (!lastUpdateTime || [[NSDate date] timeIntervalSinceDate:lastUpdateTime] > 3600) {
        
        return YES;
    }
    
    return NO;
}

+ (void)updateLiveBannerLastUpdateTime:(NSDate*)time {
    
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"livebannerlastupdatetime"];
}

+ (NSMutableArray*)getOfficialLiveTypeList {
    
    NSMutableArray *names = [NSMutableArray arrayWithObjects:@"郭sir专区",@"皇牌节目",@"财经访谈",@"股市新闻",@"财经互动",@"其它", nil];
    NSMutableArray *ids = [NSMutableArray arrayWithObjects:@"100",@"103",@"104",@"105",@"106",@"107", nil];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0;i < names.count;i++) {
        
        OfficialLiveType *type = [[OfficialLiveType alloc] init];
        type.liveTypeId = [ids objectAtIndex:i];
        type.liveTypeName = [names objectAtIndex:i];
        [array addObject:type];
    }
    
    return array;
}


-(void)getLiveBannerCompletion:(LiveChannelListCompletion)completion {
    
    LiveHttpService* service = [[LiveHttpService alloc] init];
    [service getLiveBannerCompletion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

-(void)getLiveListByLiveTypeId:(NSString*)typeId
                    completion:(LiveChannelListCompletion)completion {
    
    LiveHttpService* service = [[LiveHttpService alloc] init];
    [service getLiveListByLiveTypeId:typeId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

+ (NSMutableArray*)getLiveSearchHistory {
    
    //return [[NSUserDefaults standardUserDefaults] objectForKey:@"LiveSearchHistory"];
    return [self decodeContentFromFile:[self pathForLiveSearchHistory]];
}

+ (void)saveLiveSearchHistory:(NSMutableArray*)searchHistory {
    
    //[[NSUserDefaults standardUserDefaults] setObject:searchHistory forKey:@"LiveSearchHistory"];
    [self encodeContent:searchHistory toFile:[self pathForLiveSearchHistory]];
}

+ (id) decodeContentFromFile:(NSURL*)pFileName
{
    NSData* data = [[NSData alloc] initWithContentsOfURL:pFileName];
    if ([data length] <= 0)
    {
        return nil;
    }
    NSKeyedUnarchiver* unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id content = [unArchiver decodeObjectForKey:@"Root"];
    [unArchiver finishDecoding];
    return content;
}

+ (BOOL) encodeContent:(id)pContent toFile:(NSURL*)pFileName
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:pContent forKey:@"Root"];
    [archiver finishEncoding];
    
    [self createFolderIfNotExistForFile:pFileName];
    return [data writeToURL:pFileName atomically:YES];
}

+ (void) createFolderIfNotExistForFile:(NSURL*)pFileName
{
    NSURL* fileFolder = [pFileName URLByDeletingLastPathComponent];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    
    [fileManager createDirectoryAtURL:fileFolder
          withIntermediateDirectories:YES
                           attributes:nil
                                error:nil];
}

+ (NSURL*)pathForLiveSearchHistory
{
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    NSArray* possibleURLs = [sharedFM URLsForDirectory:NSLibraryDirectory
                                             inDomains:NSUserDomainMask];
    NSURL* path = nil;
    
    
    if ([possibleURLs count] >= 1) {
        
        path = [possibleURLs objectAtIndex:0];
    }
    
    path = [path URLByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier] isDirectory:YES];
    path = [path URLByAppendingPathComponent:@"LiveSearchHistory"];
    return path;
}

-(void)getLiveSearchHotWordsCompletion:(LiveHotWordListCompletion _Nullable)completion {
    
    LiveHttpService* service = [[LiveHttpService alloc] init];
    [service getLiveSearchHotWordsCompletion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

- (void)quaryLiveByWord:(NSString *)word pageNum:(NSInteger)num completion:(QuaryLiveListCompletion)completion {
    
    LiveHttpService* service = [[LiveHttpService alloc] init];
    [service quaryLiveByWord:word pageNum:num completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

-(void)quaryLiveByType:(NSString* _Nullable)typeId pageNum:(NSInteger)num completion:(QuaryLiveListCompletion _Nullable)completion {
    
    LiveHttpService* service = [[LiveHttpService alloc] init];
    [service quaryLiveByType:typeId pageNum:num completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
    
}
@end
