//
//  CustomTabBarController.m
//  WoJK
//
//  Created by Megatron on 16/4/14.
//  Copyright (c) 2016年 zhilong. All rights reserved.
//

#import "CustomTabBarController.h"
#import "MemberCenterVC.h"
#import "WarningVC.h"
#import "BenchmarkingVC.h"
#import "BlueNavigationController.h"
#import "DailyReportVC.h"
#import "MonthReportVC.h"
#import "Macro.h"
#import "RequestService.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BlueNavigationController *wojkDayReportNavi = [[BlueNavigationController alloc] initWithRootViewController:[[DailyReportVC alloc] init]];
    wojkDayReportNavi.tabBarItem.title = @"监控日报";
    wojkDayReportNavi.tabBarItem.image = [[UIImage imageNamed:@"tabBar_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    wojkDayReportNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_1_action"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    BlueNavigationController *wojkMonthReportNavi = [[BlueNavigationController alloc] initWithRootViewController:[[MonthReportVC alloc] init]];
    wojkMonthReportNavi.tabBarItem.title = @"监控月报";
    wojkMonthReportNavi.tabBarItem.image = [[UIImage imageNamed:@"tabBar_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    wojkMonthReportNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_2_action"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    BlueNavigationController *warningNavi = [[BlueNavigationController alloc] initWithRootViewController:[[WarningVC alloc] init]];
    warningNavi.tabBarItem.title = @"异动告警";
    warningNavi.tabBarItem.image = [[UIImage imageNamed:@"tabBar_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    warningNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_3_action"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [RequestService getItemWarnNumWithResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dataDict = object;//code num
            if ([[dataDict objectForKey:@"code"] isEqualToString:@"success"]) {
                if ([[dataDict objectForKey:@"num"] integerValue] != 0) {
                    warningNavi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@",   [dataDict objectForKey:@"num"]];
                }
            }
        }
    }];
    
    
    BlueNavigationController *benchmarkingNavi = [[BlueNavigationController alloc] initWithRootViewController:[[BenchmarkingVC alloc] init]];
    benchmarkingNavi.tabBarItem.title = @"横向对标";
    benchmarkingNavi.tabBarItem.image = [[UIImage imageNamed:@"tabBar_4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    benchmarkingNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_4_action"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    BlueNavigationController *memberCenterNavi = [[BlueNavigationController alloc] initWithRootViewController:[[MemberCenterVC alloc] init]];
    memberCenterNavi.tabBarItem.title = @"我的";
    memberCenterNavi.tabBarItem.image = [[UIImage imageNamed:@"tabBar_5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    memberCenterNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_5_action"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorWithRGB(160, 160, 160), NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:11.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MAIN_COLOR, NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    self.viewControllers = @[wojkDayReportNavi, wojkMonthReportNavi, warningNavi, benchmarkingNavi, memberCenterNavi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    UIViewController *currentDisplayVC = [self getCurrentDisplayViewController];
    return [currentDisplayVC shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIViewController *currentDisplayVC = [self getCurrentDisplayViewController];
    return [currentDisplayVC supportedInterfaceOrientations];
}


-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    UIViewController *currentDisplayVC = [self getCurrentDisplayViewController];
    return [currentDisplayVC preferredInterfaceOrientationForPresentation];
}


- (UIViewController *)getCurrentDisplayViewController {
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)self.selectedViewController;
            return [nav.viewControllers lastObject];
    } else {
            return self.selectedViewController;
    }

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
