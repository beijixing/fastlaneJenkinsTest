//
//  AreaResponseModel.h
//  WoJK
//
//  Created by Megatron on 16/5/11.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaDataModel.h"

@interface AreaResponseModel : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) NSInteger maxNum;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSArray<AreaDataModel*> *areaDataModelArr;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
