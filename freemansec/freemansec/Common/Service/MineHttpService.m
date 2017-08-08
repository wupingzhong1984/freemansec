//
//  MineHttpService.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MineHttpService.h"
#import "MyInfoModel.h"
#import "IMTokenModel.h"
#import "UserLiveChannelModel.h"

static NSString* RegisterUserPath = @"Ajax/RegisterUser.ashx";
static NSString* LoginUserPath = @"Ajax/LoginUser.ashx";
static NSString* GetPhoneVerifyPath = @"Ajax/SendCode.ashx";
static NSString* GetEmailVerifyPath = @"Ajax/SendEmail.ashx";
static NSString* GetIMPath = @"Ajax/GetIM.ashx";
static NSString* CreateMyLivePath = @"Ajax/CreateLive.ashx";
static NSString* CheckVerifyCodePath = @"Ajax/CheckCode.ashx";
static NSString* ResetPwdPath = @"Ajax/BackPassWord.ashx";
static NSString* UpdatePhonePath = @"Ajax/UpdatePhone.ashx";
static NSString* UpdateEmailPath = @"Ajax/UpdateEmail.ashx";

@implementation MineHttpService

- (void)registerUserAreaCode:(NSString*)areaCode phone:(NSString*)phone verify:(NSString*)verify pwd:(NSString*)pwd completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:RegisterUserPath
                     params:@{@"registerState":@"0",
                              @"areacode":areaCode,
                              @"phone":phone,
                              @"code":verify,
                              @"password":pwd
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     MyInfoModel* model = [[MyInfoModel alloc] initWithDictionary:[(NSArray*)response.data objectAtIndex:0] error:&err];
                     if(model == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(model, nil); //success
                     }
                 }];
    
}

- (void)registerUserEmail:(NSString*)email verify:(NSString*)verify pwd:(NSString*)pwd completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:RegisterUserPath
                     params:@{@"registerState":@"1",
                              @"email":email,
                              @"code":verify,
                              @"password":pwd
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     MyInfoModel* model = [[MyInfoModel alloc] initWithDictionary:[(NSArray*)response.data objectAtIndex:0] error:&err];
                     
                     if(model == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(model, nil); //success
                     }
                 }];
}

- (void)loginUserName:(NSString*)name pwd:(NSString*)pwd completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:LoginUserPath
                     params:@{@"userLoginId":name,
                              @"userLoginPwd":pwd
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     MyInfoModel* model = [[MyInfoModel alloc] initWithDictionary:[(NSArray*)response.data objectAtIndex:0] error:&err];
                     
                     if(model == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(model, nil); //success
                     }
                 }];
}

- (void)getPhoneVerifyCode:(NSString*)areaCode phone:(NSString*)phone completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetPhoneVerifyPath
                     params:@{@"areacode":areaCode,
                              @"phone":phone
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSNumber *verify = (NSNumber*)response.data;
                     if(verify == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion([NSString stringWithFormat:@"%d",[verify intValue]], nil); //success
                     }
                 }];
}

- (void)getEmailVerifyCode:(NSString*)email completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetEmailVerifyPath
                     params:@{@"email":email,
                              @"state":@"0"
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSNumber *verify = (NSNumber*)response.data;
                     if(verify == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion([NSString stringWithFormat:@"%d",[verify intValue]], nil); //success
                     }
                 }];
}

- (void)getIMToken:(NSString*)userLoginId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetIMPath
                     params:@{@"userLoginId":userLoginId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     IMTokenModel * model = [[IMTokenModel alloc] initWithDictionary:(NSDictionary*)response.data error:&err];
                     
                     if(model == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(model, nil); //success
                     }
                 }];
}

- (void)createMyLiveWithLiveTitle:(NSString*)title liveType:(NSString*)typeId userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:CreateMyLivePath
                     params:@{@"userid":userId,
                              @"liveTypeId":typeId,
                              @"liveName":title
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     UserLiveChannelModel* model = [[UserLiveChannelModel alloc] initWithDictionary:[(NSArray*)response.data  objectAtIndex:0] error:&err];
                     if(model == nil){
                         
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(model, nil); //success
                     }
                 }];
}

- (void)checkVerifyCode:(NSString*)verify phone:(NSString*)phone areaCode:(NSString*)areaCode completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:CheckVerifyCodePath
                     params:@{@"type":@"0",
                              @"phone":phone,
                              @"areacode":areaCode,
                              @"code":verify
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}
- (void)checkVerifyCode:(NSString*)verify email:(NSString*)email completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:CheckVerifyCodePath
                     params:@{@"type":@"1",
                              @"email":email,
                              @"code":verify
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}

- (void)resetPwd:(NSString*)pwd phone:(NSString*)phone completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:ResetPwdPath
                     params:@{@"type":@"0",
                              @"phone":phone,
                              @"password":pwd
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}

- (void)resetPwd:(NSString*)pwd email:(NSString*)email completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:ResetPwdPath
                     params:@{@"type":@"1",
                              @"email":email,
                              @"password":pwd
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}

- (void)updatePhone:(NSString*)phone areaCode:(NSString*)areaCode verify:(NSString*)verify userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:UpdatePhonePath
                     params:@{@"userid":userId,
                              @"areacode":areaCode,
                              @"phone":phone,
                              @"code":verify
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}

- (void)updateEmail:(NSString*)email verify:(NSString*)verify userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:UpdateEmailPath
                     params:@{@"userid":userId,
                              @"email":email,
                              @"code":verify
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}
@end
