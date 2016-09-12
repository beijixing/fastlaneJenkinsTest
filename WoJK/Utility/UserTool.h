//
//  UserTool.h
//  AiLife
//
//  Created by Kevin on 14-7-16.
//  Copyright (c) 2014年 bitwayapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ReportResponseModel.h"
#import "ReportModuleModel.h"
@interface UserTool : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *mobileNum;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, assign) BOOL authenticationState;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *loginToken;
@property (nonatomic, copy) NSString *currentModuleId;  
@property (nonatomic, strong) NSDictionary *notificationUserInfo;
@property (nonatomic) BOOL isBindingDevice;
@property (nonatomic, copy) NSString *h5FileVersion;

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL openAutoLogin;
@property (nonatomic, strong) NSDictionary * userInfo;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *defaultDaySelection;
@property (nonatomic, strong) NSString *defaultMonthSelection;
@property (nonatomic, strong) NSString *lastImportantKpiDayIndex;
@property (nonatomic, strong) NSString *lastImportantKpiMonthIndex;
@property (nonatomic) BOOL hasSMSCode;
@property (nonatomic, strong) ReportResponseModel *tabbarModuleInfo;
@property (nonatomic, strong) NSString *h5FileDownloadUrl;

+ (UserTool *)sharedUser;

- (void)loginWithMobile:(NSString *)mobile password:(NSString *)password;
//- (void)loginWithUsername:(NSString *)userID password:(NSString *)password;
//- (void)loginWithUsername:(NSString *)username password:(NSString *)password mobileNum:(NSString * )mobileNum;
- (void)logoutWithResult:(void(^)(BOOL success))resultBlock;
- (void)clearGestureCode;
- (void)exitApplication;
- (BOOL)checkBIComponetInstall;
- (void)addInstallBIComponentTipsAlertVc:(UIViewController *)target;
- (NSString *)getBase64EncodedStringFromString:(NSString *)string;
- (void)showSkipViewControlerWithAlert:(BOOL)alert;

- (NSString *)getTabbarModuleIdWithIndex:(NSInteger)idx;
@end
