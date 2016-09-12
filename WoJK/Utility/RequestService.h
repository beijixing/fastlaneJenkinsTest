//
//  RequestService.h
//  E-attendance
//
//  Created by Kevin on 14-9-24.
//  Copyright (c) 2014年 bitwayapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface RequestService : NSObject

/**
 *获取加密后的密码
 */
+ (void)getEncryptedPasswordWiithPassword:(NSString *)password userName:(NSString *)userName andResultBlock:(void(^)(BOOL success,id object))resultBlock;
//登录接口
+ (void)loginWithUserName:(NSString *)userName password:(NSString *)password resultBlock:(void(^)(BOOL success,id object))resultBlock;

//意见反馈
+ (void)feedBackWithContent:(NSString *)content result:(void(^)(BOOL success,id object))resultBlock;

//App升级检测
+ (void)upgradeDetectionWithResult:(void(^)(BOOL success,id object))resultBlock;

//认证检测
+ (void)authenticationDetectionWithUDID:(NSString *)udid result:(void(^)(BOOL success, id object))resultBlock;

//判断终端绑定关系
+ (void)deviceBindingDetectionWithUDID:(NSString *)udid result:(void(^)(BOOL success, id object))resultBlock;

//获取登录认证短信验证码
+ (void)getAuthenticationSMSCodeWithUserId:(NSString *)userId result:(void(^)(BOOL success, id object))resultBlock;

//删除绑定关系
+ (void)deleteBidingEquipWithEquipTpe:(NSString *)eType UUID:(NSString *)uuid result:(void(^)(BOOL success, id object))resultBlock;

//绑定设备
+ (void)bindingEquipWithUDID:(NSString *)udid andChanneId:(NSString *)channeId andResult:(void(^)(BOOL success, id object))resultBlock;

//获取首页监控报表数据
+ (void)getMonitorReportZdgzDataWithModuleId:(NSString *)moduleId andResult:(void(^)(BOOL success, id object))resultBlock;
//获取监控月报表数据
+ (void)getMonitorReportZdgzMonDataWithModuleId:(NSString *)moduleId andResult:(void(^)(BOOL success, id object))resultBlock;
/**
 *  获取频道显示信息服务
 */
+ (void)getChannelInfoWithType:(NSString *)type andResult:(void(^)(BOOL success, id object))resultBlock;

/**
 *  获取推送设置信息
 */
+ (void)getPushStatusWithType:(NSString *)type andResult:(void(^)(BOOL success, id object))resultBlock;

/**
 *  设置推送设置信息
 */
+ (void)setPushStatusWithType:(NSString *)type andStatus:(NSString *)status andResult:(void(^)(BOOL success, id object))resultBlock;

/**
 *  设置用户监控告警指标
 */
+ (void)setDailySettingWithTargetId:(NSString *)targetId targetType:(NSString*)type operate:(NSString *)operateType andResult:(void(^)(BOOL success, id object))resultBlock;
/**
 *  获取监控告警获取指标编码服务
 *
 */

+ (void)getDailyTargetSearchWithTargetType:(NSString*)type result:(void(^)(BOOL success, id object))resultBlock;

/**
 *  获取横向对标数据最大账期
 */

+ (void)getMaxAcctDateWithModuleId:(NSString *)moduleId result:(void(^)(BOOL success, id object))resultBlock;
/**
 *  获取横向对标设置区域列表
 */
+ (void)getAreaListWithAreaId:(NSString *)area result:(void(^)(BOOL success, id object))resultBlock;

/**
 *  获取横向对标指标信息
 */
+ (void)getKpiListWithResult:(void(^)(BOOL success, id object))resultBlock;


/**
 *  获取当前用户所有收到的公告信息
 */
+ (void)getSystemNoticeListWithResult:(void(^)(BOOL success, id object))resultBlock;

/**
 *  获取公告的详细信息
 */
+ (void)getSystemNoticeInfoWithId:(NSString *)noticeId andResult:(void(^)(BOOL success, id object))resultBlock;
/**
 *  设置公告为已读状态
 */
+ (void)setSystemNoticeReadStatusWithId:(NSString *)noticeId andResult:(void(^)(BOOL success, id object))resultBlock;

/**
 *  获取当前用户收到的最新公告
 */
+ (void)getSystemNoticeWithResult:(void(^)(BOOL success, id object))resultBlock;


/**
 *  关于我们
 */
+ (void)queryAboutUsWithResult:(void(^)(BOOL success, id object))resultBlock;


/**
 * 发送登录token
 */

+ (void)sendBindingTokenWithUDID:(NSString *)udid andLoginTolen:(NSString *)token andResult:(void(^)(BOOL success, id object))resultBlock;
/**
 * 登录成功日志
 */
+ (void)sendRecordLoadLogWithEquipModel:(NSString *)equipModel;

/**
 *  访问日志
 */

+ (void)sendRecordAccessLogWithEquipModel:(NSString *)equipModel andModuleId:(NSString *)moduleId andInterfaceName:(NSString *)interfaceName;


/**
 *  H5页面更新检测
 */
+ (void)getH5UpdateWithVersionCode:(NSString*)version andResult:(void(^)(BOOL success, id object))resultBlock;

/**
 *  下载h5最新页面
 */
+ (void)downFileWithUrl:(NSString *)urlStr andFilePath:(NSString *)filePath andResult:(void(^)(BOOL success, id object))resultBlock;

/**
 *  获取告警数量
 */
+ (void)getItemWarnNumWithResult:(void(^)(BOOL success, id object))resultBlock;

/**
 *  获取PDF报表标题信息
 */
+ (void)getPdfReportTitleWithModuleId:(NSString *)moduleId andResult:(void(^)(BOOL success, id object))resultBlock;

/**
 * 获取PDF报表账期下拉列表元素
 */
+ (void)getPdfReportAcctSelectListWithModuleId:(NSString *)moduleId andResult:(void(^)(BOOL success, id object))resultBlock;

/**
 *  获取pdf文档路径
 */
+ (void)getPdfReportFileWithModuleId:(NSString *)moduleId andAcctDate:(NSString *)acctDate andResult:(void(^)(BOOL success, id object))resultBlock;

/**
 *  获取常见的问题
 */
+ (void)getAppCommonQuestionListWithResult:(void(^)(BOOL success, id object))resultBlock;


@end
