//
//  LoginViewController.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/3.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "LoginViewController.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "Validator.h"
#import "Constant.h"
#import "LoginModel.h"
#import "UserTool.h"
#import "Macro.h"
#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "KeychainItemWrapper/KeychainItemWrapper.h"
#import "CustomTabBarController.h"
#import "AppUpgradeModel.h"
#import "AuthenticationModel.h"
#import "AppDelegate.h"
#import "UDIDManager.h"
#import "DeviceBindingModel.h"
#import "BPush.h"
#import "SMSCodeModel.h"
#import "GeneralDataModel.h"
#import "ContactUSVC.h"
#import "AboutUsDataModel.h"
#import "NotificationSkipVC.h"
#import "UnbindDevicesVC.h"
#import "DESUtil.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    int animationTimes;
    BOOL _gesturePasswd;
    NSString *_verifyCode;
}
@property (weak, nonatomic) IBOutlet UITextField *tfMobile;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (strong, nonatomic) IBOutlet UIButton *codeBtn;
@property (strong, nonatomic) IBOutlet UIView *usernameBgView;
@property (strong, nonatomic) IBOutlet UIView *passwordBgView;
@property (strong, nonatomic) IBOutlet UIView *codeBgView;
@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LoginViewController
{
    NSString * previousString;
    NSString * password;
    NSInteger _times;
    NSTimer *_timer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //app升级检测
//    self.tfPassword.
    [self upgradeDetection];
//    [UserTool sharedUser].authenticationState = YES;
    
    if (MainScreenHeight>=568) {
        self.scrollView.scrollEnabled = NO;
    }
    
    if (![[UserTool sharedUser] checkBIComponetInstall]) {
        [[UserTool sharedUser] addInstallBIComponentTipsAlertVc:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if (![password isEqualToString:@""]) {//如果设置了手势密码就弹出手势密码输入页面
        [self verifyGesturePassWord];
    }
    self.gesturePasswordView.titleLabel.text = @"输入手势密码";
    self.gesturePasswordView.state.text = @"";

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    
    if ( !UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ) {
        [self setupPotraitDisplayView];
    }
    
    if (self.clearInputData) {
        self.tfMobile.text = @"";
        self.tfPassword.text = @"";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupInputBgviewAppreance {
    self.usernameBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.passwordBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.codeBgView.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark -App升级检测
- (void)upgradeDetection {
    [WJHUD showOnView:self.view];
    [RequestService upgradeDetectionWithResult:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            AppUpgradeModel *upgradeModel = (AppUpgradeModel*)object;
            if ([upgradeModel.versionStatus isEqualToString:@"0"]) {
//                [self authenticationDetection];
                
            }else if([upgradeModel.versionStatus isEqualToString:@"1"]) {
                //建议升级，弹出升级提示框，若不升级可以关闭提示框
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:upgradeModel.instruction preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self authenticationDetection];
                }];
                
                UIAlertAction *upgradeAction = [UIAlertAction actionWithTitle:@"升级" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //去下载APP
//                    upgradeModel.downloadURL;
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upgradeModel.downloadURL]];
                    
                }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:upgradeAction];
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
                
            }else if([upgradeModel.versionStatus isEqualToString:@"2"]) {
                //必须升级，弹出升级提示框，若不升级，直接退出app
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:upgradeModel.instruction preferredStyle:UIAlertControllerStyleAlert];
                
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////                    [[UserTool sharedUser] exitApplication];
//                    [self authenticationDetection];
//                }];
                
                UIAlertAction *upgradeAction = [UIAlertAction actionWithTitle:@"升级" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //去下载APP   upgradeModel.downloadURL;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upgradeModel.downloadURL]];
                }];
                
                [alertController addAction:upgradeAction];
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
            }
            
        }else {
            DLog(@"%@", object);
        }
    }];
}

#pragma mark - 解除绑定
- (IBAction)actionUnbindingDevice:(UIButton *)sender {
    UnbindDevicesVC *unbindDevicesVC = [[UnbindDevicesVC alloc] init];
    unbindDevicesVC.isLoginVC = YES;
    [self.navigationController pushViewController:unbindDevicesVC animated:YES];
}

#pragma mark -联系我们
- (IBAction)actionContactus:(UIButton *)sender {
    [RequestService queryAboutUsWithResult:^(BOOL success, id object) {
        if (success) {
            AboutUsDataModel *dataModel = object;
            ContactUSVC *contactUsVC = [[ContactUSVC alloc] init];
            contactUsVC.aboutUsDataModel = dataModel;
            contactUsVC.view.backgroundColor = [UIColor colorWithRed:0.0f green:0 blue:0 alpha:0.5];
            contactUsVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:contactUsVC animated:YES completion:^{
                
            }];
            
        }else {
            DLog(@"error = %@", object);
        }
        
    }];
}

#pragma mark -返回按钮
- (IBAction)actionBack:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.gesturePasswordView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 登录
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
- (IBAction)actionLogin:(id)sender {
    if ([self isSpaceOrEmpty:@[_tfMobile,_tfPassword]]) {
        [WJHUD showText:AlertMessageNOContent onView:self.view];
    }else
    {
        //登录验证
//        [WJHUD showOnView:self.view];
        NSString * despwd = [DESUtil encrypt:_tfPassword.text];
        NSString * passw = [despwd stringByReplacingOccurrencesOfString :@"+" withString:@"%2B"];
        if (![[UserTool sharedUser].userId isEqualToString:_tfMobile.text]) {
            [WJHUD showText:AlertMessageNotBindDevice onView:self.view];
            return;
        }
//        [UserTool sharedUser].userId = _tfMobile.text;
        [UserTool sharedUser].password = passw;
        [self autoLogin];
    }
}

- (void)sendLoginTokenToServer {
    [RequestService sendBindingTokenWithUDID:[UDIDManager getUDID] andLoginTolen:[UserTool sharedUser].loginToken andResult:^(BOOL success, id object) {
        if (success) {
            GeneralDataModel *dataModel = object;
            if ([dataModel.code isEqualToString:@"success"]) {
                DLog(@"登录 token 发送成功 %@", [UserTool sharedUser].loginToken);
                //设备绑定检测
//                [self deviceBindingDetection];
                [self getTabbarModulesInfo];
            }else {
                [WJHUD showText:@"未能更新Token" onView:self.view];
            }
            
        }else {
        
            DLog(@"error=%@", object);
        }
    }];
    
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 验证手势密码
- (void)verifyGesturePassWord{
    self.gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.gesturePasswordView.tentacleView setRerificationDelegate:self];
    [self.gesturePasswordView.tentacleView setStyle:1];
    self.gesturePasswordView.titleLabel.text = @"请输入手势密码";
    self.gesturePasswordView.state.text = @"";
    [self.gesturePasswordView setGesturePasswordDelegate:self];
    [self.view addSubview:self.gesturePasswordView];
}

#pragma mark - 重置手势密码
- (void)resetGesturePassWord{
    self.gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.gesturePasswordView.tentacleView setResetDelegate:self];
    [self.gesturePasswordView.tentacleView setStyle:2];
    [self.gesturePasswordView setGesturePasswordDelegate:self];
    //    [gesturePasswordView.imgView setHidden:YES];
    //    [gesturePasswordView.forgetButton setHidden:YES];
    //    [gesturePasswordView.changeButton setHidden:YES];
    [self.view addSubview:self.gesturePasswordView];
}

#pragma mark - 判断是否已存在手势密码
- (BOOL)exist{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""])return NO;
    return YES;
}

#pragma mark - 清空记录
- (void)clear{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    [keychin resetKeychainItem];
}

#pragma mark - 改变手势密码
- (void)change{
}

#pragma mark - 忘记手势密码
- (void)forget{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.gesturePasswordView.frame = CGRectMake(0, self.view.frame.size.height, self.gesturePasswordView.frame.size.width, self.gesturePasswordView.frame.size.height);
    } completion:^(BOOL finished) {
        self.backButton.hidden = NO;
    }];
}

- (BOOL)verification:(NSString *)result{
    if ([result isEqualToString:password]) {
        [self.gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [self.gesturePasswordView.state setText:@"输入正确"];
        //自动登录
        [self autoLogin];
        return YES;
    }
    [self.gesturePasswordView.state setTextColor:[UIColor redColor]];
    [self.gesturePasswordView.state setText:@"手势密码错误"];
    return NO;
}

#pragma mark -自动登录
- (void)autoLogin {
    [WJHUD showOnView:self.view];
    [RequestService loginWithUserName:[UserTool sharedUser].userId password:[UserTool sharedUser].password resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            LoginModel *model = (LoginModel *)object;
            if (model.validStatus == 2) {//验证成功
                [UserTool sharedUser].area = model.uesrDepName;
                [UserTool sharedUser].isLogin = YES;
                [UserTool sharedUser].username = model.userName;
                [self sendLoginTokenToServer];
            }else {//验证失败
                [WJHUD showText:model.message onView:self.view completionBlock:^{
                }];
            }
        }
    }];
}

- (void)getTabbarModulesInfo {
    [RequestService getChannelInfoWithType:@"0" andResult:^(BOOL success, id object) {
        if (success) {
            [UserTool sharedUser].tabbarModuleInfo = object;
            [self showTabBarController];
        }else {
            NSLog(@"getChannelInfoWithType:0 error = %@", object);
        }
    }];
}

- (void)showTabBarController {
//   CustomTabBarController *tabBarController = [[CustomTabBarController alloc] init];
//    AppDelegate *delegate = ShareApp;
//    delegate.tabBarController = tabBarController;
//    [self presentViewController:tabBarController animated:NO completion:nil];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSuccessNotification object:nil userInfo:nil];
}


#pragma mark ResetDelegate
- (BOOL)resetPassword:(NSString *)result{
    if ([previousString isEqualToString:@""]) {
        previousString=result;
        [self.gesturePasswordView.tentacleView enterArgin];
        [self.gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [self.gesturePasswordView.state setText:@"请验证输入密码"];
        return YES;
    }
    else {
        if ([result isEqualToString:previousString]) {
            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
            [keychin setObject:@"<帐号>" forKey:(__bridge id)kSecAttrAccount];
            [keychin setObject:result forKey:(__bridge id)kSecValueData];
            [self.gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            [self.gesturePasswordView.state setText:@"已保存手势密码"];
            typeof(self) __weak weakSelf = self;
            dispatch_after(1.0, dispatch_get_main_queue(), ^{
                 [weakSelf showTabBarController];
            });
            return YES;
        }
        else{
            previousString =@"";
            [self.gesturePasswordView.state setTextColor:[UIColor redColor]];
            [self.gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
            return NO;
        }
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    return YES;
}
//当前viewcontroller默认的屏幕方向 - 横屏显示
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
@end
