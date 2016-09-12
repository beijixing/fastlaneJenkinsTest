//
//  ForgetPasswordViewCtrl.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/10.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "ForgetPasswordViewCtrl.h"
#import "WJTextField.h"
#import "Validator.h"
#import "Colours.h"
#import "WJHUD.h"
#import "Constant.h"
#import "RequestService.h"
#import "PasswordCodeModel.h"
#import "Macro.h"
#import "GetPasswordModel.h"
#import "UserTool.h"

@interface ForgetPasswordViewCtrl ()
{
    int _times;//倒计时次数
    int _currentScene; //0or1
}
@property (weak, nonatomic) IBOutlet WJTextField *tfFirst;
@property (weak, nonatomic) IBOutlet WJTextField *tfSecond;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfFirstRight;

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *passwordAgain;
@property (nonatomic, strong) NSTimer *timer;//倒计时

@end

@implementation ForgetPasswordViewCtrl

- (IBAction)actionNext:(id)sender {
    if ([Validator isSpaceOrEmpty:_tfFirst.text]||[Validator isSpaceOrEmpty:_tfSecond.text]) {
        [WJHUD showText:AlertMessageNOContent onView:self.view];
        return;
    }
    if (_currentScene==0) {
        //场景0:输入手机号和验证码
        if (![Validator isValidPhone:_tfFirst.text]) {
            [WJHUD showText:AlertMessageWrongTel onView:self.view];
            return;
        }
        self.mobile = _tfFirst.text;
        self.code = _tfSecond.text;
        _tfFirst.text = nil;
        _tfSecond.text = nil;
        _btnCode.hidden = YES;
        _tfFirst.placeholder = @"请输入新密码";
        _tfSecond.placeholder = @"请再次输入新密码";
        _tfFirst.secureTextEntry = YES;
        _tfSecond.secureTextEntry = YES;
        [_btnNext setTitle:@"提交" forState:UIControlStateNormal];
        _tfFirstRight.constant = 0;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.2;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromRight;
        [self.view.layer addAnimation:animation forKey:nil];
        _currentScene++;
    }else
    {
        //场景1:输入新密码,提交数据
        self.password = _tfFirst.text;
        self.passwordAgain = _tfSecond.text;
        [WJHUD showOnView:self.view];
        [RequestService getBackWithMobile:_mobile code:_code password:_password password_again:_passwordAgain result:^(BOOL success, id object) {
            [WJHUD hideFromView:self.view];
            if (success) {
                GetPasswordModel *model = (GetPasswordModel *)object;
                [WJHUD showText:model.msg onView:self.view completionBlock:^{
                    if (model.success) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBackButton];
    [self btnCodeState:YES];
    [self setupInputTextFieldApperance];
}

- (void)setupInputTextFieldApperance {
    self.tfFirst.layer.borderColor = [UIColor whiteColor].CGColor;
    self.tfSecond.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取验证码
- (IBAction)actionCode:(id)sender {
    
    if (![Validator isValidPhone:_tfFirst.text]) {
        [WJHUD showText:AlertMessageWrongTel onView:self.view];
        return ;
    }
    [self btnCodeState:NO];
    [WJHUD showOnView:self.view];
    [RequestService  forgetPasswordCodeWithMobile:_tfFirst.text result:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            PasswordCodeModel *model = (PasswordCodeModel *)object;
            [WJHUD showText:model.msg onView:self.view completionBlock:^{
                if (model.success) {
                    _times = 60;
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(actionTimer) userInfo:nil repeats:YES];
                    [_timer fire];
                    [self btnCodeState:NO];
                }else
                    [self btnCodeState:YES];
            }];
        }else
            [self btnCodeState:YES];
    }];
    
}

// 验证码按钮倒计时
- (void)actionTimer
{
    _times --;
    if (_times==0) {
        [_timer invalidate];
        [self btnCodeState:YES];
    }else
        [_btnCode setTitle:[NSString stringWithFormat:@"%d",_times] forState:UIControlStateNormal];
}

// 验证码按钮交互状态处理
- (void)btnCodeState:(BOOL)enable
{
    _btnCode.enabled = enable;
    if (enable) {
        [_btnCode setBackgroundImage:[UIImage imageNamed:@"orange"] forState:UIControlStateNormal];
        [_btnCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else
    {
        [_btnCode setBackgroundImage:nil forState:UIControlStateNormal];
        [_btnCode setBackgroundColor:[UIColor lightGrayColor]];
        [_btnCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
- (IBAction)actionBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
