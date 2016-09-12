//
//  ReportResponseModel.m
//  WoJK
//
//  Created by Megatron on 16/5/10.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "ReportResponseModel.h"

@implementation ReportResponseModel
- (void)updateResponseModelWithDataDict:(NSDictionary *)dict {
    if (!dict) {
        return;
    }
    self.tabList = [dict objectForKey:@"tabList"];
    self.code = [NSString stringWithFormat:@"%@", [dict objectForKey:@"code"]] ;
    self.message = [NSString stringWithFormat:@"%@", [dict objectForKey:@"message"]];
    NSArray *module = [dict objectForKey:@"Module"];
    if (module) {
        NSMutableArray *reportModuleModelArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dataDict in module) {
            ReportModuleModel *dataModel = [[ReportModuleModel alloc] initWithDictionary:dataDict];
            [reportModuleModelArr addObject:dataModel];
        }
        self.reportModuleArr = reportModuleModelArr;
    }
}
@end
