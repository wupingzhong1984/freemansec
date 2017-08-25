//
//  MineHttpService.h
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HttpClientService.h"

@interface MineHttpService : HttpClientService

- (void)registerUserAreaCode:(NSString*)areaCode phone:(NSString*)phone verify:(NSString*)verify pwd:(NSString*)pwd completion:(HttpClientServiceObjectBlock)completion;
- (void)registerUserEmail:(NSString*)email verify:(NSString*)verify pwd:(NSString*)pwd completion:(HttpClientServiceObjectBlock)completion;
- (void)loginUserName:(NSString*)name pwd:(NSString*)pwd completion:(HttpClientServiceObjectBlock)completion;
- (void)getIMToken:(NSString*)userLoginId completion:(HttpClientServiceObjectBlock)completion;

- (void)getPhoneVerifyCode:(NSString*)areaCode phone:(NSString*)phone completion:(HttpClientServiceObjectBlock)completion;
- (void)getEmailVerifyCode:(NSString*)email completion:(HttpClientServiceObjectBlock)completion;

- (void)checkVerifyCode:(NSString*)verify phone:(NSString*)phone areaCode:(NSString*)areaCode completion:(HttpClientServiceObjectBlock)completion;
- (void)checkVerifyCode:(NSString*)verify email:(NSString*)email completion:(HttpClientServiceObjectBlock)completion;

- (void)resetPwd:(NSString*)pwd phone:(NSString*)phone completion:(HttpClientServiceObjectBlock)completion;
- (void)resetPwd:(NSString*)pwd email:(NSString*)email completion:(HttpClientServiceObjectBlock)completion;

- (void)updatePhone:(NSString*)phone areaCode:(NSString*)areaCode verify:(NSString*)verify userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;
- (void)updateEmail:(NSString*)email verify:(NSString*)verify userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;

- (void)createMyLiveWithLiveTitle:(NSString*)title liveType:(NSString*)typeId userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;
- (void)updateMyLiveTitle:(NSString*)title typeId:(NSString*)typeId liveId:(NSString*)liveId completion:(HttpClientServiceObjectBlock)completion;
- (void)updateMyLiveImg:(UIImage*)photo liveTitle:(NSString*)title typeId:(NSString*)typeId liveId:(NSString*)liveId completion:(HttpClientServiceObjectBlock)completion;

- (void)realNameVerify:(NSString*)name userType:(NSString*)type cardPhoto:(UIImage*)photo userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;

- (void)updateNickName:(NSString*)nickName userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;
- (void)updateHeadImg:(UIImage*)photo userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;
- (void)updateSex:(NSString*)sex userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;
- (void)updateProvince:(NSString*)provinceId city:(NSString*)cityId area:(NSString*)areaId userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;

- (void)getMyVideoListByUserId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;
- (void)getMyFavourListByUserId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;
- (void)getMyAttentionListByUserId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;

- (void)addMyAttentionLiveId:(NSString*)liveId userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;
- (void)cancelMyAttentionLiveId:(NSString*)liveId userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;

- (void)addMyAttentionCId:(NSString*)cId userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;
- (void)cancelMyAttentionCId:(NSString*)cId userId:(NSString*)userId completion:(HttpClientServiceObjectBlock)completion;

- (void)getProvinceListCompletion:(HttpClientServiceObjectBlock)completion;
- (void)getCityListByProvinceId:(NSString*)pId completion:(HttpClientServiceObjectBlock)completion;
- (void)getAreaListByCityId:(NSString*)cId completion:(HttpClientServiceObjectBlock)completion;

- (void)getUserLiveTypeCompletion:(HttpClientServiceObjectBlock)completion;

- (void)loginWithThird:(NSString*)type userCode:(NSString*)code nickName:(NSString*)nickName headImg:(NSString*)headImg completion:(HttpClientServiceObjectBlock)completion;

- (void)refreshUserInfo:(NSString*)userLoginId completion:(HttpClientServiceObjectBlock)completion;


@end
