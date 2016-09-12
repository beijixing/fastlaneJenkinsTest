//
//  KPIDataManager.h
//  WoJK
//
//  Created by Megatron on 16/5/12.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedKPIDataManager : NSObject
+ (NSDictionary *)querySelectedKPIData;
+ (BOOL)saveSelectedKPIData:(NSDictionary *)selectedData;
+ (BOOL)deleteKPIByCode:(NSString *)kpiCode;
@end
