//
//  CommonWebViewVC.m
//  WoJK
//
//  Created by Megatron on 16/5/4.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "CommonWebViewVC.h"
#import "UserTool.h"
#import "RequestService.h"
#import "DeviceModel.h"
#import "Macro.h"

@interface CommonWebViewVC ()
{
    UIView *_statusBarView;
    NSString *_targetClass;
}
@end

@implementation CommonWebViewVC


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.backgroundColor = MAIN_COLOR;
    self.webView.scrollView.scrollEnabled = NO;
    if (self.targetId) {
        _targetClass = self.targetId;
    }else {
        NSString *reportUrl = [self.dataModel.reportUrl lastPathComponent];
        _targetClass = @"";
        NSRange range = [reportUrl rangeOfString:@"="];
        if (range.location != NSNotFound) {
            _targetClass = [reportUrl substringFromIndex:range.location+1];
        }
    }
    
    [self showWebView];
    [self registerHandler];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
//    [self sendAccessLog];
    
//    typeof(self) __weak weakSelf = self;
//    [self setLeftNavigationBarButtonItemWithImage:@"nav_icon_back" andAction:^{
//        [weakSelf setupPotraitDisplayView];
//    }];
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    _statusBarView.backgroundColor = MAIN_COLOR;
    [self.view addSubview:_statusBarView];

}

- (void)registerHandler {
    typeof(self) __weak weakSelf = self;
    [_bridge registerHandler:@"backAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf setupPotraitDisplayView];
        [weakSelf.navigationController popViewControllerAnimated:YES];
//        [weakSelf.webView goForward];
    }];
    
    [_bridge registerHandler:@"showKPIDetails" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf setupPotraitDisplayView];
        NSLog(@"data = %@@", data);
//        [weakSelf.navigationController popViewControllerAnimated:YES];
        //        [weakSelf.webView goForward];
        CommonWebViewVC *commonWebViewVC = [[CommonWebViewVC alloc] init];
        commonWebViewVC.dataModel = weakSelf.dataModel;
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSMutableString *fileName = [NSMutableString stringWithString:[data objectForKey:@"filename"]];
            if ([fileName hasSuffix:@"html"]) {
                [fileName replaceOccurrencesOfString:@".html" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, fileName.length)];
                commonWebViewVC.reportFileName = fileName;
            }else {
                commonWebViewVC.reportFileName = fileName;
            }
            commonWebViewVC.targetId = [data objectForKey:@"targetId"];
        }else {
            commonWebViewVC.reportFileName = @"jkbb-zbjs-xxxx";
        }
        self.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:commonWebViewVC animated:YES];
        
    }];
    
    [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        [[UserTool sharedUser] showSkipViewControlerWithAlert:NO];
    }];
}

- (void)callHandler {
    NSDictionary *bridgeDdataDict = @{
                                      @"userId" : [UserTool sharedUser].userId,
                                      @"modelId" : self.dataModel.moduleId,
                                      @"equipType" : @"1",
                                      @"tokenId" : [UserTool sharedUser].loginToken,
                                      @"hostUrl" : AppURL,
                                      @"targetClass": _targetClass,
                                      @"equipModel":[DeviceModel getCurrentDeviceModel]
                                      };
    
    [_bridge callHandler:@"setJSParams" data:bridgeDdataDict responseCallback:^(id response) {
        DLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)sendAccessLog {
  [RequestService sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:self.dataModel.moduleId andInterfaceName:@"NULL"];
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
    NSString *mobilechargingHtmlPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@.html", _reportFileName]];
    
    if ([fileManager fileExistsAtPath:mobilechargingHtmlPath]) {
        NSString* appHtml = [NSString stringWithContentsOfFile:mobilechargingHtmlPath encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:documentPath];
        [self.webView loadHTMLString:appHtml baseURL:baseURL];
    }else {
        //访问网络html文件
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
    return _dataModel.viewType==2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
