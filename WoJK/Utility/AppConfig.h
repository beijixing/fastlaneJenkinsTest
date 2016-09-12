//
//  AppConfig.h
//  HD100-Custom
//
//  Created by WenJie on 15/7/6.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  APP相关设置 (各种APPKey注册)
 */
@interface AppConfig : NSObject


+(instancetype)sharedInstance;//单例

@property (nonatomic, strong) NSString *appkey;
@property (nonatomic, strong) NSString *appcert;

/**
 *  注册所有信息:QQ地图,友盟统计,设备信息,微信支付,极光推送
 */
+ (void)registerAllInfo;


@end
