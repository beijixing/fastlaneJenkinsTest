//
//  CompareKPIAndAreaVC.m
//  WoJK
//
//  Created by Megatron on 16/5/21.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "CompareKPIAndAreaVC.h"
#import "RequestService.h"
#import "UserTool.h"
#import "DeviceModel.h"
#import "Macro.h"
#import "AreaDataModel.h"

@interface CompareKPIAndAreaVC ()
{
    NSDictionary *_bridgeDdataDict;
    NSString *_reportFileName;
}
@property(nonatomic, strong) NSString *urlStr;
@end

@implementation CompareKPIAndAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.backgroundColor = MAIN_COLOR;

    ReportModuleModel *reportModel;
    if ([UserTool sharedUser].tabbarModuleInfo.reportModuleArr.count>3) {
        reportModel  = [UserTool sharedUser].tabbarModuleInfo.reportModuleArr[3];
        NSMutableString *reportFileName = [[NSMutableString alloc] initWithString:[reportModel.reportUrl lastPathComponent]];
        [reportFileName replaceOccurrencesOfString:@".html" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, reportFileName.length)];
        _reportFileName = reportFileName;
    }
    
    [self setupLandScapeDisplayView];
    [self updateWebView];
    [self showWebView];
    [self sendAccessLog];
}

- (void)interactionWithJS {
    typeof(self) __weak weakSelf = self;
    [_bridge registerHandler:@"backAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self setupPotraitDisplayView];
//        [weakSelf callJSHandler];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        [[UserTool sharedUser] showSkipViewControlerWithAlert:NO];
    }];
    
    //data.codes, data.equipType, data.userId, data.tokenId, data.areas
    NSLog(@"self.kpiDict=%@",self.kpiDict);
    
    NSString *areas = [self formatAreaObjectToString:[self.areaDict allKeys]];
    NSString *kpiCodes = [self formatArrObjectToString:[self.kpiDict allKeys]];
    _bridgeDdataDict = @{
                               @"areas" : areas,
                               @"codes" : kpiCodes,
                               @"equipType" : @"1",
                               @"userId" : [UserTool sharedUser].userId,
                               @"tokenId" : [UserTool sharedUser].loginToken,
                               @"hostUrl" : AppURL,
                               @"equipModel":[DeviceModel getCurrentDeviceModel]
                               };
    
    [_bridge callHandler:@"setJSParams" data:_bridgeDdataDict responseCallback:^(id response) {
        DLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (NSString *)formatAreaObjectToString:(NSArray *)strArr {
    NSMutableString *str =[[NSMutableString alloc] init];
    NSMutableArray *temArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<strArr.count;  i++ ) {
        AreaDataModel *dataModel = [self.areaDict objectForKey:strArr[i]];
        if (dataModel.flag == 1) {
            [temArr insertObject:dataModel atIndex:0];
        }else{
            [temArr addObject:dataModel];
        }
    }
    
    for (int i = 0; i<temArr.count;  i++) {
        AreaDataModel *dataModel = temArr[i];
        [str appendString:dataModel.areaCode];
        if (i<strArr.count-1) {
            [str appendString:@","];
        }
    }
    return str;
}

- (NSString*)formatArrObjectToString:(NSArray *)strArr {
    NSMutableString *str =[[NSMutableString alloc] init];
    for (int i = 0; i<strArr.count;  i++) {
        [str appendString:strArr[i]];
        if (i<strArr.count-1) {
            [str appendString:@","];
        }
    }
    return str;
}

- (void)sendAccessLog {
    [RequestService sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:[UserTool sharedUser].currentModuleId andInterfaceName:@"NULL"];
}

- (void)updateWebView {
    if (self.webView) {
        self.webView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
        DLog(@" self.view.bounds(x,y,w= %f,h=%f) ", self.webView.frame.size.width,self.webView.frame.size.height );
    }
}

- (void)showWebView {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *warningHtmlPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@.html", _reportFileName]];
    
    if ([fileManager fileExistsAtPath:warningHtmlPath]) {
        NSString* appHtml = [NSString stringWithContentsOfFile:warningHtmlPath encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:documentPath];
        [self.webView loadHTMLString:appHtml baseURL:baseURL];
    }else {
        NSString *filePath = [NSString stringWithFormat:@"%@%@.html", [UserTool sharedUser].h5FileDownloadUrl, _reportFileName];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
        [self.webView loadRequest:request];
    }
    
    [self interactionWithJS];
}

//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//   
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    
//}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate{
    return YES;
}
//当前viewcontroller默认的屏幕方向 - 横屏显示
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
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
