//
//  ReportResponseModel.h
//  WoJK
//
//  Created by Megatron on 16/5/10.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportModuleModel.h"
@interface ReportResponseModel : NSObject
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, copy) NSArray *tabList;
@property(nonatomic, strong) NSArray< ReportModuleModel *> *reportModuleArr;
- (void)updateResponseModelWithDataDict:(NSDictionary *)dict;
@end
