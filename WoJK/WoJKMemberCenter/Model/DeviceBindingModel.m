//
//  DeviceBindingModel.m
//  WoJK
//
//  Created by Megatron on 16/4/20.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "DeviceBindingModel.h"

@implementation DeviceBindingModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
