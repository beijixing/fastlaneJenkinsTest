//
//  AppDelegate.m
//  WoJK
//
//  Created by Megatron on 16/4/13.
//  Copyright (c) 2016年 zhilong. All rights reserved.
//

#import "AppDelegate.h"
#import "KeyboardManager.h"
#import "CustomTabBarController.h"
#import "BPush.h"
#import "Constant.h"
#import "LoginViewController.h"
#import "UserTool.h"
#import "DBManager.h"
#import "BlueNavigationController.h"
#import "NotificationSkipVC.h"
#import "FileOperation.h"
#import "UDIDManager.h"
#import "RequestService.h"
#import "AppUpgradeModel.h"
#import "AuthenticationModel.h"
#import "RegisterViewController.h"
#import "WJHUD.h"
#import "SkipViewController.h"
#import "Macro.h"

static BOOL isBackGroundActivateApplication;
@interface AppDelegate ()
{
}
@property (nonatomic) BOOL isLaunchedByNotification;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DLog(@"didFinishLaunchingWithOptions");
    [[DBManager sharedDBManager] openDB];
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        self.isLaunchedByNotification = YES;
    }else {
        self.isLaunchedByNotification = NO;
    }

    [UserTool sharedUser].hasSMSCode = NO;
    //[[UserTool sharedUser] clearGestureCode];
    [self setupBPushWithLaunchOptions:launchOptions];
    [IQKeyboardManager sharedManager].enable = true;
    [self createDirectory];
    self.window.rootViewController = [[SkipViewController alloc] init];
    [self handleNotificationEvent];
    return YES;
}

- (void)createDirectory {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *jsDirectoryPath = [NSString stringWithFormat:@"%@/js", documentPath];
    NSString *cssDirectoryPath = [NSString stringWithFormat:@"%@/css", documentPath];
    NSString *imagesDirectoryPath = [NSString stringWithFormat:@"%@/images", documentPath];
    DLog(@"documentPath=%@",documentPath);
    [FileOperation createDirectory:jsDirectoryPath];
    [FileOperation createDirectory:cssDirectoryPath];
    [FileOperation createDirectory:imagesDirectoryPath];
    [self writeFileToSandBox];
}

- (void)writeFileToSandBox {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *jsDirectoryPath = [NSString stringWithFormat:@"%@/js", documentPath];
    NSString *cssDirectoryPath = [NSString stringWithFormat:@"%@/css", documentPath];
    NSString *imagesDirectoryPath = [NSString stringWithFormat:@"%@/images", documentPath];

   
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    BOOL clearChache = NO;
    //版本号的格式为 1.x
    NSString *version = [NSString stringWithFormat:@"%@", [UserTool sharedUser].appVersion];
    if (![version isEqualToString:app_Version]) {
        [UserTool sharedUser].appVersion = app_Version;
        clearChache = YES;
    }
//     clearChache = YES;//临时测试用，正式版本徐注释掉
    //copy html files
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"hxdb-report" ofType:@"html"];
    [FileOperation copyFile:filePath toPath:documentPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"jkrb-txbbfx-report" ofType:@"html"];
    [FileOperation copyFile:filePath toPath:documentPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"jkrb-zdgzzb-report" ofType:@"html"];
    [FileOperation copyFile:filePath toPath:documentPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"jkyb-zdgzzb-report" ofType:@"html"];
    [FileOperation copyFile:filePath toPath:documentPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"ydgj-report" ofType:@"html"];
    [FileOperation copyFile:filePath toPath:documentPath deleteIfExist:clearChache];
    
    //copy js files
    filePath = [[NSBundle mainBundle] pathForResource:@"/js/doT.min" ofType:@"js"];
    [FileOperation copyFile:filePath toPath:jsDirectoryPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"/js/highcharts" ofType:@"js"];
    [FileOperation copyFile:filePath toPath:jsDirectoryPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"/js/jquery-2.1.4.min" ofType:@"js"];
    [FileOperation copyFile:filePath toPath:jsDirectoryPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"/js/common" ofType:@"js"];
    [FileOperation copyFile:filePath toPath:jsDirectoryPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"/js/mobiscroll_date" ofType:@"js"];
    [FileOperation copyFile:filePath toPath:jsDirectoryPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"/js/mobiscroll" ofType:@"js"];
    [FileOperation copyFile:filePath toPath:jsDirectoryPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"/js/swiper-3.3.1.min" ofType:@"js"];
    [FileOperation copyFile:filePath toPath:jsDirectoryPath deleteIfExist:clearChache];
    
    //copy css files
    filePath = [[NSBundle mainBundle] pathForResource:@"/css/style" ofType:@"css"];
    [FileOperation copyFile:filePath toPath:cssDirectoryPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"/css/mobiscroll_date" ofType:@"css"];
    [FileOperation copyFile:filePath toPath:cssDirectoryPath deleteIfExist:clearChache];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"/css/arrowup" ofType:@"png"];
    [FileOperation copyFile:filePath toPath:cssDirectoryPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"/css/arrowup1" ofType:@"png"];
    [FileOperation copyFile:filePath toPath:cssDirectoryPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"/css/iconfont" ofType:@"eot"];
    [FileOperation copyFile:filePath toPath:cssDirectoryPath deleteIfExist:clearChache];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"/css/iconfont" ofType:@"svg"];
    [FileOperation copyFile:filePath toPath:cssDirectoryPath deleteIfExist:clearChache];
    filePath = [[NSBundle mainBundle] pathForResource:@"/css/iconfont" ofType:@"ttf"];
    [FileOperation copyFile:filePath toPath:cssDirectoryPath deleteIfExist:clearChache];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"/css/iconfont" ofType:@"woff"];
    [FileOperation copyFile:filePath toPath:cssDirectoryPath deleteIfExist:clearChache];
    
    //copy images file
    filePath = [[NSBundle mainBundle] pathForResource:@"/images/jzh" ofType:@"gif"];
    [FileOperation copyFile:filePath toPath:imagesDirectoryPath deleteIfExist:clearChache];
}


- (void)setupBPushWithLaunchOptions:(NSDictionary *)launchOptions {
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }

   // #warning 上线 AppStore 时需要修改BPushMode为BPushModeProduction 需要修改Apikey为自己的Apikey

    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"8DpN11EYbMCGLxB5MsU5vdKv" pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        DLog(@"从消息启动:%@",userInfo);
//        [BPush handleNotification:userInfo];
    }
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 打印到日志 textView 中
    DLog(@"********** iOS7.0之后 background **********");
    //杀死状态下，直接跳转到跳转页面。
    if (application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground)
    {
        if (self.isLaunchedByNotification){
            self.isLaunchedByNotification = NO;
            [self showSkipVC:userInfo];
        }
        
    }else if (application.applicationState == UIApplicationStateActive) {
        DLog(@"background is Activated Application ");
        // 此处可以选择激活应用提前下载邮件图片等内容。
        isBackGroundActivateApplication = YES;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"沃监控" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        typeof(self) __weak weakSelf = self;
        UIAlertAction *upgradeAction = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf showSkipVC:userInfo];
            }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:upgradeAction];
        if ([UserTool sharedUser].isLogin) {
            [self.tabBarController.selectedViewController presentViewController:alertController animated:YES completion:^{
            }];
        }else {
            [self.window.rootViewController presentViewController:alertController animated:YES completion:^{
                
            }];
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
    DLog(@"backgroud : %@",userInfo);
}

- (void)showSkipVC:(NSDictionary *)userInfo {
    //推送通知直接跳转到报表app
    NSString *urlStr = [userInfo objectForKey:@"url"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        // 网络错误
        if (error) {
            return ;
        }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"]intValue]!=0) {
                return;
            }
            // 获取channel_id
            NSString *myChannel_id = [BPush getChannelId];
            DLog(@"==%@",myChannel_id);
            [UserTool sharedUser].channelId = myChannel_id;
//            [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
//                if (result) {
//                    DLog(@"result ============== %@",result);
//                }
//            }];
//            
//            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
//                if (result) {
//                    DLog(@"设置tag成功");
//                }
//            }];
        }
    }];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
     DLog(@"didReceiveRemoteNotification");
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        DLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else//杀死状态下，直接跳转到跳转页面。
    {
        [UserTool sharedUser].notificationUserInfo = userInfo;
    }
    DLog(@"%@",userInfo);
}

- (void)handleNotificationEvent {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(quitAccount:) name:UserLogoutSuccessNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(loginSuccess:) name:UserLoginSuccessNotification object:nil];
}

- (void)quitAccount:(NSNotification *)notification {
    RegisterViewController *regVc = [[RegisterViewController alloc] init];
    BlueNavigationController *navi = [[BlueNavigationController alloc] initWithRootViewController:regVc];
    self.window.rootViewController = navi;
}

- (void)loginSuccess:(NSNotification *)notification {
    self.window.rootViewController = [[CustomTabBarController alloc] init];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
