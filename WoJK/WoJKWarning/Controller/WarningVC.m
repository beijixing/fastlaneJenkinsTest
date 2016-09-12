//
//  WarningVC.m
//  WoJK
//
//  Created by Megatron on 16/4/14.
//  Copyright (c) 2016年 zhilong. All rights reserved.
//

#import "WarningVC.h"
#import "Macro.h"
#import "WarningSettingVC.h"
#import "DailyWarningWebVC.h"
#import "GetUserInfoModel.h"
#import "UserTool.h"
#import "DeviceModel.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "ReportResponseModel.h"
#import "ReportModuleModel.h"
#import "MJRefresh.h"

@interface WarningVC ()
{
    ReportResponseModel *_responseModel;
    NSString *_reportFileName;
}
@end

@implementation WarningVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [UserTool sharedUser].currentModuleId = [[UserTool sharedUser] getTabbarModuleIdWithIndex:2];
    [self sendAccessLog:[UserTool sharedUser].currentModuleId];
    [self callHandler];
    [RequestService getItemWarnNumWithResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dataDict = object;//code num
            if ([[dataDict objectForKey:@"code"] isEqualToString:@"success"]) {
                if ([[dataDict objectForKey:@"num"] integerValue] != 0) {
                    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@",   [dataDict objectForKey:@"num"]];
                }else {
                     self.navigationController.tabBarItem.badgeValue = nil;
                }
            }
        }
    }];
    
    if (!_responseModel) {
        [self getChannelInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_COLOR;
//    self.webView.backgroundColor = MAIN_COLOR;
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    self.webView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-64);
    self.navigationItem.title = @"异动告警";
    [self hideNavigationBarDividedLine];
//    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    statusBarView.backgroundColor = MAIN_COLOR;
//    [self.view addSubview:statusBarView];
    
    ReportModuleModel *reportModel;
    if ([UserTool sharedUser].tabbarModuleInfo.reportModuleArr.count>2) {
       reportModel  = [UserTool sharedUser].tabbarModuleInfo.reportModuleArr[2];
        NSMutableString *reportFileName = [[NSMutableString alloc] initWithString:[reportModel.reportUrl lastPathComponent]];
        [reportFileName replaceOccurrencesOfString:@".html" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, reportFileName.length)];
        _reportFileName = reportFileName;
    }
    
    [self initWebviewContent];
    [self showWebView];
    [self registerHandler];
}

- (void)registerHandler {
    typeof(self) __weak weakSelf = self;
    [_bridge registerHandler:@"dayWarningSetting" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.hidesBottomBarWhenPushed = YES;
        WarningSettingVC *warningVc = [[WarningSettingVC alloc] init];
        warningVc.isDayWarning = YES;
        [weakSelf.navigationController pushViewController:warningVc animated:YES];
        weakSelf.hidesBottomBarWhenPushed = NO;
    }];
    
    [_bridge registerHandler:@"monthWarningSetting" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.hidesBottomBarWhenPushed = YES;
        WarningSettingVC *warningVc = [[WarningSettingVC alloc] init];
        warningVc.isDayWarning = NO;
        [weakSelf.navigationController pushViewController:warningVc animated:YES];
        weakSelf.hidesBottomBarWhenPushed = NO;
    }];
    
    
    [_bridge registerHandler:@"dayWarningAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (_responseModel && _responseModel.reportModuleArr.count>0){
            ReportModuleModel *dataModel = _responseModel.reportModuleArr[0];
            [self sendAccessLog:dataModel.moduleId];
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dataModel.moduleURL]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dataModel.moduleURL]];
            }
        }
        DLog(@"dayWarningAction");
    }];
    
    [_bridge registerHandler:@"monthWarningAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (_responseModel && _responseModel.reportModuleArr.count>1) {
            ReportModuleModel *dataModel = _responseModel.reportModuleArr[1];
            [self sendAccessLog:dataModel.moduleId];
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dataModel.moduleURL]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dataModel.moduleURL]];
            }
        }
        DLog(@"monthWarningAction");
    }];
    
    [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        [[UserTool sharedUser] showSkipViewControlerWithAlert:NO];
    }];
}

- (void)callHandler {
    //data.userId, data.equipType, data.tokenId
    NSDictionary *bridgeDdataDict = @{
                                      @"userId" : [UserTool sharedUser].userId,
                                      @"equipType" : @"1",
                                      @"tokenId" : [UserTool sharedUser].loginToken,
                                      @"hostUrl" : AppURL,
                                      @"equipModel":[DeviceModel getCurrentDeviceModel]
                                      };
    //
    [_bridge callHandler:@"setJSParams" data:bridgeDdataDict responseCallback:^(id response) {
        DLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)sendAccessLog:(NSString *)modelId {
    [RequestService sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:modelId  andInterfaceName:@"null"];
}

- (void)getChannelInfo {
//    [WJHUD showOnView:self.view];
    [RequestService getChannelInfoWithType:@"3" andResult:^(BOOL success, id object) {
//        [WJHUD hideFromView:self.view];
        if (success) {
            ReportResponseModel *dataModel = (ReportResponseModel*)object;
            if ([dataModel.code isEqualToString:@"success"]) {
                //业务报表按钮
                _responseModel = dataModel;
            }else {
                [WJHUD showText:AlertMessageGetDataFailure onView:self.view completionBlock:^{
                    
                }];
            }
        }else {
            DLog(@"error = %@", object);
        }
    }];
}

- (void)initWebviewContent{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *warningHtmlPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@.html",_reportFileName ]];
    
    if ([fileManager fileExistsAtPath:warningHtmlPath]) {
        NSString* appHtml = [NSString stringWithContentsOfFile:warningHtmlPath encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:documentPath];
        [self.webView loadHTMLString:appHtml baseURL:baseURL];
    }else {
        NSString *filePath = [NSString stringWithFormat:@"%@%@.html", [UserTool sharedUser].h5FileDownloadUrl, _reportFileName];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
        [self.webView loadRequest:request];
    }
}

- (void)showWebView {
    [self callHandler];
    [self.webView.scrollView.header endRefreshing];
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
