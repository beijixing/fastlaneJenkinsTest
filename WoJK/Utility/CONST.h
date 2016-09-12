//
//  CONST.h
//  zglTest
//
//  Created by 郑光龙 on 15/10/27.
//  Copyright © 2015年 郑光龙. All rights reserved.
//

#ifndef CONST_h
#define CONST_h
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES
// iPad
#define IsPad [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad
#define IsPhone [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone


#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define ColorWithRGB(R,G,B) [UIColor colorWithRed:(R/255.0f) green:(G/255.0f) blue:(B/255.0f) alpha:1.0f]
#define ColorWithRGBA(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#define ImageName(a) [UIImage imageNamed:a]

#define iOS_VERSION [[[UIDevice currentDevice] systemVersion] doubleValue]
#define MAIN_COLOR  ColorWithRGB(255,113,93)
#define ViewMainColor ColorWithRGB(243, 244, 245)

// 取得AppDelegate单利
#define ShareApp ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// 接口

#define GetAppUpdate @"appService/getAppUpdate" //获取APP 升级信息
#define GetUserValid @"appService/getUserValid2" //登录接口
#define GetQueryLoadInfo @"appService/getQueryLoadInfo" //是否认证
#define GetQueryEquipInfo @"appService/getQueryEquipInfo" //查询设备绑定信息
#define GetSMSValid @"appService/getSMSValid"//获取认证短信验证码
#define DelBindingEquip @"appService/delBindingEquipNew"//删除绑定关系
#define BindingEquipNew @"appService/bindingEquipNew" //绑定设备

#define GetMonitorReportZdgzData @"appService2/getMonitorReportZdgzDayData"//获取日指标
#define GetMonitorReportZdgzMonData @"appService2/getMonitorReportZdgzMonData"//获取月指标

#define GetChannel @"appService/getChannel" //获取频道显示信息
#define GetPushStatus @"appService/getPushStatus"//获取推送通知信息
#define SetPushManage @"appService/setPushManage"//设置推送通知信息

#define GetMaxAcctDate @"appService2/getMaxAcctDate" //获取横向对标数据最大账期
#define GetAreaList @"appService2/getInfeedCompareAreaList" //获取横向对标设置区域列表
#define GetKpiList @"appService2/getInfeedCompareTargetInfo" //获取横向对标指标信息

#define GetDailyTargetSearch @"appService2/getDailyTargetSearch"//获取监控告警获取指标编码服务
#define SetDailySetting @"appService2/setDailySetting" //设置用户监控告警指标

#define GetSystemNoticeList @"appService/getSystemNoticeList"//获取当前用户所有收到的公告信息
#define GetSystemNoticeInfo @"appService/getSystemNoticeInfo" //获取公告的详细信息
#define SetSystemNoticeReadStatus @"appService/setSystemNoticeReadStatus"//设置公告为已读状态
#define GetSystemNotice @"appService/getSystemNotice"//获取当前用户收到的最新公告

#define SetUertSuggestion @"appService/setUertSuggestion" //意见反馈
#define QueryAbout @"appService/queryAbout"//关于我们
#define GetAppCommonQuestionList @"appService/getAppCommonQuestionList" //常见问题

#define BindingToken @"appService/updateToken"//发送登录token
#define RecordLoadLog @"appService/recordLoadLog"//登录成功日志
#define RecordAccessLog @"appService/recordAccessLog"//访问日志

#define GetPassword  @"appService/getPassword" //获取加密后的密码
#define GetH5Update  @"appService/getH5Update" //H5页面更新检测
#define GetPdfReportFile @"appService2/getPdfReportFilePath"//获取pdf文档路径
#define GetItemWarnNum @"appService2/getItemWarnNum"// 获取告警数量
#define GetPdfReportTitle @"appService2/getPdfReportTitle"//获取PDF报表标题信息
#define GetPdfReportAcctSelectList @"appService2/getPdfReportAcctSelectList"//获取PDF报表账期下拉列表元素

//模块ID
#define ModuleDailyReport @"402882a85427408201542767f469002b"//	监控日报
#define ModuleMothlyReport @"402882a854adb2c20154adb7ce570001"//监控月报
#define ModuleWarning @"402882a85427408201542767f46c002c"//	异动告警
#define ModuleCompare @"402882a85427408201542767f46f002d"//	横向对标
#define ModuleMemberCenter @"402882a85427408201542767f471002e"//	个人中心




// 友盟key
//#define UmengAppkey @"55543fb2e0f55a4987000a83" // 友盟社会化组件key
// 微信分享相关的
//#define WeiXinAppID @"wx06321aac97e9678f"
//#define WeiXinAppSecret @"4968c9d6cad01f40bfe3e19709fa2ef3"

// 百度推送相关
//#define BPushID @"7635182"
//#define BPushAPIKey @"scEQKTVhI6Iuxspc0xj4A85V"
//#define BPushSecretKey @"Xrmd49vy3Uh2IST2S1B18lnSeCig4qDT"

//应用中用到的中文

#endif

/* CONST_h */
