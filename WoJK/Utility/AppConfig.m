//
//  AppConfig.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/6.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "AppConfig.h"
#import "Constant.h"
#import "Macro.h"
#import "RequestService.h"
//#import "RegistAppJSONModel.h"
//#import "WJHUD.h"
//#import "MobClick.h"
//#import <QMapKit/QMapKit.h>
//#import "PayHandler.h"


@interface AppConfig()
///注册设备
- (void)registApp;
///注册友盟
- (void)setupUMengAnalytics;
///注册腾讯地图
- (void)registQMap;
///注册第三方支付相关Key
- (void)registPayKeys;

@end

@implementation AppConfig
+(void)registerAllInfo
{
    [[AppConfig sharedInstance] registApp];
    [[AppConfig sharedInstance] registQMap];
    [[AppConfig sharedInstance] setupUMengAnalytics];
    [[AppConfig sharedInstance] registPayKeys];
}

+ (instancetype )sharedInstance {
    static AppConfig *_sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUser = [[AppConfig alloc] init];
    });
    return _sharedUser;
}

#pragma mark - Set Get
- (NSString *)appcert{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAppCert];
}

- (void)setAppcert:(NSString *)appcert{
    [[NSUserDefaults standardUserDefaults] setObject:appcert forKey:kAppCert];
}

- (NSString *)appkey{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAppKey];
}

- (void)setAppkey:(NSString *)appkey{
    [[NSUserDefaults standardUserDefaults] setObject:appkey forKey:kAppKey];
}

#pragma mark - Regist & Setup
- (void)registApp{
    if (!APPKEY) {
//        [RequestService syncRegistAppWithResult:^(BOOL success, id object) {
//            if (success) {
//                RegistAppJSONModel * json =  (RegistAppJSONModel*)object;
//                if (json.success) {
//                    if (json.info.count > 0) {
//                        RegistAppInfoJSONModel * info = json.info[0];
//                        [AppConfig sharedInstance].appkey = info.appkey;
//                        [AppConfig sharedInstance].appcert = info.appcert;
//                    }
//                }else
//                {
//                    [WJHUD showOnWindowWithText:json.msg];
//                }
//            }
//        }];
    }
}
- (void)setupUMengAnalytics{
//    [MobClick startWithAppkey:UmengAppKey reportPolicy:BATCH channelId:nil];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
}
-(void)registQMap
{
//    [QMapServices sharedServices].apiKey = QMapApiKey;
}
-(void)registPayKeys
{
//    [PayHandler registPayKey];
}
@end
