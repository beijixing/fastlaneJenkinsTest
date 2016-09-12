//
//  UnbindDevicesVC.m
//  WoJK
//
//  Created by Megatron on 16/5/6.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "UnbindDevicesVC.h"
#import "RequestService.h"
#import "UserTool.h"
#import "SMSCodeModel.h"
#import "WJHUD.h"
#import "Macro.h"
#import "Validator.h"
#import "UDIDManager.h"
#import "DeviceBindingModel.h"
#import "LoginModel.h"
#import "BindingDeviceCell.h"
#import "GeneralDataModel.h"
#import "RegisterViewController.h"
#import "DESUtil.h"
#import "AuthenticationModel.h"


@interface UnbindDevicesVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _times;
    NSTimer *_timer;
    BOOL _back;
}

@property (strong, nonatomic) IBOutlet UITableView *bindingDeviceTable;
@property (weak, nonatomic) IBOutlet UITextField *tfMobile;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (copy, nonatomic) NSString *codeStr;
@property (strong, nonatomic) NSMutableArray *userEquipsArr;
@end

@implementation UnbindDevicesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    typeof(self) __weak weakSelf = self;
    [self setLeftNavigationBarButtonItemWithImage:@"nav_icon_back.png" andAction:^{
        [weakSelf backAction];
    }];
    self.navigationItem.title = @"解除绑定";
    self.bindingDeviceTable.hidden = YES;
    _back = NO;
    [self setupBindingDeviceTable];
}

- (void)backAction {
    _back = YES;
    [self deviceBindingDetection];
}

- (void)setupBindingDeviceTable {
    [self.bindingDeviceTable registerNib:[UINib nibWithNibName:@"BindingDeviceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BindingDeviceCell"];
    self.bindingDeviceTable.separatorEffect = UITableViewCellSeparatorStyleNone;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userEquipsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BindingDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindingDeviceCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BindingDeviceCell *showCell = (BindingDeviceCell *)cell;
    NSDictionary *dataDict = self.userEquipsArr[indexPath.row];
    NSInteger eType = [[dataDict objectForKey:@"equipType"] integerValue];
    if (eType == 1) {
        showCell.deviceTypeLB.text = @"iPhone";
    }else if (eType == 3) {
        showCell.deviceTypeLB.text = @"Android";
    }
    
    showCell.deviceNoLB.text = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"udid"]];
}

#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NSDictionary *dataDict = self.userEquipsArr[indexPath.row];
        [WJHUD showOnView:self.view];
        [RequestService deleteBidingEquipWithEquipTpe:[NSString stringWithFormat:@"%@", [dataDict objectForKey:@"equipType"]] UUID:[NSString stringWithFormat:@"%@", [dataDict objectForKey:@"udid"]] result:^(BOOL success, id object) {
            [WJHUD hideFromView:self.view];
            if (success) {
                GeneralDataModel *dataModel = (GeneralDataModel *)object;
                if ([dataModel.code isEqualToString:@"success"]) {
                    [self.userEquipsArr removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }else {
                    //删除绑定失败
                    [WJHUD showText:dataModel.message onView:self.view completionBlock:^{
                    }];
                }
            }else {
                DLog(@"error  =%@", object);
            }
         }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark ButtonActions

- (IBAction)actionVerifyCode:(UIButton *)sender {
    if ([_tfMobile.text isEqualToString:@""]) {
        [WJHUD showText:AlertMessageNOUserName onView:self.view];
        return ;
    }else if (_tfMobile.text.length>15){
        [WJHUD showText:@"密码长度超过限制" onView:self.view];
        return ;
    }
    
    if ([self isSpaceOrEmpty:@[_tfMobile,_tfPassword]]) {
        [WJHUD showText:AlertMessageNOContent onView:self.view];
    }else{
        
        NSString * despwd = [DESUtil encrypt:_tfPassword.text];
        NSString * passw = [despwd stringByReplacingOccurrencesOfString :@"+" withString:@"%2B"];
        [UserTool sharedUser].userId = _tfMobile.text;
        [UserTool sharedUser].password = passw;
        [self verifyPasswordBeforeGetSMSCode];
//        [WJHUD showOnView:self.view];
//        NSString *base64Pswd = [[UserTool sharedUser] getBase64EncodedStringFromString:_tfPassword.text];
//        [RequestService getEncryptedPasswordWiithPassword:base64Pswd userName:_tfMobile.text andResultBlock:^(BOOL success, id object) {
//            [WJHUD hideFromView:self.view];
//            if (success) {
//                GeneralDataModel *dataModel = object;
//                if ([dataModel.code isEqualToString:@"success"]) {
//                    [UserTool sharedUser].userId = _tfMobile.text;
//                    [UserTool sharedUser].password = dataModel.message;
//                    [self verifyPasswordBeforeGetSMSCode];
//                }
//            }else {
//                DLog(@"error= %@",object);
//            }
//        }];
    }
    
}

- (void)verifyPasswordBeforeGetSMSCode{
    [RequestService loginWithUserName:[UserTool sharedUser].userId password:[UserTool sharedUser].password resultBlock:^(BOOL success, id object) {
        if (success) {
            LoginModel *model = (LoginModel *)object;
            if (model.validStatus == 2) {//验证成功
                [self sendSMSCodeRequest];
            }else {//验证失败
                [WJHUD showText:model.message onView:self.view completionBlock:^{
                }];
            }
        }
    }];
}

- (void)sendSMSCodeRequest {
    [WJHUD showOnView:self.view];
    [RequestService getAuthenticationSMSCodeWithUserId:[UserTool sharedUser].userId result:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            SMSCodeModel *model = (SMSCodeModel *)object;
            self.codeStr =  [NSString stringWithFormat:@"%@", model.verificationCode];
            [WJHUD showText:model.message onView:self.view completionBlock:^{
                if ([model.code isEqualToString:@"success"]) {
                    _times = 60;
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(actionTimer) userInfo:nil repeats:YES];
                    [_timer fire];
                    [self btnVerifyCodeState:NO];
                }else
                {
                    [self btnVerifyCodeState:YES];
                }
            }];
        }else{
            DLog(@"error = %@", object);
            [self btnVerifyCodeState:YES];
            [_timer invalidate];
        }
    }];
}

- (void)actionTimer {
    _times --;
    if (_times==0) {
        [_timer invalidate];
        [self btnVerifyCodeState:YES];
    }else
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:_times]] forState:UIControlStateNormal];
}

- (void)btnVerifyCodeState:(BOOL)state {
    self.codeBtn.enabled = state;
    if (state) {
        //        [self.codeBtn setTitleColor:[UIColor colorWithRed:0.220 green:0.718 blue:0.941 alpha:1.000] forState:UIControlStateNormal];
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        //        [self.codeBtn setBackgroundColor:[UIColor whiteColor]];
    }else
    {
        //        [self.codeBtn setTitleColor:[UIColor colorWithWhite:0.298 alpha:1.000] forState:UIControlStateNormal];
        //        [self.codeBtn setBackgroundColor:[UIColor lightGrayColor]];
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

- (IBAction)actionCheckBindingDevice:(UIButton *)sender {
    if ([_tfMobile.text isEqualToString:@""]) {
        [WJHUD showText:AlertMessageNOUserName onView:self.view];
        return ;
    }else if ([_tfPassword.text isEqualToString:@""]){
        [WJHUD showText:AlertMessageNOPSWD onView:self.view];
        return ;
    }
    
    //TODO 检测验证码
    if ([UserTool sharedUser].hasSMSCode){
        if (![self.codeStr isEqualToString:_tfCode.text]) {
            [WJHUD showText:AlertMessageWrongVerifyCode onView:self.view];
            return;
        }
    }
    
    NSString *udid = [UDIDManager getUDID];
    [WJHUD showOnView:self.view];
    [RequestService authenticationDetectionWithUDID:udid result:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            AuthenticationModel *dataModel = (AuthenticationModel *)object;
            if ([dataModel.code isEqualToString:@"success"]) {//成功
                [self sendLoginTokenToServer];
                
            }else {
                DLog(@"未认证");
                //认证页面和手势处理
                 [WJHUD showText:dataModel.message onView:self.view];
            }
        }
    }];
}

- (void)sendLoginTokenToServer {
    [RequestService sendBindingTokenWithUDID:[UDIDManager getUDID] andLoginTolen:[UserTool sharedUser].loginToken andResult:^(BOOL success, id object) {
        if (success) {
            GeneralDataModel *dataModel = object;
            if ([dataModel.code isEqualToString:@"success"]) {
                DLog(@"登录 token 发送成功 %@", [UserTool sharedUser].loginToken);
                //设备绑定检测
                [self deviceBindingDetection];
            }else {
                [WJHUD showText:@"更新Token失败" onView:self.view];
            }
            
        }else {
            
            DLog(@"error=%@", object);
        }
    }];
    
}

#pragma mark -判断绑定关系
- (void)deviceBindingDetection {
    NSString *udid = [UDIDManager getUDID];
    [RequestService deviceBindingDetectionWithUDID:udid result:^(BOOL success, id object) {
        if (success) {
            DeviceBindingModel *dataModel = (DeviceBindingModel *)object;
//            if ( dataModel.udidIsExist == 1) {//存在
                //刷新列表
                if ([dataModel.userEquips isKindOfClass:[NSDictionary class]]) {
                    NSArray *euqips = [dataModel.userEquips objectForKey:@"userEquip"];
                    self.userEquipsArr = [NSMutableArray arrayWithArray:euqips];
                    self.bindingDeviceTable.hidden = NO;
                    [self.bindingDeviceTable reloadData];
                }else {
                    [WJHUD showText:@"没有绑定设备" onView:self.view];
                }
//            }else if(dataModel.udidIsExist == 2) {//不存在
//                [WJHUD showText:@"没有绑定设备" onView:self.view];
//            }
            if (dataModel.udidIsExist == 2 && _back) {
                [UserTool sharedUser].authenticationState = NO;
                if (self.isLoginVC) {
                    [self presentViewController:[[RegisterViewController alloc] init] animated:YES completion:^{
                    }];
                }
            }
        }else {
            DLog(@"%@", object);
        }
    }];
    
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
