//
//  KPIModel.m
//  WoJK
//
//  Created by Megatron on 16/5/10.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "KPIModel.h"

@implementation KPIModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.code = [NSString stringWithFormat:@"%@", [dict objectForKey:@"code"]];
        self.message = [NSString stringWithFormat:@"%@", [dict objectForKey:@"message"]];
        NSArray *dataList = [dict objectForKey:@"dataList"];
        if (dataList) {
            NSMutableArray *dataModelArr = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dataDct in dataList) {
                KPIDataModel *dataModel = [[KPIDataModel alloc] initWithDictionary:dataDct];
                [dataModelArr addObject:dataModel];
            }
            
            self.kpiDataModelArr = dataModelArr;
        }
        self.maxNum = [[dict objectForKey:@"maxNum"] integerValue];
    }
    return self;
}
@end
