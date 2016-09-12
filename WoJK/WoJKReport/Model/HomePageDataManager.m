//
//  HomePageDataManageer.m
//  WoJK
//
//  Created by Megatron on 16/5/3.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "HomePageDataManager.h"
@implementation HomePageDataManager

- (void)updateDataWithDict:(NSDictionary *)dict {
//    if (!dict) return;
//    NSDictionary *moduleTypes = [dict objectForKey:@"ModuleTypes"];
//    self.code = [NSString stringWithFormat:@"%@", [dict objectForKey:@"code"]];
//    self.message = [NSString stringWithFormat:@"%@", [dict objectForKey:@"message"]];
//    NSArray *moduleType = [moduleTypes objectForKey:@"moduleType"];
//    for (NSDictionary *dataDict in moduleType) {
//        NSString *moduleTypeName = [dataDict objectForKey:@"moduleTypeName"];
//        NSDictionary *modules = [dataDict objectForKey:@"modules"];
//        NSArray *module = [modules objectForKey:@"module"];
//        if ([moduleTypeName isEqualToString:@"系统主页"]) {
//            self.systemMainPageConfig = [self getHomePageDataModelArrWithModule:module];
//        }else if([moduleTypeName isEqualToString:@"监控日报"]){
//            self.dayReportConfig = [self getHomePageDataModelArrWithModule:module];
//        }else if([moduleTypeName isEqualToString:@"监控月报"]){
//            self.montheportConfig = [self getHomePageDataModelArrWithModule:module];
//        }
//    }
}

- (NSArray *)getHomePageDataModelArrWithModule:(NSArray *)module {
    if (!module) {
        return NULL;
    }
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dataDict in module) {
        ReportModuleModel *dataModel = [[ReportModuleModel alloc] initWithDictionary:dataDict];
        [dataArr addObject:dataModel];
    }
    return dataArr;
}
@end
