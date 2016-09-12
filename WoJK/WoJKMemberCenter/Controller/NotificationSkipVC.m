//
//  NotificationSkipVC.m
//  WoJK
//
//  Created by Megatron on 16/5/20.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "NotificationSkipVC.h"
#import "Macro.h"

@interface NotificationSkipVC ()

@end

@implementation NotificationSkipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self showWebView];
    [self setupLeftBackButton];
    
    
//    [self setupPotraitDisplayView];
}

- (void)setupLeftBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(10, 10, 25, 25);
    [backButton setBackgroundImage:[UIImage imageNamed:@"report_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)leftBtnAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)showWebView {
    
    DLog(@"self.strurl = %@", self.urlStr);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0]];
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
//}

//- (BOOL)shouldAutorotate {
//    return NO;
//}

@end
