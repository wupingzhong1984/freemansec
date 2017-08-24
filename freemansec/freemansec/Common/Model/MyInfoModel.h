//
//  MyInfoModel.h
//  freemansec
//
//  Created by adamwu on 2017/8/6.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "JSONModel.h"

@interface MyInfoModel : JSONModel

//个人信息
@property (nonatomic,strong) NSString<Optional>* userLoginId;//跨平台身份ID 用户获取IM的token
@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) NSString<Optional>* nickName;
@property (nonatomic,strong) NSString<Optional>* phone;
@property (nonatomic,strong) NSString<Optional>* email;
@property (nonatomic,strong) NSString<Optional>* realNameVerifyState; //0未审核，1已审核，2已冻结，3未通过审核，4审核中
@property (nonatomic,strong) NSString<Optional>* headImg;
@property (nonatomic,strong) NSString<Optional>* sex;
@property (nonatomic,strong) NSString<Optional>* registerType;//注册方式  0为手机注册 1为邮箱注册
//所在地
@property (nonatomic,strong) NSString<Optional>* province;
@property (nonatomic,strong) NSString<Optional>* city;
@property (nonatomic,strong) NSString<Optional>* area;
//直播信息
@property (nonatomic,strong) NSString<Optional>* cId;//网易侧频道id
@property (nonatomic,strong) NSString<Optional>* liveId; //服务器侧频道id
@property (nonatomic,strong) NSString<Optional>* liveTitle;
@property (nonatomic,strong) NSString<Optional>* liveImg;
@property (nonatomic,strong) NSString<Optional>* liveTypeId;
@property (nonatomic,strong) NSString<Optional>* liveTypeName;
@property (nonatomic,strong) NSString<Optional>* pushUrl;
@property (nonatomic,strong) NSString<Optional>* rtmpPullUrl;
@property (nonatomic,strong) NSString<Optional>* hlsPullUrl;
@property (nonatomic,strong) NSString<Optional>* httpPullUrl;

@end
