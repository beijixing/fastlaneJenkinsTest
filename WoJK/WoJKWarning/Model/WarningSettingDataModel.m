//
//  WarningSettingDataModel.m
//  WoJK
//
//  Created by Megatron on 16/5/5.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "WarningSettingDataModel.h"
#import "WarnSettingSectionModel.h"
#import "WarnSettingTargetModel.h"
@implementation WarningSettingDataModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.code = [dict objectForKey:@"code"];
        NSDictionary *targetSpeciesList = [dict objectForKey:@"TargetSpeciesList"];
        NSArray *targetSpecies = [targetSpeciesList objectForKey:@"TargetSpecies"];
        
        NSMutableArray *sectionModelArr = [[NSMutableArray alloc] init];
        for (int i  = 0; i< targetSpecies.count; i++) {
            
            NSDictionary *sectionDataDict = targetSpecies[i];
            WarnSettingSectionModel *sectionModel = [[WarnSettingSectionModel alloc] init];
            sectionModel.targetSpeciesID = [NSString stringWithFormat:@"%@", [sectionDataDict objectForKey:@"TargetSpeciesID"]];
            sectionModel.targetSpeciesName = [NSString stringWithFormat:@"%@", [sectionDataDict objectForKey:@"TargetSpeciesName"]];
            [sectionModelArr addObject:sectionModel];
            
            NSMutableArray *targetModelArr = [[NSMutableArray alloc] init];
            NSDictionary *targetList = [sectionDataDict objectForKey:@"TargetList"];
            
            NSArray *target = [targetList objectForKey:@"Target"];
            for (int i = 0; i < target.count; i++) {
                NSDictionary *targetDict = target[i];
                WarnSettingTargetModel *targetModel = [[WarnSettingTargetModel alloc] initWithDictionary:targetDict];
                [targetModelArr addObject:targetModel];
            }
            sectionModel.settingTargetArr = targetModelArr;
        }
        self.settingSectionModelArr = sectionModelArr;
    }
    return self;
}
@end
