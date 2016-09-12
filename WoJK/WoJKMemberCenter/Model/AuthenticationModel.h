//
//  AuthenticationModel.h
//  WoJK
//
//  Created by Megatron on 16/4/20.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface AuthenticationModel : JSONModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;

@end
