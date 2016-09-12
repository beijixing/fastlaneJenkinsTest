//
//  UpdatePasswordViewCtrl.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/9.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "UpdatePasswordViewCtrl.h"
#import "WJTextField.h"
#import "Validator.h"
#import "WJHUD.h"
#import "Macro.h"
#import "Constant.h"
#import "RequestService.h"
#import "UpdatePasswordModel.h"
#import "UserTool.h"

@interface UpdatePasswordViewCtrl ()
@property (weak, nonatomic) IBOutlet WJTextField *tfOldPassword;
@property (weak, nonatomic) IBOutlet WJTextField *tfNewPassword;
@property (weak, nonatomic) IBOutlet WJTextField *tfNewPasswordAgain;

@end

@implementation UpdatePasswordViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBackButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionUpdatePassword:(id)sender {
    if ([self canUpdate]) {
        [RequestService updatePasswordWithOldPassword:_tfOldPassword.text newPassword:_tfNewPassword.text newPasswordAgain:_tfNewPasswordAgain.text resultBlock:^(BOOL success, id object) {
            if (success) {
                UpdatePasswordModel *model = (UpdatePasswordModel *)object;
                [WJHUD showText:model.msg onView:self.view completionBlock:^{
                    if (model.success) {
                        [[UserTool sharedUser]logoutWithResult:^(BOOL success) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];//修改密码后要退出登录
                    }
                }];
            }
        }];
    }
}

// 是否有未填项
- (BOOL)isSpaceOrEmpty:(NSArray *)array
{
    for (UITextField *tf in array) {
        if ([Validator isSpaceOrEmpty:tf.text]) {
            [tf becomeFirstResponder];
            return YES;
        }
    }
    return NO;
}

// 验证提交可行性
- (BOOL)canUpdate
{
    if ([self isSpaceOrEmpty:@[_tfOldPassword,_tfNewPassword,_tfNewPasswordAgain]])
    {
        [WJHUD showText:AlertMessageNOContent onView:self.view];
        return NO;
    }
    else if (![_tfNewPassword.text isEqualToString:_tfNewPasswordAgain.text]){
        [WJHUD showText:AlertMessageNotSamePassword onView:self.view];
        return NO;
    }
    else
        return YES;
}

@end
