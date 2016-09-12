//
//  LoginModel.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/9.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "LoginModel.h"


@implementation LoginModel
-(instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError**)err {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end