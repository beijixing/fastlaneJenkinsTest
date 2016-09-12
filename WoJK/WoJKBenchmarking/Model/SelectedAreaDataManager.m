//
//  SelectedAreaDataManager.m
//  WoJK
//
//  Created by Megatron on 16/5/12.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "SelectedAreaDataManager.h"
#import "DBManager.h"
#import "Macro.h"
#import "AreaDataModel.h"
//areaName text, areaCode text, ordered integer, flag integer
@implementation SelectedAreaDataManager
+ (NSDictionary *)querySelectedAreaData {
    if (![[DBManager sharedDBManager] openDB]) {
        return nil;
    }
    FMDatabase *db = [[DBManager sharedDBManager] getDataBase];
    NSMutableDictionary *areaDataDict = [[NSMutableDictionary alloc] init];
    FMResultSet* result = [db executeQuery:@"Select * from 'AreaDataTable' "];
    while ([result next]) {
        AreaDataModel *areaModel = [[AreaDataModel alloc] init];
        areaModel.areaName = [result stringForColumn:@"areaName"];
        areaModel.areaCode = [result stringForColumn:@"areaCode"];
        areaModel.order = [result intForColumn:@"ordered"];
        areaModel.flag = [result intForColumn:@"flag"];
        [areaDataDict setObject:areaModel forKey:areaModel.areaCode];
    }
    return areaDataDict;
}

+ (BOOL)saveSelectedAreaData:(NSDictionary *)selectedData {
    if (![[DBManager sharedDBManager] openDB]) {
        return NO;
    }
    FMDatabase *db = [[DBManager sharedDBManager] getDataBase];
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'AreaDataTable' "];
    DLog(@"querySql = %@", deleteSql);
    BOOL bRet = [db executeUpdate: deleteSql];//?如果表是空的
    if (bRet) {
        NSArray *allKeys = [selectedData allKeys];
        for (NSString *kpiCode in allKeys) {
            //kpiCode text, kpiName text, ordered integer
            AreaDataModel *dataModel = [selectedData objectForKey:kpiCode];
            NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'AreaDataTable' (areaName, areaCode, ordered, flag) VALUES ('%@', '%@', '%ld', '%ld') ", dataModel.areaName, dataModel.areaCode, (long)dataModel.order, (long)dataModel.flag];
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

+ (BOOL)deleteAreaDataByCode:(NSString *)areaCode {
    if (![[DBManager sharedDBManager] openDB]) {
        return NO;
    }
    FMDatabase *db = [[DBManager sharedDBManager] getDataBase];
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'AreaDataTable' Where areaCode = '%@' ", areaCode];
    DLog(@"querySql = %@", deleteSql);

    BOOL bRet = [db executeUpdate: deleteSql];//?如果表是空的
    return bRet;
}

@end
