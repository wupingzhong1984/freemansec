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
#import "ProvinceModel.h"
#import "CityModel.h"
#import "AreaModel.h"
#import "UserLiveType.h"
#import "MyAttentionModel.h"

static NSString* RegisterUserPath = @"Ajax/RegisterUser.ashx";
static NSString* LoginUserPath = @"Ajax/LoginUser.ashx";
static NSString* GetPhoneVerifyPath = @"Ajax/SendCode.ashx";
static NSString* GetEmailVerifyPath = @"Ajax/SendEmail.ashx";
static NSString* GetIMPath = @"Ajax/GetIM.ashx";
static NSString* CreateMyLivePath = @"Ajax/CreateLive.ashx";
static NSString* UpdateMyLivePath = @"Ajax/UpdateLiveImg.ashx";
static NSString* CheckVerifyCodePath = @"Ajax/CheckCode.ashx";
static NSString* ResetPwdPath = @"Ajax/BackPassWord.ashx";
static NSString* UpdatePhonePath = @"Ajax/UpdatePhone.ashx";
static NSString* UpdateEmailPath = @"Ajax/UpdateEmail.ashx";
static NSString* RealNameVerifyPath = @"Ajax/Realname.ashx";
static NSString* UpdateUserInfoPath = @"Ajax/updateUser.ashx";
static NSString* GetProvincePath = @"Ajax/getProvince.ashx";
static NSString* GetCityPath = @"Ajax/getCitytoPid.ashx";
static NSString* GetAreaPath = @"Ajax/getAreaToCid.ashx";
static NSString* GetUserLiveTypesPath = @"Ajax/GetLiveTypeByUser.ashx";
static NSString* ThirdLoginPath = @"Ajax/registerLogin.ashx";
static NSString* RefreshUserInfoPath = @"Ajax/getUser.ashx";
static NSString* GetMyAttentionListPath = @"Ajax/getConcernsList.ashx";
static NSString* AddMyAttentionPath = @"Ajax/addConcerns.ashx";
static NSString* CancelMyAttentionPath = @"Ajax/cancelConcerns.ashx";

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
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
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
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
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
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
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
                              @"liveName":title,
                              @"liveimg":@""
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     MyInfoModel* model = [[MyInfoModel alloc] initWithDictionary:[(NSArray*)response.data  objectAtIndex:0] error:&err];
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

- (void)realNameVerify:(NSString*)name userType:(NSString*)type cardPhoto:(UIImage*)photo userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    NSData *data = UIImageJPEGRepresentation(photo,1.0);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [self httpRequestMethod:HttpReuqestMethodPost
                       path:RealNameVerifyPath
                     params:@{@"userid":userId,
                              @"name":name,
                              @"IDcar":encodedImageStr,
                              @"IDcarType":type,
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}

- (void)updateNickName:(NSString*)nickName userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodPost
                       path:UpdateUserInfoPath
                     params:@{@"userid":userId,
                              @"nickName":nickName
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
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

- (void)updateHeadImg:(UIImage*)photo userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    NSData *data = UIImageJPEGRepresentation(photo,1.0);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [self httpRequestMethod:HttpReuqestMethodPost
                       path:UpdateUserInfoPath
                     params:@{@"userid":userId,
                              @"headImg":encodedImageStr
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
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

- (void)updateSex:(NSString*)sex userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodPost
                       path:UpdateUserInfoPath
                     params:@{@"userid":userId,
                              @"sex":sex
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
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

- (void)updateProvince:(NSString*)provinceId city:(NSString*)cityId area:(NSString*)areaId userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodPost
                       path:UpdateUserInfoPath
                     params:@{@"userid":userId,
                              @"province":provinceId,
                              @"city":cityId,
                              @"area":areaId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
                     }
                     
                     MyInfoModel* model = [[MyInfoModel alloc] initWithDictionary:[(NSArray*)response.data objectAtIndex:0] error:&err];
                     if(model == nil){
                         
                         NNSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(model, nil); //success
                     }
                 }];
}

- (void)getProvinceListCompletion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetProvincePath
                     params:nil
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [ProvinceModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NNSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}

- (void)getCityListByProvinceId:(NSString*)pId completion:(HttpClientServiceObjectBlock)completion {

    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetCityPath
                     params:@{@"pid":pId}
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [CityModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}

- (void)getAreaListByCityId:(NSString*)cId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetAreaPath
                     params:@{@"cid":cId}
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [AreaModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}

- (void)getUserLiveTypeCompletion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetUserLiveTypesPath
                     params:nil
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [UserLiveType arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}

- (void)updateMyLiveTitle:(NSString*)title typeId:(NSString*)typeId liveId:(NSString*)liveId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodPost
                       path:UpdateMyLivePath
                     params:@{@"aid":liveId,
                              @"liveType":typeId,
                              @"liveName":title
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}

- (void)updateMyLiveImg:(UIImage*)photo liveTitle:(NSString*)title typeId:(NSString*)typeId liveId:(NSString*)liveId completion:(HttpClientServiceObjectBlock)completion {
    
    NSData *data = UIImageJPEGRepresentation(photo,1.0);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [self httpRequestMethod:HttpReuqestMethodPost
                       path:UpdateMyLivePath
                     params:@{@"aid":liveId,
                               @"liveType":typeId,
                               @"liveName":title,
                               @"liveimg":encodedImageStr
                               }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}

- (void)loginWithThird:(NSString*)type userCode:(NSString*)code completion:(HttpClientServiceObjectBlock)completion {
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:ThirdLoginPath
                     params:@{@"register":type,
                              @"code":code
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
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

- (void)refreshUserInfo:(NSString*)userLoginId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:RefreshUserInfoPath
                     params:@{@"userid":userLoginId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     if ([response.code isEqualToString:@"1"]) {
                         completion(nil, nil);
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

- (void)getMyVideoListByUserId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    //todo
}

- (void)getMyFavourListByUserId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    //todo
}

- (void)getMyAttentionListByUserId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:GetMyAttentionListPath
                     params:@{@"userid":userId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     if(response == nil) {
                         completion(response, err);
                         return ;
                     }
                     
                     NSArray *list = [MyAttentionModel arrayOfModelsFromDictionaries:(NSArray*)response.data error:&err];
                     if(list == nil){
                         
                         NSLog(@"%@", err);
                         completion(nil, err);
                     }else{
                         completion(list, nil); //success
                     }
                 }];
}

- (void)addMyAttentionLiveId:(NSString*)liveId userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:AddMyAttentionPath
                     params:@{@"userid":userId,
                              @"liveid":liveId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}

- (void)cancelMyAttentionLiveId:(NSString*)liveId userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion {
    
    [self httpRequestMethod:HttpReuqestMethodGet
                       path:CancelMyAttentionPath
                     params:@{@"userid":userId,
                              @"liveid":liveId
                              }
                 completion:^(JsonResponse* response, NSError *err) {
                     
                     completion(response, err);
                 }];
}
@end
