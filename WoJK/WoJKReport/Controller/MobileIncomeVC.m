//
//  MobileChargingVC.m
//  WoJK
//
//  Created by Megatron on 16/4/20.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "MobileIncomeVC.h"
#import "Macro.h"
#import "IncomeTrendVC.h"

@interface MobileIncomeVC ()
{
    UIView *_statusBarView;
}
@end

@implementation MobileIncomeVC

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self updateWebView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBackButton];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = ColorWithRGB(56, 183, 240);
    self.webView.backgroundColor = ColorWithRGB(56, 183, 240);
    self.webView.scrollView.backgroundColor = ColorWithRGB(56, 183, 240);
    
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    _statusBarView.backgroundColor = MAIN_COLOR;
    [self.view addSubview:_statusBarView];
    
    
    [_bridge registerHandler:@"backAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self setupPotraitDisplayView];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [_bridge registerHandler:@"historyTrend" handler:^(id data, WVJBResponseCallback responseCallback) {
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:[[IncomeTrendVC alloc] init] animated:NO];
    }];
    
    [self showWebView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)notification{
    [self updateWebView];
    [self showWebView];
    
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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mobilecharging" ofType:@"html"];
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


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
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
