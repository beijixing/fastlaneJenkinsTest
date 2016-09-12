//
//  MonitorReportModel.m
//  WoJK
//
//  Created by Megatron on 16/5/3.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "MonitorReportModel.h"

@implementation MonitorReportModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.areaName = [self.data objectForKey:@"areaName"];
        self.valueType = [self.data objectForKey:@"valueType"];
        self.reportUrl = [self.data objectForKey:@"reportUrl"];
    }
    return self;
}
@end
