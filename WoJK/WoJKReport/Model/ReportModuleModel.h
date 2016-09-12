//
//  ReportModuleModel.h
//  WoJK
//
//  Created by Megatron on 16/5/10.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportModuleModel : NSObject
@property(nonatomic, assign) NSInteger isImportant;
@property(nonatomic, copy) NSString *moduleId;
@property(nonatomic, copy) NSString *moduleName;
@property(nonatomic, copy) NSString *moduleURL;
@property(nonatomic, assign) NSInteger orderNo;
@property(nonatomic, copy) NSString *pictureURL;
@property(nonatomic, copy) NSString *reportUrl;
@property(nonatomic, assign) NSInteger viewType;//1 竖屏，2横屏
@property(nonatomic, assign) NSInteger report_style; //1图2表3图表都有
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
