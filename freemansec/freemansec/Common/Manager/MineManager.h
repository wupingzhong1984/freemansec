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
#import "UserLiveChannelModel.h"

typedef void(^MyVideoListCompletion)(NSArray* _Nullable videoList, NSError* _Nullable error);
typedef void(^MyFavourListCompletion)(NSArray* _Nullable favourList, NSError* _Nullable error);
typedef void(^MyAttentionListCompletion)(NSArray* _Nullable attentionList, NSError* _Nullable error);

typedef void(^RegisterUserCompletion)(MyInfoModel* _Nullable myInfo, NSError* _Nullable error);
typedef void(^LoginUserCompletion)(MyInfoModel* _Nullable myInfo, NSError* _Nullable error);
typedef void(^PhoneVerifyCompletion)(NSString* _Nullable verify, NSError* _Nullable error);
typedef void(^EmailVerifyCompletion)(NSString* _Nullable verify, NSError* _Nullable error);

typedef void(^IMTokenCompletion)(IMTokenModel* _Nullable tokenInfo, NSError* _Nullable error);

typedef void(^CreateMyLiveCompletion)(UserLiveChannelModel* _Nullable channelModel, NSError* _Nullable error);

typedef void(^CheckVerifyCompletion)(NSError* _Nullable error);
typedef void(^ResetPwdCompletion)(NSError* _Nullable error);

typedef void(^UpdatePhoneCompletion)(NSError* _Nullable error);
typedef void(^UpdateEmailCompletion)(NSError* _Nullable error);

@interface MineManager : NSObject


+ (MineManager* _Nonnull)sharedInstance;

- (MyInfoModel* _Nullable)myInfo;
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

- (void)createMyLiveWithLiveTitle:(NSString* _Nonnull)title liveType:(NSString* _Nonnull)typeId completion:(CreateMyLiveCompletion _Nullable)completion;

- (void)checkVerifyCode:(NSString* _Nullable)verify phone:(NSString* _Nullable)phone areaCode:(NSString* _Nullable)areaCode email:(NSString* _Nullable)email completion:(CheckVerifyCompletion _Nullable)completion;
- (void)resetPwd:(NSString* _Nullable)pwd phone:(NSString* _Nullable)phone email:(NSString* _Nullable)email completion:(ResetPwdCompletion _Nullable)completion;

- (void)updatePhone:(NSString* _Nullable)phone areaCode:(NSString* _Nullable)areaCode verify:(NSString* _Nullable)verify completion:(UpdatePhoneCompletion _Nullable)completion;
- (void)updateEmail:(NSString* _Nullable)email verify:(NSString* _Nullable)verify completion:(UpdateEmailCompletion _Nullable)completion;

- (void)getMyVideoListCompletion:(MyVideoListCompletion _Nullable)completion;
- (void)getMyFavourListCompletion:(MyFavourListCompletion _Nullable)completion;
- (void)getMyAttentionListCompletion:(MyAttentionListCompletion _Nullable)completion;
@end
