//
//  LoginModel.h
//  HD100-Custom
//
//  Created by WenJie on 15/7/9.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "JSONModel.h"
@interface LoginModel : NSObject
@property (nonatomic, assign) NSInteger validStatus;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *uesrDepName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *area;
-(id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err;
@end