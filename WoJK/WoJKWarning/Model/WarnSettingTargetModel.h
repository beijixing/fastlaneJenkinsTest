//
//  WarnSettingTargetModel.h
//  WoJK
//
//  Created by Megatron on 16/5/5.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarnSettingTargetModel : NSObject
@property (nonatomic, assign) NSInteger isSelect;
@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, copy) NSString *targetName;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
