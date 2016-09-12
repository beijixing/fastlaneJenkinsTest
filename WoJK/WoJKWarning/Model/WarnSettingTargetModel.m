//
//  WarnSettingTargetModel.m
//  WoJK
//
//  Created by Megatron on 16/5/5.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "WarnSettingTargetModel.h"

@implementation WarnSettingTargetModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
