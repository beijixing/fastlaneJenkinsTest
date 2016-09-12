//
//  UserTool.m
//  AiLife
//
//  Created by Kevin on 14-7-16.
//  Copyright (c) 2014年 bitwayapp. All rights reserved.
//

#import "UserTool.h"
#import "Macro.h"
#import "Constant.h"
#import "RequestService.h"
#import "LogoutModel.h"
//#import "WJHUD.h"
//#import "APService.h"
#import "AppDelegate.h"
#import "UDIDManager.h"
#import "KeychainItemWrapper.h"
#import "WJHUD.h"
#import "SkipViewController.h"

@implementation UserTool

+ (UserTool *)sharedUser {
    static UserTool *_sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUser = [[UserTool alloc] init];
    });
    return _sharedUser;
}

/*
- (void)loginWithUsername:(NSString *)username password:(NSString *)password{
    self.username = username;
    self.password = password;
    [[NSNotificationCenter defaultCenter]postNotificationName:UserLoginSuccessNotification object:self];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)workNum mobileNum:(NSString * )mobileNum{
    self.mobileNum = mobileNum;
    self.username = username;
    self.password = workNum;
    [[NSNotificationCenter defaultCenter]postNotificationName:UserLoginSuccessNotification object:self];
}*/

-(void)loginWithMobile:(NSString *)mobile password:(NSString *)password
{
    self.mobileNum = mobile;
    self.password = password;
    [[NSNotificationCenter defaultCenter]postNotificationName:UserLoginSuccessNotification object:self];
}

- (NSDictionary *)userInfo{
    return [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
}

-(void)setUserInfo:(NSDictionary *)userInfo{
    [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:UserInfoKey];
}


- (NSString *)username{
    return [[NSUserDefaults standardUserDefaults]objectForKey:UserNameKey];
}

-(void)setUsername:(NSString *)username{
    [[NSUserDefaults standardUserDefaults]setObject:username forKey:UserNameKey];
}
-(NSString *)headimg
{
     return [[NSUserDefaults standardUserDefaults]objectForKey:UserHeadImageKey];
}
-(void)setHeadimg:(NSString *)headimg
{
    [[NSUserDefaults standardUserDefaults]setObject:headimg forKey:UserHeadImageKey];
}

- (NSString *)password{
    return [[NSUserDefaults standardUserDefaults]objectForKey:PasswordKey];
}

-(void)setPassword:(NSString *)password{
    [[NSUserDefaults standardUserDefaults]setObject:password forKey:PasswordKey];
}

- (NSString *)mobileNum{
    return [[NSUserDefaults standardUserDefaults]objectForKey:MobileNumKey];
}

-(void)setMobileNum:(NSString *)mobileNum {
    [[NSUserDefaults standardUserDefaults]setObject:mobileNum forKey:MobileNumKey];
}

- (NSString *)userId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:UserIdKey];
}

- (void)setUserId:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults]setObject:userId forKey:UserIdKey];
    
//    [APService setTags:nil alias:( userId ? userId : @"") callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

- (NSString *)h5FileVersion{
    NSString *version = [[NSUserDefaults standardUserDefaults]objectForKey:@"h5FileVersion"];
    return version != nil ? version : @"1.0";
}

- (void)setH5FileVersion:(NSString *)h5FileVersion
{
    [[NSUserDefaults standardUserDefaults]setObject:h5FileVersion forKey:@"h5FileVersion"];
}

- (NSString *)appVersion{
    NSString *version = [[NSUserDefaults standardUserDefaults]objectForKey:@"appVersion"];
    return version != nil ? version : @"1.0";
}

- (void)setAppVersion:(NSString *)appVersion
{
    [[NSUserDefaults standardUserDefaults]setObject:appVersion forKey:@"appVersion"];
}

/**
 *
 *
 *  @return 1 选择报表， 2选择图形
 */
- (NSString *)defaultDaySelection{
    NSString *daySelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"defaultDaySelection"];
    return daySelection != nil ? daySelection : @"1";
}

- (void)setDefaultDaySelection:(NSString *)defaultDaySelection
{
    [[NSUserDefaults standardUserDefaults]setObject:defaultDaySelection forKey:@"defaultDaySelection"];
}

- (NSString *)defaultMonthSelection{
    NSString *monthSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"defaultMonthSelection"];
    return monthSelection != nil ? monthSelection : @"1";
}

- (void)setDefaultMonthSelection:(NSString *)defaultMonthSelection
{
    [[NSUserDefaults standardUserDefaults]setObject:defaultMonthSelection forKey:@"defaultMonthSelection"];
}

- (NSString *)lastImportantKpiDayIndex{
    NSString *lastKpi = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastImportantKpiDayIndex"];
    return lastKpi != nil ? lastKpi : @"1";
}

- (void)setLastImportantKpiDayIndex:(NSString *)lastImportantKpiDayIndex
{
    [[NSUserDefaults standardUserDefaults]setObject:lastImportantKpiDayIndex forKey:@"lastImportantKpiDayIndex"];
}

- (NSString *)lastImportantKpiMonthIndex{
    NSString *lastKpi = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastImportantKpiMonthIndex"];
    return lastKpi != nil ? lastKpi : @"1";
}

- (void)setLastImportantKpiMonthIndex:(NSString *)lastImportantKpiMonthIndex
{
    [[NSUserDefaults standardUserDefaults]setObject:lastImportantKpiMonthIndex forKey:@"lastImportantKpiMonthIndex"];
}

- (void)setH5FileDownloadUrl:(NSString *)h5FileDownloadUrl {
     [[NSUserDefaults standardUserDefaults]setObject:h5FileDownloadUrl forKey:@"h5FileDownloadUrl"];
}

- (NSString *)h5FileDownloadUrl {
    NSString *downloadUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"h5FileDownloadUrl"];
    return downloadUrl;
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    DebugLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)logoutWithResult:(void (^)(BOOL))resultBlock{
//    [RequestService logoutWithResult:^(BOOL success, id object) {
//        if (success) {
//            LogoutModel *model = object;
//            if (model.success) {
//                [WJHUD showOnWindowWithText:AlertMessageLogout];
//                self.username = nil;
//                self.mobileNum = nil;
//                self.password = nil;
//                self.userId = nil;
//                self.headimg = nil;
//                [self setUserInfo:nil];
//                [APService setTags:[NSSet set] alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//                [[NSNotificationCenter defaultCenter]postNotificationName:UserLogoutSuccessNotification object:self];
//                resultBlock(YES);
//            }else{
//                [WJHUD showOnWindowWithText:model.msg];
//                resultBlock(NO);
//            }
//        }else
//        {
//            resultBlock(NO);
//        }
//    }];

}


//- (BOOL)isLogin{
//    return self.mobileNum != nil;
//}

- (void)exitApplication {
    AppDelegate *app = ShareApp;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

- (NSString *)loginToken {
    if (_loginToken) {
        return _loginToken;
    }
    _loginToken = [UDIDManager getTempUDID];
    return _loginToken;
}

#pragma mark - 清空记录
- (void)clearGestureCode{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    [keychin resetKeychainItem];
}

- (BOOL)checkBIComponetInstall{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"zsjfzj://"]]) {
        return YES;
    }else {
        return NO;
    }
}

- (void)addInstallBIComponentTipsAlertVc:(UIViewController *)target{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请按照提示安装联通BI组件应用。为了您的正常使用，请确保成功安装！" preferredStyle:UIAlertControllerStyleAlert];
    

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"好" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开BI组件的下载链接
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://202.99.45.60/zfapp/plist/iphoneMstr.plist"]];
    }];
    
    [alertController addAction:confirmAction];
    [target presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)getBase64EncodedStringFromString:(NSString *)string {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

#pragma mark 登录失效后返回到SkipViewController 重新走登录认证流程
- (void)showSkipViewControlerWithAlert:(BOOL)alert {
    AppDelegate *delegate = ShareApp;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失效，请重新登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        delegate.window.rootViewController = [[SkipViewController alloc] init];
    }];
    
    [alertController addAction:confirmAction];
    if (alert) {
        [delegate.tabBarController.selectedViewController presentViewController:alertController animated:YES completion:^{
        }];
    }else {
        delegate.window.rootViewController = [[SkipViewController alloc] init];
    }
}

#pragma mark 获取tabbarcontroller 每个模块对应的id
- (NSString *)getTabbarModuleIdWithIndex:(NSInteger)idx {
    if (self.tabbarModuleInfo.reportModuleArr.count>idx){
        ReportModuleModel *reportModel = self.tabbarModuleInfo.reportModuleArr[idx];
        return reportModel.moduleId;
        
    }else {
        return @"null";
    }
}

@end
