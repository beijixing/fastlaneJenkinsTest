//
//  BindingEquipModel.h
//  WoJK
//
//  Created by Megatron on 16/4/26.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "JSONModel.h"
/**
 *  绑定设备
 */
@interface GeneralDataModel : NSObject
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *message;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
