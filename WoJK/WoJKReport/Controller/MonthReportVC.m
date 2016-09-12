//
//  MonthReportVC.m
//  WoJK
//
//  Created by Megatron on 16/5/6.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "MonthReportVC.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "ReportResponseModel.h"
#import "Macro.h"
#import "MonitorReportModel.h"
#import "UserTool.h"
#import "DeviceModel.h"

@interface MonthReportVC ()

@end

@implementation MonthReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"监控月报";
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UserTool sharedUser].currentModuleId = [[UserTool sharedUser] getTabbarModuleIdWithIndex:1];
    [self sendAccessLog];
    if (!_responseModel) {
        [self getChannelInfo];
    }else {
        if(!_reportDataModel) {
            [self getMonitorReportData];
        }
    }
}

- (void)sendAccessLog {
    [RequestService sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:[[UserTool sharedUser] getTabbarModuleIdWithIndex:1] andInterfaceName:@"null"];
}

- (void)getChannelInfo {
    [WJHUD showOnView:self.view];
    typeof(self) __weak weakSelf = self;
    [RequestService getChannelInfoWithType:@"2" andResult:^(BOOL success, id object) {
        [WJHUD hideFromView:weakSelf.view];
        if (success) {
            ReportResponseModel *dataModel = (ReportResponseModel*)object;
            if ([dataModel.code isEqualToString:@"success"]) {
                //业务报表按钮
                _responseModel = dataModel;
                [weakSelf initMonthReportView];
            }else {
                [WJHUD showText:AlertMessageGetDataFailure onView:weakSelf.view completionBlock:^{
                    
                }];
            }
        }else {
            DLog(@"error = %@", object);
        }
    }];
}

- (void)initMonthReportView {
    [self initChannelInfo];
    [self addOtherServiceCollectionView];
    [self getMonitorReportData];
}

- (void)getMonitorReportData {
    [WJHUD showOnView:self.view];
    [RequestService getMonitorReportZdgzMonDataWithModuleId:@"" andResult:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            _reportDataModel = (MonitorReportModel *)object;
            if ([_reportDataModel.retCode isEqualToString:@"success"])
            {
                //更新数据
                _reportDataList = [_reportDataModel.data  objectForKey:@"dataList"];
                _currDataIndex = 0;
                _showedReportData = _reportDataList[_currDataIndex];
                [self updateDateLabel];
                if (!_serviceScrollView) {
                    [self addServiceScrollView];
                }
                
            }else {
                [WJHUD showText:AlertMessageGetDataFailure onView:self.view completionBlock:^{
                    
                }];
            }
        }else{
            DLog(@"error = %@", object);
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
