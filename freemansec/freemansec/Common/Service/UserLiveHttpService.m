//
//  UserLiveHttpService.m
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UserLiveHttpService.h"
#import "UserLiveChannelModel.h"

static NSString* GetLivePushStreamWithLiveTitlePath = @"ajax/GetBanner.ashx"; //todo

@implementation UserLiveHttpService

- (void)getLivePushStreamWithLiveTitle:(NSString*)title userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)complete {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetLivePushStreamWithLiveTitlePath
                     params:nil
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         complete(response, err);
                         return ;
                     }
                     
                     UserLiveChannelModel* model = [[UserLiveChannelModel alloc] initWithDictionary:(NSDictionary*)response.data error:&err];
                     if(model == nil){

                         
                         NSLog(@"%@", err);
                         complete(nil, err);
                     }else{
                         complete(model, nil); //success
                     }
                 }];
}
@end
