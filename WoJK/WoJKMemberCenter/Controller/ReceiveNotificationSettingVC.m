//
//  ReceiveNotificationSettingVC.m
//  WoJK
//
//  Created by Megatron on 16/4/28.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "ReceiveNotificationSettingVC.h"
#import "Macro.h"
#import "RequestService.h"
#import "GeneralDataModel.h"
#import "WJHUD.h"

@interface ReceiveNotificationSettingVC ()

@property (strong, nonatomic) IBOutlet UISwitch *warningSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *accountSwitch;
@end

@implementation ReceiveNotificationSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推送设置";
    [self setupLeftBackButton];
    [self setupSwitchAppreance];
    [self getPushStatus];
}

- (void)getPushStatus {
    [RequestService getPushStatusWithType:@"2" andResult:^(BOOL success, id object) {
        if (success) {
            NSString *flag = (NSString *)object;
            if ([flag isEqualToString:@"0"]) {
                [self.warningSwitch setOn:NO];
            }else if ([flag isEqualToString:@"1"]){
                [self.warningSwitch setOn:YES];
            }
        }else {
            DLog(@"error = %@", object);
        }
    }];
    
    [RequestService getPushStatusWithType:@"1" andResult:^(BOOL success, id object) {
        if (success) {
            NSString *flag = (NSString *)object;
            if ([flag isEqualToString:@"0"]) {
                [self.accountSwitch setOn:NO];
            }else if ([flag isEqualToString:@"1"]){
                [self.accountSwitch setOn:YES];
            }
        }else {
            DLog(@"error = %@", object);
        }
    }];
}

- (void)setupSwitchAppreance {
    self.warningSwitch.onTintColor = MAIN_COLOR;
    self.accountSwitch.onTintColor = MAIN_COLOR;
}


- (IBAction)accountAction:(UISwitch *)sender {
    [RequestService setPushStatusWithType:@"1" andStatus:[NSString stringWithFormat:@"%@", sender.on ? @"1" : @"0"] andResult:^(BOOL success, id object) {
        if (success) {
            GeneralDataModel *model = (GeneralDataModel*)object;
            if ([model.code isEqualToString:@"success"]) {
                [WJHUD showText:AlertMessageSetDataSuccess onView:self.view completionBlock:^{
                }];
            }else {
                [WJHUD showText:AlertMessageGetDataFailure onView:self.view completionBlock:^{
                    
                }];
            }
        }else {
            DLog(@"error = %@", object);
        }
    }];
}

- (IBAction)warningAction:(UISwitch *)sender {
    [RequestService setPushStatusWithType:@"2" andStatus:[NSString stringWithFormat:@"%@", sender.on ? @"1" : @"0"] andResult:^(BOOL success, id object) {
        if (success) {
            GeneralDataModel *model = (GeneralDataModel*)object;
            if ([model.code isEqualToString:@"success"]) {
                [WJHUD showText:AlertMessageSetDataSuccess onView:self.view completionBlock:^{
                }];
            }else {
                [WJHUD showText:AlertMessageGetDataFailure onView:self.view completionBlock:^{
                    
                }];
            }
        }else {
            DLog(@"error = %@", object);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
