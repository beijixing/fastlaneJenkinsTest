//
//  RequestService.m
//  E-attendance
//
//  Created by Kevin on 14-9-24.
//  Copyright (c) 2014年 bitwayapp. All rights reserved.
//

#import "RequestService.h"
#import "Macro.h"
#import "AFNetworking.h"
#import "ParamsHandle.h"
#import "UserTool.h"
#import "Constant.h"
//#import "JSONHTTPClient.h"

#pragma mark - Import Models
//#import "RegistAppJSONModel.h"
#import "LoginModel.h"
#import "GetUserInfoModel.h"
#import "LogoutModel.h"

//dataModel
#import "AppUpgradeModel.h"
#import "AuthenticationModel.h"
#import "SMSCodeModel.h"
#import "DeviceBindingModel.h"
#import "GeneralDataModel.h"
#import "MonitorReportModel.h"
#import "UDIDManager.h"
#import "HomePageDataManager.h"
#import "WarningSettingDataModel.h"
#import "KPIModel.h"
#import "KPIDataModel.h"
#import "ReportResponseModel.h"
#import "AreaResponseModel.h"
#import "AboutUsDataModel.h"
#import "SystemMessageModel.h"
#import "NewSystemMessageModel.h"
#import "AFNetBase.h"
#import "DeviceModel.h"

@implementation RequestService
+(void)getEncryptedPasswordWiithPassword:(NSString *)password userName:(NSString *)userName andResultBlock:(void(^)(BOOL success,id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@", AppURL, GetPassword, userName, password];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary  *executeStatus = [object objectForKey:@"executeStatus"];
            if( executeStatus )
            {
                GeneralDataModel *model = [[GeneralDataModel alloc]initWithDictionary:executeStatus];
                resultBlock(YES, model);
            }

        }else {
            resultBlock(NO, object);
        }
    }];
}

+(void)loginWithUserName:(NSString *)userName password:(NSString *)password resultBlock:(void (^)(BOOL, id))resultBlock
{
    //?userId=''&userPW=''
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@?userId=%@&userPW=%@", AppURL, GetUserValid, userName, password];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSError *error;
            NSDictionary  *userValid = [object objectForKey:@"userValid"];
            LoginModel *model = [[LoginModel alloc]initWithDictionary:userValid error:&error];
            resultBlock(YES,model);
            DLog(@"object = %@", object);
        }else {
            resultBlock(NO,object);
        }
    }];
}

+(void)feedBackWithContent:(NSString *)content result:(void (^)(BOOL, id))resultBlock
{
    NSString *urlContent = [[NSString stringWithFormat:@"%@", content] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@/%@/%@", AppURL, SetUertSuggestion, [UserTool sharedUser].userId, urlContent, [UIDevice currentDevice].model, [UserTool sharedUser].loginToken];
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary  *executeStatus = [object objectForKey:@"executeStatus"];
            GeneralDataModel *model = [[GeneralDataModel alloc]initWithDictionary:executeStatus];
            if([model.code isEqualToString:@"invalid"]){
                [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
            }else {
                resultBlock(YES,model);
            }
        } else {
            resultBlock(NO, object);
        }
    }];
    
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[SetUertSuggestion lastPathComponent]];
}

+(void)upgradeDetectionWithResult:(void(^)(BOOL success,id object))resultBlock {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/1/%@", AppURL, GetAppUpdate, appVersion];
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSError *error;
            NSDictionary  *appUpdate = [object objectForKey:@"appUpdate"];
            AppUpgradeModel *model = [[AppUpgradeModel alloc]initWithDictionary:appUpdate error:&error];
            resultBlock(YES, model);
        }else {
            resultBlock(NO, object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetAppUpdate lastPathComponent]];
}

+ (void)authenticationDetectionWithUDID:(NSString *)udid result:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@", AppURL, GetQueryLoadInfo, [UserTool sharedUser].userId, udid];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSError *error;
            NSDictionary  *executeStatus = [object objectForKey:@"executeStatus"];
            AuthenticationModel *model = [[AuthenticationModel alloc]initWithDictionary:executeStatus error:&error];
            resultBlock(YES,model);
        }else {
            resultBlock(NO,object);
        }
    }];
    
}

+ (void)deviceBindingDetectionWithUDID:(NSString *)udid result:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@", AppURL, GetQueryEquipInfo, [UserTool sharedUser].userId, udid];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary  *queryEquipInfo = [object objectForKey:@"queryEquipInfo"];
            if( queryEquipInfo )
            {
                DeviceBindingModel *model = [[DeviceBindingModel alloc]initWithDictionary:queryEquipInfo];
                resultBlock(YES,model);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetQueryEquipInfo lastPathComponent]];
}

+ (void)getAuthenticationSMSCodeWithUserId:(NSString *)userId result:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@", AppURL, GetSMSValid, userId];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSError *error;
            NSDictionary  *smsValid = [object objectForKey:@"smsValid"];
            if( smsValid )
            {
                DLog(@"smsValid = %@", smsValid);
                SMSCodeModel *model = [[SMSCodeModel alloc]initWithDictionary:smsValid error:&error];
                resultBlock(YES, model);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetSMSValid lastPathComponent]];
}

+ (void)deleteBidingEquipWithEquipTpe:(NSString *)eType UUID:(NSString *)uuid result:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@", AppURL, DelBindingEquip, [UserTool sharedUser].userId, eType, uuid, [UserTool sharedUser].loginToken];
   
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary  *executeStatus = [object objectForKey:@"executeStatus"];
            if( executeStatus )
            {
                GeneralDataModel *model = [[GeneralDataModel alloc]initWithDictionary:executeStatus];
                resultBlock(YES, model);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"nul" andInterfaceName:[DelBindingEquip lastPathComponent]];
}

//绑定设备
+ (void)bindingEquipWithUDID:(NSString *)udid andChanneId:(NSString *)channeId andResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@/%@/%@", AppURL, BindingEquipNew, [UserTool sharedUser].userId, udid, [UserTool sharedUser].loginToken, channeId];
 
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary  *executeStatus = [object objectForKey:@"executeStatus"];
            if( executeStatus )
            {
                GeneralDataModel *model = [[GeneralDataModel alloc]initWithDictionary:executeStatus];
                resultBlock(YES, model);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[BindingEquipNew lastPathComponent]];
}

+(void)getChannelInfoWithType:(NSString *)type andResult:(void(^)(BOOL success, id object))resultBlock{
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@/%@", AppURL, GetChannel, [UserTool sharedUser].userId,type, [UserTool sharedUser].loginToken];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *channel  =[object  objectForKey:@"channel"];
            ReportResponseModel *dataModel = [[ReportResponseModel alloc] init];
            [dataModel updateResponseModelWithDataDict:channel];
            
            if([dataModel.code isEqualToString:@"invalid"] && ![type isEqualToString:@"3"]){
                [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
                
            }else {
                resultBlock(YES, dataModel);
            }
            
            DLog(@"object = %@", object);
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetChannel lastPathComponent]];
}


+ (void)getPushStatusWithType:(NSString *)type andResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@/%@", AppURL, GetPushStatus, [UserTool sharedUser].userId, type, [UserTool sharedUser].loginToken];
   
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSString *flag = [NSString stringWithFormat:@"%@", [object objectForKey:@"FLAG"]];
            resultBlock(YES, flag);
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetPushStatus lastPathComponent]];
}


+ (void)setPushStatusWithType:(NSString *)type andStatus:(NSString *)status andResult:
    (void(^)(BOOL success, id object))resultBlock {
    
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@", AppURL, SetPushManage, [UserTool sharedUser].userId, type,status,[UserTool sharedUser].loginToken];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary  *executeStatus = [object objectForKey:@"executeStatus"];
            if( executeStatus )
            {
                GeneralDataModel *model = [[GeneralDataModel alloc]initWithDictionary:executeStatus];
                if([model.code isEqualToString:@"invalid"]){
                    [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
                }else {
                    resultBlock(YES, model);
                }
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[SetPushManage lastPathComponent]];
}

#pragma mark设置用户监控告警指标
+ (void)setDailySettingWithTargetId:(NSString *)targetId targetType:(NSString*)type operate:(NSString *)operateType andResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@/%@/%@/%@", AppURL, SetDailySetting, [UserTool sharedUser].userId, targetId, type, operateType,[UserTool sharedUser].loginToken];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary  *executeStatus = [object objectForKey:@"executeStatus"];
            if( executeStatus )
            {
                GeneralDataModel *model = [[GeneralDataModel alloc]initWithDictionary:executeStatus];
                if([model.code isEqualToString:@"invalid"]){
                    [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
                }else {
                    resultBlock(YES, model);
                }
            }
        }else {
                resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[SetDailySetting lastPathComponent]];
}

#pragma mark 获取首页监控报表数据
+ (void)getMonitorReportZdgzDataWithModuleId:(NSString *)moduleId andResult:(void(^)(BOOL success, id object))resultBlock{
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@", AppURL, GetMonitorReportZdgzData, [UserTool sharedUser].userId,[UserTool sharedUser].loginToken];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary  *root = [object objectForKey:@"root"];
            DLog(@"getMonitorReportZdgzDataWithModuleId = %@", object);
            if(root)
            {
                MonitorReportModel *model = [[MonitorReportModel alloc]initWithDict:root];
                if([model.retCode isEqualToString:@"invalid"]){
                    [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
                }else {
                    resultBlock(YES, model);
                }
            }
        }else {
                resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetMonitorReportZdgzData lastPathComponent]];
}

#pragma mark 获取重点关注指标月指标
+ (void)getMonitorReportZdgzMonDataWithModuleId:(NSString *)moduleId andResult:(void(^)(BOOL success, id object))resultBlock{
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@", AppURL, GetMonitorReportZdgzMonData, [UserTool sharedUser].userId,[UserTool sharedUser].loginToken];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary  *root = [object objectForKey:@"root"];
            DLog(@"getMonitorReportZdgzDataWithModuleId = %@", object);
            if(root)
            {
                MonitorReportModel *model = [[MonitorReportModel alloc]initWithDict:root];
                if([model.retCode isEqualToString:@"invalid"]){
                    [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
                }else {
                    resultBlock(YES, model);
                }
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetMonitorReportZdgzMonData lastPathComponent]];
}

#pragma mark 获取横向对标数据最大账期
+ (void)getMaxAcctDateWithModuleId:(NSString *)moduleId result:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@", AppURL, GetMaxAcctDate, @"10",[UserTool sharedUser].loginToken];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
           resultBlock(YES, object);
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetMaxAcctDate lastPathComponent]];
}

#pragma mark 获取横向对标设置区域列表
+ (void)getAreaListWithAreaId:(NSString *)area result:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@/%@", AppURL, GetAreaList, [UserTool sharedUser].userId, area,[UserTool sharedUser].loginToken];
   
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *hxdbAreaMap = [object objectForKey:@"hxdbAreaMap"];
            if (hxdbAreaMap) {
                AreaResponseModel *responseModel = [[AreaResponseModel alloc] initWithDictionary:hxdbAreaMap];
                if([responseModel.code isEqualToString:@"invalid"]){
                    [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
                }else {
                    resultBlock(YES, responseModel);
                }
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetAreaList lastPathComponent]];

}


#pragma mark 获取横向对标指标信息
+ (void)getKpiListWithResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@", AppURL, GetKpiList, [UserTool sharedUser].userId, [UserTool sharedUser].loginToken];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *kpiMap = [object objectForKey:@"hxdbKpiMap"];
            KPIModel *kpiModel = [[KPIModel alloc] initWithDictionary:kpiMap];
            if([kpiModel.code isEqualToString:@"invalid"]){
                [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
            }else {
                resultBlock(YES, kpiModel);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetKpiList lastPathComponent]];
}


#pragma mark 获取监控告警获取指标编码服务
+ (void)getDailyTargetSearchWithTargetType:(NSString*)type result:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@/%@", AppURL, GetDailyTargetSearch, [UserTool sharedUser].userId, type, [UserTool sharedUser].loginToken];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dailyTargetSearch = [object objectForKey:@"dailyTargetSearch"];
            if (dailyTargetSearch) {
                WarningSettingDataModel *dataModel = [[WarningSettingDataModel alloc] initWithDictionary:dailyTargetSearch];
                if([dataModel.code isEqualToString:@"invalid"]){
                    [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
                }else {
                    resultBlock(YES, dataModel);
                }
            }

        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetDailyTargetSearch lastPathComponent]];
}

#pragma mark 获取当前用户所有收到的公告信息
+ (void)getSystemNoticeListWithResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@", AppURL, GetSystemNoticeList, [UserTool sharedUser].userId, [UserTool sharedUser].loginToken];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSMutableArray *systemMsgArr = [[NSMutableArray alloc] init];
            if ([object isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dataDict in object) {
                    SystemMessageModel *messageModel = [[SystemMessageModel alloc] initWithDictionary:dataDict];
                    [systemMsgArr addObject:messageModel];
                }
                resultBlock(YES, systemMsgArr);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetSystemNoticeList lastPathComponent]];
}

#pragma mark 获取公告的详细信息
+ (void)getSystemNoticeInfoWithId:(NSString *)noticeId andResult:(void(^)(BOOL success, id object))resultBlock{
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@/%@", AppURL, GetSystemNoticeInfo, [UserTool sharedUser].userId, noticeId,[UserTool sharedUser].loginToken];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
           
        
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetSystemNoticeInfo lastPathComponent]];
}

#pragma mark 设置公告为已读状态
+ (void)setSystemNoticeReadStatusWithId:(NSString *)noticeId andResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@/%@", AppURL, SetSystemNoticeReadStatus, [UserTool sharedUser].userId, noticeId, [UserTool sharedUser].loginToken];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *executeStatus = [object objectForKey:@"executeStatus"];
            if (executeStatus) {
                GeneralDataModel *dataModel = [[GeneralDataModel alloc] initWithDictionary:executeStatus];
                if([dataModel.code isEqualToString:@"invalid"]){
                    [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
                }else{
                    resultBlock(YES, dataModel);
                }
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[SetSystemNoticeReadStatus lastPathComponent]];
}

#pragma mark 获取当前用户收到的最新公告
+ (void)getSystemNoticeWithResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@", AppURL, GetSystemNotice, [UserTool sharedUser].userId, [UserTool sharedUser].loginToken];
   
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *noticeCH = [object objectForKey:@"noticeCH"];
            if ([noticeCH isKindOfClass:[NSDictionary class]]) {
                NewSystemMessageModel*dataModel = [[NewSystemMessageModel alloc] initWithDictionary:noticeCH];
                resultBlock(YES, dataModel);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetSystemNotice lastPathComponent]];
}


#pragma mark 关于我们
+ (void)queryAboutUsWithResult:(void(^)(BOOL success, id object))resultBlock
 {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1", AppURL, QueryAbout, appVersion];
     [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
         if (success) {
             if ([object isKindOfClass:[NSDictionary class]]) {
                 AboutUsDataModel *dataModel = [[AboutUsDataModel alloc] initWithDictionary:object];
                 if([dataModel.code isEqualToString:@"invalid"]){
                     [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
                 }else {
                     resultBlock(YES, dataModel);
                 }
             }
         }else {
             resultBlock(NO,object);
         }
     }];
     //接口访问日志
     [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[QueryAbout lastPathComponent]];
}
#pragma mark 发送登录token
+ (void)sendBindingTokenWithUDID:(NSString *)udid andLoginTolen:(NSString *)token andResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@/%@", AppURL, BindingToken, [UserTool sharedUser].userId, udid, token];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *executeStatus = [object objectForKey:@"executeStatus"];
            if (executeStatus) {
                GeneralDataModel *dataModel = [[GeneralDataModel alloc] initWithDictionary:executeStatus];
                resultBlock(YES, dataModel);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[BindingToken lastPathComponent]];
}

#pragma mark 登录成功日志
+ (void)sendRecordLoadLogWithEquipModel:(NSString *)equipModel {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@", AppURL, RecordLoadLog, [UserTool sharedUser].userId, equipModel];
    
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *executeStatus = [object objectForKey:@"executeStatus"];
            if (executeStatus) {
                GeneralDataModel *dataModel = [[GeneralDataModel alloc] initWithDictionary:executeStatus];
                DLog(@"sendRecordLoadLog %@", dataModel.code);
            }
        }else {
             DLog(@"sendRecordLoadLog error=%@", object);
        }
    }];
}

#pragma mark 访问日志
+ (void)sendRecordAccessLogWithEquipModel:(NSString *)equipModel andModuleId:(NSString *)moduleId andInterfaceName:(NSString *)interfaceName{
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@/%@/%@", AppURL, RecordAccessLog, [UserTool sharedUser].userId, equipModel, moduleId, interfaceName];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *executeStatus = [object objectForKey:@"executeStatus"];
            if (executeStatus) {
                GeneralDataModel *dataModel = [[GeneralDataModel alloc] initWithDictionary:executeStatus];
                DLog(@"sendRecordAccessLog %@", dataModel.code);
            }
        }else {
            DLog(@"sendRecordAccessLog error=%@", object);
        }
    }];
}


#pragma mark H5页面更新检测
+ (void)getH5UpdateWithVersionCode:(NSString*)version andResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/1/%@", AppURL, GetH5Update, version];
    
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *h5Update = [object objectForKey:@"h5Update"];
            if (h5Update){
                resultBlock(YES, h5Update);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetH5Update lastPathComponent] ];
}

#pragma mark 下载h5文件
+ (void)downFileWithUrl:(NSString *)urlStr andFilePath:(NSString *)filePath andResult:(void(^)(BOOL success, id object))resultBlock {
    
    [AFNetBase downLoadFileWithUrl:urlStr andFilePath:filePath andResult:^(BOOL success, id object) {
        resultBlock(success, object);
    }];
}

#pragma mark 获取告警数量
+ (void)getItemWarnNumWithResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@/%@", AppURL, GetItemWarnNum, [UserTool sharedUser].userId, @"1", [UserTool sharedUser].loginToken];
 
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            if([[object objectForKey:@"code"] isEqualToString:@"invalid"]){
                [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
            }else {
                resultBlock(YES,object);
            }
            
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetItemWarnNum lastPathComponent]];
}

#pragma mark 获取PDF报表标题信息
+ (void)getPdfReportTitleWithModuleId:(NSString *)moduleId andResult:(void(^)(BOOL success, id object))resultBlock {

    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@/%@", AppURL, GetPdfReportTitle, [UserTool sharedUser].userId, moduleId, [UserTool sharedUser].loginToken];
   
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            if([[object objectForKey:@"code"] isEqualToString:@"invalid"]){
                [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
            }else {
                resultBlock(YES,object);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetPdfReportTitle lastPathComponent]];
}

#pragma mark 获取PDF报表账期下拉列表元素
+ (void)getPdfReportAcctSelectListWithModuleId:(NSString *)moduleId andResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@/%@", AppURL, GetPdfReportAcctSelectList, [UserTool sharedUser].userId, moduleId, [UserTool sharedUser].loginToken];
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dataModel = object;
            NSDictionary *selectItemData = [dataModel objectForKey:@"selectItemData"];
            if([[selectItemData objectForKey:@"retCode"] isEqualToString:@"invalid"]){
                [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
            }else {
                resultBlock(YES,object);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetPdfReportAcctSelectList lastPathComponent]];
}

#pragma mark 获取pdf文档路径
+ (void)getPdfReportFileWithModuleId:(NSString *)moduleId andAcctDate:(NSString *)acctDate andResult:(void(^)(BOOL success, id object))resultBlock {
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@", AppURL, GetPdfReportFile, [UserTool sharedUser].userId, moduleId, acctDate, [UserTool sharedUser].loginToken];
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            if([[object objectForKey:@"retCode"] isEqualToString:@"invalid"]){
                [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
            }else {
                resultBlock(YES,object);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetPdfReportFile lastPathComponent]];
}


#pragma mark 获取常见问题
+ (void)getAppCommonQuestionListWithResult:(void(^)(BOOL success, id object))resultBlock{
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@/1/%@", AppURL, GetAppCommonQuestionList, [UserTool sharedUser].userId, [UserTool sharedUser].loginToken];
    [AFNetBase getDataFromServerWithHostUrl:fullUrl andParameters:nil andResult:^(BOOL success, id object) {
        if (success) {
            if([[object objectForKey:@"code"] isEqualToString:@"invalid"]){
                [[UserTool sharedUser] showSkipViewControlerWithAlert:YES];
            }else {
                resultBlock(YES,object);
            }
        }else {
            resultBlock(NO,object);
        }
    }];
    //接口访问日志
    [[self class] sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:[GetAppCommonQuestionList lastPathComponent]];
}

@end
