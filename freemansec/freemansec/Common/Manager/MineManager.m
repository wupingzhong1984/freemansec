//
//  MineManager.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MineManager.h"
#import "MineHttpService.h"

static MineManager *instance;

@interface MineManager ()
@property (nonatomic,strong) MyInfoModel * userInfo;
@property (nonatomic,strong) IMTokenModel * userToken;
@end

@implementation MineManager

- (id)init
{
    self = [super init];
    
    return self;
}

+ (MineManager*)sharedInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (MyInfoModel* _Nullable)getMyInfo {
    
    return _userInfo;
}

- (void)updateMyInfo:(MyInfoModel* _Nullable)info {
    
    self.userInfo = info;
}

- (IMTokenModel* _Nullable)IMToken {
    
    return _userToken;
}

- (void)updateIMToken:(IMTokenModel* _Nullable)token {
    
    self.userToken = token;
}

- (void)logout {
    
    [self updateMyInfo:nil];
    [self updateIMToken:nil];
}

- (void)registerUserAreaCode:(NSString* _Nullable)areaCode
                       phone:(NSString* _Nullable)phone
                  verifyCode:(NSString* _Nullable)verify
                         pwd:(NSString* _Nullable)pwd
                       email:(NSString* _Nullable)email
                  completion:(RegisterUserCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    
    if (areaCode) { //phone
        
        [service registerUserAreaCode:areaCode phone:phone verify:verify pwd:pwd completion:^(id obj, NSError *err) {
            if(err){
                
                completion(nil,err);
                
            } else {
                
                MyInfoModel *model = obj;
                completion(model,err);
            }
        }];
        
    } else {
        
        [service registerUserEmail:email verify:verify pwd:pwd completion:^(id obj, NSError *err) {
            if(err){
                
                completion(nil,err);
                
            } else {
                
                MyInfoModel *model = obj;
                completion(model,err);
            }
        }];
    }
    
}

- (void)loginUserName:(NSString* _Nullable)name
                  pwd:(NSString* _Nullable)pwd
           completion:(LoginUserCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service loginUserName:name pwd:pwd completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            MyInfoModel *model = obj;
            completion(model,err);
        }
    }];
}

- (void)getPhoneVerifyCode:(NSString* _Nullable)areaCode phone:(NSString* _Nullable)phone completion:(PhoneVerifyCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getPhoneVerifyCode:areaCode phone:phone completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSString *verify = obj;
            completion(verify,err);
        }
    }];
}

- (void)getEmailVerifyCode:(NSString* _Nullable)email completion:(EmailVerifyCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getEmailVerifyCode:email completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSString *verify = obj;
            completion(verify,err);
        }
    }];
}

- (void)getUserLiveTypeCompletion:(UserLiveTypeCompletion _Nullable)completion
{
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getUserLiveTypeCompletion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

- (void)createMyLiveWithLiveTitle:(NSString* _Nonnull)title liveType:(NSString* _Nonnull)typeId completion:(CreateMyLiveCompletion _Nullable)completion
{
    MineHttpService* service = [[MineHttpService alloc] init];
    [service createMyLiveWithLiveTitle:title liveType:typeId userId:_userInfo.userId completion:^(id obj, NSError *err) {
        
        if(err){
            
            completion(nil,err);
            
        } else {
            MyInfoModel *model = obj;
            completion(model,err);
        }
    }];
}

- (void)getIMToken:(NSString* _Nullable)userLoginId completion:(IMTokenCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getIMToken:userLoginId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            IMTokenModel *tokenInfo = obj;
            completion(tokenInfo,err);
        }
    }];
}

- (void)getMyVideoListCompletion:(MyVideoListCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getMyVideoListByUserId:@"" completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

- (void)getMyFavourListCompletion:(MyFavourListCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getMyFavourListByUserId:_userInfo.userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

- (void)getMyAttentionListCompletion:(MyAttentionListCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getMyAttentionListByUserId:_userInfo.userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
    }];
}

- (void)checkVerifyCode:(NSString* _Nullable)verify phone:(NSString* _Nullable)phone areaCode:(NSString* _Nullable)areaCode email:(NSString* _Nullable)email completion:(CheckVerifyCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    if (phone) {
        [service checkVerifyCode:verify phone:phone areaCode:areaCode completion:^(id obj, NSError *err) {
            
            completion(err);
        }];
    } else {
        
        [service checkVerifyCode:verify email:email completion:^(id obj, NSError *err) {
            completion(err);
        }];
    }
}

- (void)resetPwd:(NSString* _Nullable)pwd phone:(NSString* _Nullable)phone email:(NSString* _Nullable)email completion:(ResetPwdCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    if (phone) {
        [service resetPwd:pwd phone:phone completion:^(id obj, NSError *err) {
            
            completion(err);
        }];
    } else {
        
        [service resetPwd:pwd email:email completion:^(id obj, NSError *err) {
            completion(err);
        }];
    }
}

- (void)updatePhone:(NSString* _Nullable)phone areaCode:(NSString* _Nullable)areaCode verify:(NSString* _Nullable)verify completion:(UpdatePhoneCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service updatePhone:phone areaCode:areaCode verify:verify userId:_userInfo.userId completion:^(id obj, NSError *err) {
            
            completion(err);
    }];
}

- (void)updateEmail:(NSString* _Nullable)email verify:(NSString* _Nullable)verify completion:(UpdateEmailCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service updateEmail:email verify:verify userId:_userInfo.userId completion:^(id obj, NSError *err) {
        
        completion(err);
    }];
}

- (void)realNameVerify:(NSString* _Nullable)name userType:(NSString* _Nullable)type cardPhoto:(UIImage* _Nullable)photo completion:(RealNameVerifyCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service realNameVerify:name userType:type cardPhoto:photo userId:_userInfo.userId completion:^(id obj, NSError *err) {
        
        completion(err);
    }];
}

- (void)updateNickName:(NSString* _Nullable)nickName completion:(UpdateNickNameCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service updateNickName:nickName userId:_userInfo.userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            MyInfoModel *model = obj;
            completion(model,err);
        }
    }];
}

- (void)updateHeadImg:(UIImage* _Nullable)photo completion:(UpdateHeadImgCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service updateHeadImg:photo userId:_userInfo.userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            MyInfoModel *model = obj;
            completion(model,err);
        }
    }];
}

- (void)updateSex:(NSString* _Nullable)sex completion:(UpdateSexCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service updateSex:sex userId:_userInfo.userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            MyInfoModel *model = obj;
            completion(model,err);
        }
    }];
}

- (void)updateProvince:(NSString* _Nullable)provinceId city:(NSString* _Nullable)cityId area:(NSString* _Nullable)areaId completion:(UpdateLocationCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service updateProvince:provinceId city:cityId area:areaId userId:_userInfo.userId completion:^(id obj, NSError *err) {
        if(err){
            
            completion(nil,err);
            
        } else {
            
            MyInfoModel *model = obj;
            completion(model,err);
        }
    }];
}

- (void)getProvinceListCompletion:(ProvinceListCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getProvinceListCompletion:^(id obj, NSError *err) {
        
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }

    }];
}

- (void)getCityListByProvinceId:(NSString* _Nullable)pId completion:(CityListCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getCityListByProvinceId:pId completion:^(id obj, NSError *err) {
        
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
        
    }];
}

- (void)getAreaListByCityId:(NSString* _Nullable)cId completion:(AreaListCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service getAreaListByCityId:cId completion:^(id obj, NSError *err) {
        
        if(err){
            
            completion(nil,err);
            
        } else {
            
            NSArray* list = obj;
            completion(list,err);
        }
        
    }];
}

- (void)updateMyLiveTitle:(NSString*_Nullable)title completion:(UpdateMyLiveCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service updateMyLiveTitle:title liveId:_userInfo.liveId completion:^(id obj, NSError *err) {
        
        completion(err);
    }];
}

- (void)updateMyLiveImg:(UIImage*_Nullable)photo completion:(UpdateMyLiveCompletion _Nullable)completion {
    
    MineHttpService* service = [[MineHttpService alloc] init];
    [service updateMyLiveImg:photo liveId:_userInfo.liveId completion:^(id obj, NSError *err) {
        
        completion(err);
    }];
}

@end
