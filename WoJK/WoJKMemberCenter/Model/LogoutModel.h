//
//  LogoutModel.h
//  HD100-Custom
//
//  Created by WenJie on 15/7/14.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "JSONModel.h"
/**
 *  退出登录
 */
@interface LogoutModel : JSONModel
@property (nonatomic, assign) BOOL success;
@property (strong, nonatomic) NSString *msg;
@end
