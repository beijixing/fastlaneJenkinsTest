//
//  AreaDataMdel.m
//  WoJK
//
//  Created by Megatron on 16/5/11.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "AreaDataModel.h"

@implementation AreaDataModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
