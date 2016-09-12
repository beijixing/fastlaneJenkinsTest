//
//  GetPasswordModel.h
//  HD100-Custom
//
//  Created by WenJie on 15/7/13.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "JSONModel.h"
/*!
 *  找回密码Model
 */
@interface GetPasswordModel : JSONModel
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSString *msg;
@end
