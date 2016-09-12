//
//  SMSCodeModel.h
//  WoJK
//
//  Created by Megatron on 16/4/25.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "JSONModel.h"
/**
 *  获取短信验证码
 */
@interface SMSCodeModel : NSObject
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, copy) NSString *verificationCode;
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err;

@end
