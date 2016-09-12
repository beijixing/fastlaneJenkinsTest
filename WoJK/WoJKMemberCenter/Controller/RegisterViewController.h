//
//  RegisterViewController.h
//  HD100-Custom
//
//  Created by WenJie on 15/7/3.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "BaseViewController.h"
#import "TentacleView.h"
#import "GesturePasswordView.h"
/**
 *  登录类
 */
@interface RegisterViewController : BaseViewController<VerificationDelegate,ResetDelegate,GesturePasswordDelegate>
@property(nonatomic) BOOL clearInputData;
@end
