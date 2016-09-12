//
//  CommonWebViewVC.h
//  WoJK
//
//  Created by Megatron on 16/5/4.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "BaseWebViewController.h"
#import "ReportModuleModel.h"

@interface CommonWebViewVC : BaseWebViewController

@property(nonatomic, strong) ReportModuleModel *dataModel;
//@property(nonatomic, copy) NSString *urlStr;
//@property(nonatomic, copy) NSString *titleStr;
//@property(nonatomic) BOOL isPushNoticeUrl;
@property(nonatomic, strong) NSString *reportFileName;
@property(nonatomic, strong) NSString *targetId;//跳转到指标解释详情页面时会用到
@end
