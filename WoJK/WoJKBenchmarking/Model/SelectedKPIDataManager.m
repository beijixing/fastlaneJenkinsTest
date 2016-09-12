//
//  KPIDataManager.m
//  WoJK
//
//  Created by Megatron on 16/5/12.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "SelectedKPIDataManager.h"
#import "DBManager.h"
#import "KPIDataModel.h"
#import "Macro.h"

@implementation SelectedKPIDataManager
+ (NSDictionary *)querySelectedKPIData {
    if (![[DBManager sharedDBManager] openDB]) {
        return nil;
    }
    FMDatabase *db = [[DBManager sharedDBManager] getDataBase];
    NSMutableDictionary *kpiDataDict = [[NSMutableDictionary alloc] init];
    
    FMResultSet* result = [db executeQuery:@"Select * from 'KpiInfoTable' "];
    while ([result next]) {
        
        KPIDataModel *kpiModel = [[KPIDataModel alloc] init];
        kpiModel.kpiCode = [result stringForColumn:@"kpiCode"];
        kpiModel.kpiName = [result stringForColumn:@"kpiName"];
        kpiModel.order = [result intForColumn:@"ordered"];
        [kpiDataDict setObject:kpiModel forKey:kpiModel.kpiCode];
        
    }
    return kpiDataDict;

}
+ (BOOL)saveSelectedKPIData:(NSDictionary *)selectedData {
    if (![[DBManager sharedDBManager] openDB]) {
        return NO;
    }
    FMDatabase *db = [[DBManager sharedDBManager] getDataBase];
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'KpiInfoTable' "];
    DLog(@"querySql = %@", deleteSql);
    BOOL bRet = [db executeUpdate: deleteSql];//?如果表是空的
    if (bRet) {
        NSArray *allKeys = [selectedData allKeys];
        for (NSString *kpiCode in allKeys) {
            //kpiCode text, kpiName text, ordered integer
            KPIDataModel *dataModel = [selectedData objectForKey:kpiCode];
            NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'KpiInfoTable' (kpiCode, kpiName, ordered) VALUES ('%@', '%@', '%ld') ",
                 dataModel.kpiCode, dataModel.kpiName, (long)dataModel.order];
            if (![db executeUpdate:sqlstr]) {
                DLog(@"插入数据失败");
            }
        }
    }else{
        DLog(@"数据删除失败");
        return NO;
    }
    return YES;
}

+ (BOOL)deleteKPIByCode:(NSString *)kpiCode {
    if (![[DBManager sharedDBManager] openDB]) {
        return NO;
    }
    FMDatabase *db = [[DBManager sharedDBManager] getDataBase];
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'KpiInfoTable' Where kpiCode='%@' ",kpiCode];
    DLog(@"querySql = %@", deleteSql);
    BOOL bRet = [db executeUpdate: deleteSql];//?如果表是空的
    return bRet;
}
@end
