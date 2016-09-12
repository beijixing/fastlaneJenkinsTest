//
//  MonitorReportModel.h
//  WoJK
//
//  Created by Megatron on 16/5/3.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonitorReportModel : NSObject
@property(nonatomic, copy)NSString *retCode;
@property(nonatomic, strong) NSDictionary *data;
@property(nonatomic, copy) NSString *areaName;
@property(nonatomic, copy) NSString *valueType;
@property(nonatomic, copy) NSString *reportUrl;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
