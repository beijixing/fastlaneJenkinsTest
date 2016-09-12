//
//  PDFDisplayVC.m
//  WoJK
//
//  Created by Megatron on 16/5/24.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "PDFDisplayVC.h"
#import "Macro.h"
#import "RequestService.h"
#import "DeviceModel.h"
#import "PullDownMenu.h"

@interface PDFDisplayVC ()
{
    UIView *_statusBarView;
    NSString *_pdfpath;
    UILabel *_titleLabel;
    PullDownMenu *_pullMenu;
}
@property (nonatomic, strong) NSMutableArray *pdfDateArr;
@end

@implementation PDFDisplayVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_COLOR;
    _pdfDateArr = [[NSMutableArray alloc] init];
    
    [self setupLandScapeDisplayView];
    [self updateWebView];
//    [self getPdfFilePath];
//    [self getPdfTitle];
    [self getPdfAcctDataList];
    [self setupNavigationView];
    
    NSMutableString *mutStr = [[NSMutableString alloc] initWithString:self.dataModel.moduleName];
    [mutStr replaceOccurrencesOfString:@"\\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutStr.length)];
    _titleLabel.text = mutStr;
}

- (void)setupNavigationView {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(4, 2, 40, 40);
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    _titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(45, 2, MainScreenWidth/2, 40)];
    _titleLabel.text = @"pdf文档测试";
    _titleLabel.font = [UIFont fontWithName:@"Arial" size:16.0];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    
    _pullMenu = [[PullDownMenu alloc] initWithFrame:CGRectMake(MainScreenWidth - 150, 0, 150, 44)];
    _pullMenu.showListFrame = CGRectMake(MainScreenWidth - 150, 0, 150, MainScreenHeight);
    _pullMenu.hideListFrame = CGRectMake(MainScreenWidth - 150, 0, 150, 44);
    _pullMenu.indicatorImageName = @"report_right";
//    pullMenu.dataSource = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
    [self.view addSubview:_pullMenu];
}

- (void)backAction:(UIButton*)btn {
    [self setupPotraitDisplayView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getPdfTitle {
    [RequestService getPdfReportTitleWithModuleId:self.dataModel.moduleId andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dataDict = object;
            if ([[dataDict objectForKey:@"retCode"] isEqualToString:@"success"]) {
                _titleLabel.text = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"name"]];
            }
        }else {
            DLog(@"error = %@", object);
        }
    }];

}

- (void)getPdfAcctDataList {
    [RequestService getPdfReportAcctSelectListWithModuleId:self.dataModel.moduleId andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dataModel = object;
            NSDictionary *selectItemData = [dataModel objectForKey:@"selectItemData"];
            if ([[selectItemData objectForKey:@"retCode"] isEqualToString:@"success"]) {
                    NSDictionary *dataListA = [selectItemData objectForKey:@"dataList"];
                id dataList = [dataListA objectForKey:@"dataList"];
                if ([dataList isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dataListB = dataList;
                    [_pdfDateArr addObject:dataListB];
                    [self getPdfFilePath:[dataListB objectForKey:@"key"]];
                }else if([dataList isKindOfClass:[NSArray class]]){
                    NSArray *dataArr = dataList;
                    [_pdfDateArr addObjectsFromArray:dataArr];
                    if (_pdfDateArr.count>0) {
                        NSDictionary *accDateDict = [_pdfDateArr objectAtIndex:0];
                        [self getPdfFilePath:[accDateDict objectForKey:@"key"]];
                    }
                }
                [self setupPullMenu];
            }
        }else{
            DLog(@"error = %@", object);
        }
    }];
}

- (void)setupPullMenu {
    NSMutableArray *daeArr = [[NSMutableArray alloc] init];
    for (NSDictionary *tempDict in _pdfDateArr) {
        [daeArr addObject:[tempDict objectForKey:@"value"]];
    }
    _pullMenu.dataSource = daeArr;
    if (_pdfDateArr.count>0) {
        [_pullMenu setDefaultDataId:0];
        typeof(self) __weak weeakSelf = self;
        _pullMenu.getSelectedDataIdx = ^(NSInteger idx, NSString *txt){
            if (idx < self.pdfDateArr.count) {
                NSDictionary *dateDict = weeakSelf.pdfDateArr[idx];
                [weeakSelf getPdfFilePath:[dateDict objectForKey:@"key"]];
            }
           
        };
    }
}

- (void)getPdfFilePath:(NSString *)accDate {
//    //
    [RequestService getPdfReportFileWithModuleId:self.dataModel.moduleId andAcctDate:accDate andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dataDict = object;
            NSDictionary *pdfFileData = [dataDict objectForKey:@"pdfFileData"];
            if ([[pdfFileData objectForKey:@"retCode"] isEqualToString:@"success"]) {
                _pdfpath = [pdfFileData objectForKey:@"path"];
//                _titleLabel.text = [NSString stringWithFormat:@"%@", [pdfFileData objectForKey:@"name"]];
//                [self updateWebView];
                [self showWebView];
//                [self addBackBtn];
            }else {
                DLog(@"获取文件路径失败");
            }
        }else {
            DLog(@"error=%@", object);
        }
    }];
}

- (void)sendAccessLog {
    [RequestService sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:self.dataModel.moduleId andInterfaceName:@"NULL"];
}

- (void)updateWebView {
    if (self.webView) {
        self.webView.frame = CGRectMake(0, 44, MainScreenWidth, MainScreenHeight-44);
        DLog(@" self.view.bounds(x,y,w= %f,h=%f) ", self.webView.frame.size.width,self.webView.frame.size.height );
    }
}

- (void)showWebView {

    NSString *urlStr = [NSString stringWithFormat:@"%@?file=/WO_UnicomPro/%@", self.dataModel.reportUrl, _pdfpath];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
}

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

@end
