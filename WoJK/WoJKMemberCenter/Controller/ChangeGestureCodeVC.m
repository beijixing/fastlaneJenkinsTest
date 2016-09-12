//
//  ChangeGestureCodeVC.m
//  WoJK
//
//  Created by Megatron on 16/5/13.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "ChangeGestureCodeVC.h"
#import "Macro.h"
#import "KeychainItemWrapper.h"
#import "GesturePasswordView.h"
#import "WJHUD.h"
#import "UserTool.h"
#import "RequestService.h"
#import "DeviceModel.h"

@interface ChangeGestureCodeVC ()<VerificationDelegate,ResetDelegate>
@property (strong, nonatomic) IBOutlet UISwitch *changeGestureSwitch;
@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *previousString;
@property (nonatomic, assign) NSInteger wrongGestureCnt;
@end

@implementation ChangeGestureCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手势密码";
    [self setupLeftBackButton];
    [self setupGestureSwitch];
}

- (void)setupGestureSwitch {
    
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    self.password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([self.password isEqualToString:@""]) {
        self.changeGestureSwitch.on = NO;
    }else {
        self.changeGestureSwitch.on = YES;
    }
    [self.changeGestureSwitch setOnTintColor:MAIN_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionChangeGesture:(UISwitch *)sender {
    if (sender.isOn) {
            //重新设置手势密码
        self.previousString = [NSString string];
        [self resetGesturePassWord];

    }else {
        //验证手势密码，正确后删除旧密码
        [self verifyGesturePassWord];
    }
    [self sendAccessLog];
}

- (void)sendAccessLog {
    [RequestService sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:@"null" andInterfaceName:@"setSignPassword"];
}

#pragma mark - 重置手势密码
- (void)resetGesturePassWord{
    self.gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.gesturePasswordView.tentacleView setResetDelegate:self];
    self.gesturePasswordView.forgetButton.hidden = YES;
    [self.gesturePasswordView.tentacleView setStyle:2];
//    [self.gesturePasswordView setGesturePasswordDelegate:self];
    //    [gesturePasswordView.imgView setHidden:YES];
    //    [gesturePasswordView.forgetButton setHidden:YES];
    //    [gesturePasswordView.changeButton setHidden:YES];
    self.gesturePasswordView.titleLabel.text = @"设置手势密码";
    self.gesturePasswordView.state.text = @"请绘制手势密码";
    
    [self.view addSubview:self.gesturePasswordView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)verifyGesturePassWord{
    self.gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.gesturePasswordView.tentacleView setRerificationDelegate:self];
    [self.gesturePasswordView.tentacleView setStyle:1];
    self.gesturePasswordView.forgetButton.hidden = YES;
//    [self.gesturePasswordView setGesturePasswordDelegate:self];
    self.gesturePasswordView.titleLabel.text = @"关闭手势密码";
    self.gesturePasswordView.state.text = @"请绘制手势密码";
    [self.view addSubview:self.gesturePasswordView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark ResetDelegate
- (BOOL)resetPassword:(NSString *)result{
    if ([self.previousString isEqualToString:@""]) {
        self.previousString=result;
        [self.gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [self.gesturePasswordView.state setText:@"请再次输入密码"];
        return YES;
    }
    else {
        if ([result isEqualToString:self.previousString]) {
            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
            [keychin setObject:@"<帐号>" forKey:(__bridge id)kSecAttrAccount];
            [keychin setObject:result forKey:(__bridge id)kSecValueData];
            //[self presentViewController:(UIViewController) animated:YES completion:nil];
            [self.gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            [self.gesturePasswordView.state setText:@"已保存手势密码"];
            [self.gesturePasswordView removeFromSuperview];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            return YES;
        }
        else{
            self.previousString =@"";
            [self.gesturePasswordView.state setTextColor:[UIColor redColor]];
            [self.gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
            return NO;
        }
    }
}

- (BOOL)verification:(NSString *)result{
    self.wrongGestureCnt++;
    if (self.wrongGestureCnt >= 3) {
//        [self.gesturePasswordView.state setTextColor:[UIColor redColor]];
//        [self.gesturePasswordView.state setText:@"请2分钟后再试"];
//        if (self.wrongGestureCnt == 3) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                _wrongGestureCnt = 0;
//            });
//        }
//        return NO;
        self.wrongGestureCnt = 0;
        self.changeGestureSwitch.on = YES;
        
        typeof(self) __weak weakSelf = self;
        [WJHUD showText:@"请稍后再试" onView:self.view completionBlock:^{
            [weakSelf.gesturePasswordView removeFromSuperview];
            [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
        }];
       
    }
    
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    self.password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([result isEqualToString:self.password]) {
        [self.gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [self.gesturePasswordView.state setText:@"输入正确"];
        
        [self.gesturePasswordView removeFromSuperview];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [[UserTool sharedUser] clearGestureCode];
        return YES;
    }
    
    [self.gesturePasswordView.state setTextColor:[UIColor redColor]];
    [self.gesturePasswordView.state setText:@"手势密码错误"];
    
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
