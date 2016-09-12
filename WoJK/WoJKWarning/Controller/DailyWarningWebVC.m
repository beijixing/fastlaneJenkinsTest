//
//  DailyWarningWebVC.m
//  WoJK
//
//  Created by Megatron on 16/4/22.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "DailyWarningWebVC.h"
#import "Macro.h"
#import "DailyWarningVC.h"

@interface DailyWarningWebVC ()

@end

@implementation DailyWarningWebVC


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithRGB(56, 183, 240);
    self.webView.backgroundColor = ColorWithRGB(56, 183, 240);
    self.webView.scrollView.backgroundColor = ColorWithRGB(56, 183, 240);
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor = ColorWithRGB(56, 183, 240);
    [self.view addSubview:statusBarView];
    
    [_bridge registerHandler:@"backAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    [_bridge registerHandler:@"dailyWarning" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController pushViewController:[[DailyWarningVC alloc] init] animated:YES];
    }];
    
    [self showWebView];
}

- (void)showWebView {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mobile-dailytarget" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    DLog(@"shouldStartLoadWithRequest");
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
