//
//  ServiceDevelopTrend.m
//  WoJK
//
//  Created by Megatron on 16/4/21.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "ServiceDevelopTrend.h"
#import "Macro.h"
@interface ServiceDevelopTrend ()

@end

@implementation ServiceDevelopTrend

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
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [_bridge registerHandler:@"reginDevelop" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    
    [self showWebView];
}

- (void)showWebView {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mobilecharging-historycal-trends" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    DLog(@"shouldStartLoadWithRequest");
    return YES;
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
