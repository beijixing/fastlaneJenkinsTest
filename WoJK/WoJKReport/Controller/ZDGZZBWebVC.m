//
//  JKRBWebVC.m
//  WoJK
//
//  Created by 郑光龙 on 16/7/7.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "ZDGZZBWebVC.h"
#import "Macro.h"
#import "RequestService.h"
#import "DeviceModel.h"
#import "UserTool.h"

@interface ZDGZZBWebVC ()
{
    UIView *_statusBarView;
}
@end

@implementation ZDGZZBWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.backgroundColor = MAIN_COLOR;
    self.webView.scrollView.scrollEnabled = NO;
    
    [self showWebView];
    [self registerHandler];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self sendAccessLog];
    
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    _statusBarView.backgroundColor = MAIN_COLOR;
    [self.view addSubview:_statusBarView];

}

- (void)registerHandler {
    typeof(self) __weak weakSelf = self;
    [_bridge registerHandler:@"backAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self setupPotraitDisplayView];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        [[UserTool sharedUser] showSkipViewControlerWithAlert:NO];
    }];
}

- (void)callHandler {
    NSString *kpiCode = [NSString stringWithFormat:@"%@", [self.dataDict objectForKey:@"kpiCode"]];
    NSDictionary *bridgeDdataDict = @{
                                      @"userId" : [UserTool sharedUser].userId,
                                      @"modelId" : kpiCode,
                                      @"equipType" : @"1",
                                      @"tokenId" : [UserTool sharedUser].loginToken,
                                      @"hostUrl" : AppURL,
                                      @"equipModel":[DeviceModel getCurrentDeviceModel]
                                      };
    
    [_bridge callHandler:@"setJSParams" data:bridgeDdataDict responseCallback:^(id response) {
        DLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)sendAccessLog {
    [RequestService sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:[NSString stringWithFormat:@"%@", [self.dataDict objectForKey:@"kpiCode"]] andInterfaceName:@"NULL"];
}


- (void)orientationChanged:(NSNotification *)notification{
    [self updateWebView];
    //    [self showWebView];
    
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
    /*
     先从文件保存目录中查找h5页面文件存在否，存在使用H5页面显示，不存在加载mainBundle 中的H5页面。
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *mobilechargingHtmlPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@.html",self.reportFileName]];
    
    if ([fileManager fileExistsAtPath:mobilechargingHtmlPath]) {
        NSString* appHtml = [NSString stringWithContentsOfFile:mobilechargingHtmlPath encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:documentPath];
        [self.webView loadHTMLString:appHtml baseURL:baseURL];
    }else {
        NSString *filePath = [NSString stringWithFormat:@"%@%@.html", [UserTool sharedUser].h5FileDownloadUrl, _reportFileName];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
        [self.webView loadRequest:request];
    }
    [self callHandler];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
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
