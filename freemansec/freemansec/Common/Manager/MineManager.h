//
//  MineManager.h
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyInfoModel.h"
#import "IMTokenModel.h"

typedef enum : NSUInteger {
    TLTSina,
    TLTWeixin,
    TLTFb,
} ThirdLoginType;

typedef void(^MyVideoListCompletion)(NSArray* _Nullable videoList, NSError* _Nullable error);
typedef void(^MyFavourListCompletion)(NSArray* _Nullable favourList, NSError* _Nullable error);
typedef void(^MyAttentionListCompletion)(NSArray* _Nullable attentionList, NSError* _Nullable error);

typedef void(^RegisterUserCompletion)(MyInfoModel* _Nullable myInfo, NSError* _Nullable error);
typedef void(^LoginUserCompletion)(MyInfoModel* _Nullable myInfo, NSError* _Nullable error);
typedef void(^PhoneVerifyCompletion)(NSString* _Nullable verify, NSError* _Nullable error);
typedef void(^EmailVerifyCompletion)(NSString* _Nullable verify, NSError* _Nullable error);

typedef void(^IMTokenCompletion)(IMTokenModel* _Nullable tokenInfo, NSError* _Nullable error);
typedef void(^UserLiveTypeCompletion)(NSArray* _Nullable typeList, NSError* _Nullable error);
typedef void(^CreateMyLiveCompletion)(MyInfoModel* _Nullable myInfo, NSError* _Nullable error);
typedef void(^UpdateMyLiveCompletion)(NSError* _Nullable error);

typedef void(^CheckVerifyCompletion)(NSError* _Nullable error);
typedef void(^ResetPwdCompletion)(NSError* _Nullable error);

typedef void(^UpdatePhoneCompletion)(NSError* _Nullable error);
typedef void(^UpdateEmailCompletion)(NSError* _Nullable error);

typedef void(^RealNameVerifyCompletion)(NSError* _Nullable error);

typedef void(^UpdateNickNameCompletion)(MyInfoModel* _Nullable myInfo, NSError* _Nullable error);
typedef void(^UpdateHeadImgCompletion)(MyInfoModel* _Nullable myInfo, NSError* _Nullable error);
typedef void(^UpdateSexCompletion)(MyInfoModel* _Nullable myInfo, NSError* _Nullable error);
typedef void(^UpdateLocationCompletion)(MyInfoModel* _Nullable myInfo, NSError* _Nullable error);

typedef void(^ProvinceListCompletion)(NSArray* _Nullable provinceList, NSError* _Nullable error);
typedef void(^CityListCompletion)(NSArray* _Nullable cityList, NSError* _Nullable error);
typedef void(^AreaListCompletion)(NSArray* _Nullable areaList, NSError* _Nullable error);
typedef void(^ThirdLoginCompletion)(MyInfoModel* _Nullable myInfo, NSError* _Nullable error);
typedef void(^RefreshUserInfoCompletion)(MyInfoModel* _Nullable myInfo, NSError* _Nullable error);
typedef void(^AddMyAttentionCompletion)(NSError* _Nullable error);
typedef void(^CancelMyAttentionCompletion)(NSError* _Nullable error);

@interface MineManager : NSObject

+ (MineManager* _Nonnull)sharedInstance;

- (MyInfoModel* _Nullable)getMyInfo;
- (void)updateMyInfo:(MyInfoModel* _Nullable)info;
- (IMTokenModel* _Nullable)IMToken;
- (void)updateIMToken:(IMTokenModel* _Nullable)token;
- (void)logout;

- (void)registerUserAreaCode:(NSString* _Nullable)areaCode
                       phone:(NSString* _Nullable)phone
                  verifyCode:(NSString* _Nullable)verify
                         pwd:(NSString* _Nullable)pwd
                       email:(NSString* _Nullable)email
                  completion:(RegisterUserCompletion _Nullable)completion;
- (void)loginUserName:(NSString* _Nullable)name
                  pwd:(NSString* _Nullable)pwd
           completion:(LoginUserCompletion _Nullable)completion;
- (void)getIMToken:(NSString* _Nullable)userLoginId completion:(IMTokenCompletion _Nullable)completion;

- (void)getPhoneVerifyCode:(NSString* _Nullable)areaCode phone:(NSString* _Nullable)phone completion:(PhoneVerifyCompletion _Nullable)completion;
- (void)getEmailVerifyCode:(NSString* _Nullable)email completion:(EmailVerifyCompletion _Nullable)completion;

- (void)getUserLiveTypeCompletion:(UserLiveTypeCompletion _Nullable)completion;
- (void)createMyLiveWithLiveTitle:(NSString* _Nonnull)title liveType:(NSString* _Nonnull)typeId completion:(CreateMyLiveCompletion _Nullable)completion;
- (void)updateMyLiveTitle:(NSString*_Nullable)title completion:(UpdateMyLiveCompletion _Nullable)completion;
- (void)updateMyLiveImg:(UIImage*_Nullable)photo completion:(UpdateMyLiveCompletion _Nullable)completion;

- (void)checkVerifyCode:(NSString* _Nullable)verify phone:(NSString* _Nullable)phone areaCode:(NSString* _Nullable)areaCode email:(NSString* _Nullable)email completion:(CheckVerifyCompletion _Nullable)completion;
- (void)resetPwd:(NSString* _Nullable)pwd phone:(NSString* _Nullable)phone email:(NSString* _Nullable)email completion:(ResetPwdCompletion _Nullable)completion;

- (void)updatePhone:(NSString* _Nullable)phone areaCode:(NSString* _Nullable)areaCode verify:(NSString* _Nullable)verify completion:(UpdatePhoneCompletion _Nullable)completion;
- (void)updateEmail:(NSString* _Nullable)email verify:(NSString* _Nullable)verify completion:(UpdateEmailCompletion _Nullable)completion;

- (void)realNameVerify:(NSString* _Nullable)name userType:(NSString* _Nullable)type cardPhoto:(UIImage* _Nullable)photo completion:(RealNameVerifyCompletion _Nullable)completion;

- (void)updateNickName:(NSString* _Nullable)nickName completion:(UpdateNickNameCompletion _Nullable)completion;
- (void)updateHeadImg:(UIImage* _Nullable)photo completion:(UpdateHeadImgCompletion _Nullable)completion;
- (void)updateSex:(NSString* _Nullable)sex completion:(UpdateSexCompletion _Nullable)completion;
- (void)updateProvince:(NSString* _Nullable)provinceId city:(NSString* _Nullable)cityId area:(NSString* _Nullable)areaId completion:(UpdateLocationCompletion _Nullable)completion;

- (void)getProvinceListCompletion:(ProvinceListCompletion _Nullable)completion;
- (void)getCityListByProvinceId:(NSString* _Nullable)pId completion:(CityListCompletion _Nullable)completion;
- (void)getAreaListByCityId:(NSString* _Nullable)cId completion:(AreaListCompletion _Nullable)completion;

- (void)getMyVideoListCompletion:(MyVideoListCompletion _Nullable)completion;
- (void)getMyFavourListCompletion:(MyFavourListCompletion _Nullable)completion;
- (void)getMyAttentionListCompletion:(MyAttentionListCompletion _Nullable)completion;
- (void)addMyAttentionLiveId:(NSString* _Nullable)liveId completion:(AddMyAttentionCompletion _Nullable)completion;
- (void)cancelMyAttentionLiveId:(NSString* _Nullable)liveId completion:(CancelMyAttentionCompletion _Nullable)completion;

- (void)loginWithThird:(ThirdLoginType)type userCode:(NSString*_Nullable)code completion:(ThirdLoginCompletion _Nullable)completion;
- (void)refreshUserInfoCompletion:(RefreshUserInfoCompletion _Nullable)completion;
@end
