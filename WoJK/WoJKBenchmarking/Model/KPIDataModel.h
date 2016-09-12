//
//  kpiDataModel.h
//  WoJK
//
//  Created by Megatron on 16/5/10.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface KPIDataModel : NSObject
@property (nonatomic, copy) NSString *kpiCode;
@property (nonatomic, copy) NSString *kpiName;
@property (nonatomic, assign) NSInteger order;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
