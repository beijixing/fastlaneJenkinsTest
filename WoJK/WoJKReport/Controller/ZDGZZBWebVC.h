//
//  JKRBWebVC.h
//  WoJK
//
//  Created by 郑光龙 on 16/7/7.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "BaseWebViewController.h"
#import "ReportModuleModel.h"


//typedef NS_ENUM(NSInteger, ZDGZZBReportType) {
//    RI_BAO=0,
//    YUE_BAO=1
//};

@interface ZDGZZBWebVC : BaseWebViewController
@property(nonatomic, strong) NSDictionary *dataDict;
//@property(nonatomic) ZDGZZBReportType reportTYpe;
@property(nonatomic, strong) NSString *reportFileName;
@end
