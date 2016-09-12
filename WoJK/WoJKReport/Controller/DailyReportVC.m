//
//  DailyReportVC.m
//  WoJK
//
//  Created by Megatron on 16/5/6.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "DailyReportVC.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "HomePageDataManager.h"
#import "Macro.h"
#import "MonitorReportModel.h"
#import "ReportResponseModel.h"
#import "GeneralDataModel.h"
#import "UserTool.h"
#import "DeviceModel.h"
#import "UIImageView+WebCache.h"
#import "ZipArchive.h"

@interface DailyReportVC ()<ZipArchiveDelegate>
{
    __block UIImageView *_imageTast;
    NSArray *_updateFileNameArr;
    NSString *_updateFileRootAddress;
    int _updateFileNum;
    NSString *_versionCode;
}
@end

@implementation DailyReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [UserTool sharedUser].currentModuleId = [[UserTool sharedUser] getTabbarModuleIdWithIndex:0];
    self.navigationItem.title = @"监控日报";
    [self sendLoginRecordData];
    [self checkH5FileUpdate]; //正式版本中要取消注释，这样就能从服务器下载最新的H5页面了
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UserTool sharedUser].currentModuleId = [[UserTool sharedUser] getTabbarModuleIdWithIndex:0];
    [self sendAccessLog];
    if (!_responseModel) {
        [self getChannelInfo];
    }else {
        if(!_reportDataModel) {
            [self getMonitorReportData];
        }
    }
}

- (void)checkH5FileUpdate{
    NSString *version = [NSString stringWithFormat:@"%@", [UserTool sharedUser].h5FileVersion];
    [RequestService getH5UpdateWithVersionCode:version andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *h5update = object;
            if (!h5update) {
                DLog(@"检测h5更新返回数据为空");
                return;
            }
            NSString *versionCode = [NSString stringWithFormat:@"%@", [h5update objectForKey:@"versionCode"]];
            if (![versionCode isEqualToString:version]) {
                //版本不同去下载更新
                _versionCode = [h5update objectForKey:@"versionCode"];
                _updateFileRootAddress = [h5update objectForKey:@"downLoadUrl"];
                [UserTool sharedUser].h5FileDownloadUrl = _updateFileRootAddress;
                [self getH5UpdateFiles:[h5update objectForKey:@"updateFiles"]];
            }
            
        }else {
            DLog(@"error = %@", object);
        }
    }];
}

- (void)getH5UpdateFiles:(NSString *)files {
    NSString *filesCopy = [NSString stringWithFormat:@"%@", files];
    _updateFileNameArr = [filesCopy componentsSeparatedByString:@","];
    _updateFileNum = 0;
    [self setupActivityIndicatorView];
    [self downLoadNewH5File:_updateFileNameArr[_updateFileNum]];
}

- (void)downLoadNewH5File:(NSString *)fileName {
    NSString *fileSavePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    fileSavePath = [NSString stringWithFormat:@"%@/%@", fileSavePath, fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileSavePath]) {
        //此处如果不删除已有的文件，下载下来的文件不会生效
        [[NSFileManager defaultManager] removeItemAtPath:fileSavePath error:nil];
    }
   
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",_updateFileRootAddress,fileName];
    [RequestService downFileWithUrl:urlStr andFilePath:fileSavePath andResult:^(BOOL success, id object) {
        _updateFileNum++;
        if (_updateFileNum < _updateFileNameArr.count) {
            DLog(@"已完成下载文件的数量：%d", _updateFileNum);
            [self downLoadNewH5File:_updateFileNameArr[_updateFileNum]];
        }else {
            [self stopActivityIndicatorView];
            [UserTool sharedUser].h5FileVersion = _versionCode;
            DLog(@"下载完成");
        }
        
    }];
}

- (void)sendAccessLog {
    [RequestService sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:[[UserTool sharedUser] getTabbarModuleIdWithIndex:0] andInterfaceName:@"null"];
}

- (void)sendLoginRecordData {
    [RequestService sendRecordLoadLogWithEquipModel:[DeviceModel getCurrentDeviceModel]];
}

- (void)getChannelInfo {
    [WJHUD showOnView:self.view];
    [RequestService getChannelInfoWithType:@"1" andResult:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            ReportResponseModel *dataModel = (ReportResponseModel*)object;
            if ([dataModel.code isEqualToString:@"success"]) {
                //业务报表按钮
                _responseModel = dataModel;
                [self initChannelInfo];
                [self addOtherServiceCollectionView];
                [self getMonitorReportData];
//                [self testImageView];
            }else {
                [WJHUD showText:AlertMessageGetDataFailure onView:self.view completionBlock:^{
                    
                }];
                _responseModel = nil;
            }
        }else {
            DLog(@"error = %@", object);
        }
    }];
}

- (void)getMonitorReportData {
//    [WJHUD showOnView:self.view];
    [RequestService getMonitorReportZdgzDataWithModuleId:@"" andResult:^(BOOL success, id object) {
//        [WJHUD hideFromView:self.view];
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
                _reportDataModel = nil;
            }
        }else{
            DLog(@"error = %@", object);
        }
    }];
    
}

@end
