//
//  SkipViewController.m
//  WoJK
//
//  Created by Megatron on 16/6/24.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "SkipViewController.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "UDIDManager.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "BlueNavigationController.h"
#import "AuthenticationModel.h"
#import "UserTool.h"
#import "AppDelegate.h"
#import "Macro.h"

@interface SkipViewController ()

@end

@implementation SkipViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self authenticationDetection];
}

#pragma mark -是否已认证
- (void)authenticationDetection {
    NSString *udid = [UDIDManager getUDID];
    AppDelegate *delegate = ShareApp;
    [WJHUD showOnView:self.view];
    [RequestService authenticationDetectionWithUDID:udid result:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            AuthenticationModel *dataModel = (AuthenticationModel *)object;
            if ([dataModel.code isEqualToString:@"success"]) {//成功
                //走登录流程
                [UserTool sharedUser].authenticationState = YES;
                LoginViewController *loginVc = [[LoginViewController alloc] init];
                BlueNavigationController *navi = [[BlueNavigationController alloc] initWithRootViewController:loginVc];
                delegate.window.rootViewController = navi;
                //登录页面和手势处理
            }else {
                DLog(@"未认证");
                //认证页面和手势处理
                [UserTool sharedUser].authenticationState = NO;
                RegisterViewController *regVc = [[RegisterViewController alloc] init];
                BlueNavigationController *navi = [[BlueNavigationController alloc] initWithRootViewController:regVc];
                delegate.window.rootViewController = navi;
            }
        }else {
            DLog(@"%@", object);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UserTool sharedUser] exitApplication];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    return YES;
}
//当前viewcontroller默认的屏幕方向 - 横屏显示
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
