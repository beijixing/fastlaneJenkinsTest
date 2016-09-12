//
//  BindingEquipModel.m
//  WoJK
//
//  Created by Megatron on 16/4/26.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "GeneralDataModel.h"

@implementation GeneralDataModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
