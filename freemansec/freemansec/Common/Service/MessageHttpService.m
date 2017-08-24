//
//  MessageHttpService.m
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MessageHttpService.h"
#import "MsgModel.h"

static NSString* GetMsgListPath = @"Ajax/getMsg.ashx";

@implementation MessageHttpService
- (void)getMsgListPageNum:(NSInteger)pageNum userId:(NSString*_Nullable)userId completion:(HttpClientServiceObjectBlock _Nullable)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetMsgListPath
                     params:@{@"userid":userId,
                              @"pnum":[NSString stringWithFormat:@"%d",(int)pageNum]
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [MsgModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}
@end
