//
//  Constant.h
//  HD100-Custom
//
//  Created by fosung_mac02 on 15/7/2.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#ifndef HD100_Custom_Constant_h
#define HD100_Custom_Constant_h

#pragma mark - Host 
//static NSString * const AppURL = @"http://124.133.15.90:8080/WO_UnicomPro/service/";
//static NSString * const AppURL = @"http://192.168.0.12:8080/WO_UnicomPro/service/";
//static NSString * const AppURL = @"http://202.99.45.60:8899/wojk/service/";
static NSString * const AppURL = @"http://202.99.45.60:8899/WO_UnicomPro/service/";

#pragma mark - Key
static NSString * const UserInfoKey = @"UserInfoKey";
static NSString * const UserNameKey = @"UserNameKey";
static NSString * const PasswordKey = @"PasswordKey";
static NSString * const MobileNumKey = @"MobileNumKey";
static NSString * const UserIdKey = @"UserIdKey";
static NSString * const UserHeadImageKey = @"UserHeadImageKey";
static NSString * const kAppKey = @"kAppKey";
static NSString * const kAppCert = @"kAppCert";
static NSString * const HomeWebViewParams = @"HomeWebViewParams";

#pragma mark - notification
static NSString * const RegistSuccessNotification = @"RegistSuccessNotification";
//static NSString * const GuideViewDismissNotification = @"GuideViewDismissNotification";

static NSString * const UserLoginSuccessNotification = @"UserLoginSuccessNotification";//登录
static NSString * const UserLogoutSuccessNotification = @"UserLogoutSuccessNotification";//注销
//static NSString * const UserInfoChangedNotification = @"UserInfoChanged";//用户信息变更
//static NSString * const UserHeadChangedNotification = @"UserHeadChanged";//用户头像变更
//static NSString * const UserNameChangedNotification = @"UserNameChanged";//用户姓名变更
//static NSString * const LocationDidSelectNotification = @"LocationDidSelectNotification";
//
//static NSString * const OrderStatusDidSelectNotification = @"OrderStatusDidSelectNotification";
////用户地址添加成功
//static NSString * const DealAddressSuccessNotification = @"DealAddressSuccessNotification";
//static NSString * const AddressDidSelectNotification = @"AddressDidSelectNotification";
//static NSString * const SubmitOrderFinishedNotification = @"SubmitOrderFinishedNotification";//登录
//static NSString * const CouponDidSelectNotification = @"CouponDidSelectNotification";


#pragma mark - 提示字符串
static NSString * const AlertMessageWrongTel = @"手机号码格式不正确";
static NSString * const AlertMessageNOContent = @"请完善信息";
static NSString * const AlertMessageNotSamePassword = @"两次密码不相同";
static NSString * const AlertMessageLogout = @"当前账号已退出登录";
static NSString * const AlertMessageNotAgreeRegisterProtocol = @"请阅读并同意用户注册协议";
static NSString * const AlertMessageNOSex = @"请选择性别";
static NSString * const AlertMessageNOUserName = @"用户名不能为空";
static NSString * const AlertMessageNOPSWD = @"密码不能为空";
static NSString * const AlertMessageWrongVerifyCode = @"验证码不正确";
static NSString * const AlertMessageGetDataFailure = @"网络不好，请稍后再试";
static NSString * const AlertMessageSetDataSuccess = @"设置成功";
static NSString * const AlertMessageNewestVersion = @"当前已是最新版本";
static NSString * const AlertMessageNotBindDevice = @"该设备已绑定其他用户";

#pragma mark - 第三方AppKey
//static NSString * const UmengAppKey = @"55ac52b267e58e065f002887";//友盟SDK
//static NSString * const QMapApiKey = @"XFYBZ-GEPWV-DZ7PZ-UNIA3-UJG23-BFB5W";//腾讯地图apikey
//static NSString * const WXAppID = @"wxad437ab43d251700";
#endif
