//
//  IncomeTrendVC.m
//  WoJK
//
//  Created by Megatron on 16/4/21.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "IncomeTrendVC.h"
#import "Macro.h"
#import "MobileIncomeVC.h"

@interface IncomeTrendVC ()
{
    UIView *_statusBarView;
}
@end

@implementation IncomeTrendVC

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self updateWebView];
    
    [self setupStatusBarView];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_COLOR;
    self.webView.backgroundColor = MAIN_COLOR;
    self.webView.scrollView.backgroundColor = MAIN_COLOR;
    
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    _statusBarView.backgroundColor =MAIN_COLOR;
    [self.view addSubview:_statusBarView];
    
    [_bridge registerHandler:@"backAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self setupPotraitDisplayView];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [_bridge registerHandler:@"reginDevelop" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    
    [self showWebView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)notification{
    [super updateWebView];
    [self showWebView];
    [self setupStatusBarView];
}

- (void)setupStatusBarView {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        DLog(@"Landscape");
        _statusBarView.hidden = YES;
    }else if (orientation == UIInterfaceOrientationPortrait) {
        DLog(@"Portrait");
        _statusBarView.hidden = NO;
    }
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

- (BOOL)shouldAutorotate {
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
