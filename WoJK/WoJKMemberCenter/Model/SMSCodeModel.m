//
//  SMSCodeModel.m
//  WoJK
//
//  Created by Megatron on 16/4/25.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "SMSCodeModel.h"

@implementation SMSCodeModel
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
