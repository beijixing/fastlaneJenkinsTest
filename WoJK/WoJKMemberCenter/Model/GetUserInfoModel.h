//
//  GetUserInfoModel.h
//  HD100-Custom
//
//  Created by WenJie on 15/7/10.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "JSONModel.h"
/*!
 *  用户信息Model
 */
@interface UserInfoModel : JSONModel
@property (strong, nonatomic) NSString *contact_mobile;
@property (strong, nonatomic) NSString *head_img;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *nick;
@property (strong, nonatomic) NSString *sex;
@end
/*!
 *  获取用户信息Model
 */
@interface GetUserInfoModel : JSONModel
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSString *msg;
@property (strong, nonatomic) UserInfoModel*userinfo;
@end



