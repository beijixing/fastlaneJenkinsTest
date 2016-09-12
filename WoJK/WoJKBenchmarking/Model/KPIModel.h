//
//  KPIModel.h
//  WoJK
//
//  Created by Megatron on 16/5/10.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPIDataModel.h"

@interface KPIModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger maxNum;
@property (nonatomic, strong) NSArray<KPIDataModel*> *kpiDataModelArr;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
