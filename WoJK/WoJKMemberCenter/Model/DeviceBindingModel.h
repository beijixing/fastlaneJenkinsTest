//
//  DeviceBindingModel.h
//  WoJK
//
//  Created by Megatron on 16/4/20.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "JSONModel.h"
/**
 *  判断设备是否已经绑定
 */
@interface DeviceBindingModel : NSObject
@property(nonatomic, assign) NSInteger udidIsExist;
@property(nonatomic, strong) NSDictionary *userEquips;
@property(nonatomic, copy) NSString *userID;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
