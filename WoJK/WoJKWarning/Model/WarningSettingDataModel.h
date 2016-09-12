//
//  WarningSettingDataModel.h
//  WoJK
//
//  Created by Megatron on 16/5/5.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WarnSettingSectionModel;
@interface WarningSettingDataModel : NSObject
@property(nonatomic, copy) NSString *code;
@property(nonatomic, strong) NSArray<WarnSettingSectionModel *> *settingSectionModelArr;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
