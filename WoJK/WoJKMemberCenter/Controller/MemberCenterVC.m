//
//  MemberCenterVC.m
//  WoJK
//
//  Created by Megatron on 16/4/14.
//  Copyright (c) 2016年 zhilong. All rights reserved.
//

#import "MemberCenterVC.h"
#import "FeedBackViewCtrl.h"
#import "AboutUsViewCtrl.h"
#import "Macro.h"
#import "MemberCenterCell.h"
#import "ReceiveNotificationSettingVC.h"
#import "RequestService.h"
#import "AppUpgradeModel.h"
#import "AppDelegate.h"
#import "UserTool.h"
#import "WJHUD.h"
#import "UnbindDevicesVC.h"
#import "SystemMessageVC.h"
#import "ChangeGestureCodeVC.h"
#import "DeviceModel.h"
#import "UDIDManager.h"
#import "GeneralDataModel.h"
#import "GeneralProblemsVC.h"
#import "RegisterViewController.h"
#import "BlueNavigationController.h"

NSString *cellIdentifier = @"cell";
@interface MemberCenterVC ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_operationTable;
    NSMutableArray *_imageAndTitleArr;
}
@end

@implementation MemberCenterVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UserTool sharedUser].currentModuleId = [[UserTool sharedUser] getTabbarModuleIdWithIndex:4];
    [self sendAccessLog];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)loadView {
    [super loadView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"个人中心";
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self.view addSubview: [self operationTable]];
    [self initImageAndTitleArr];
    [self hideNavigationBarDividedLine];

    [self initMemberHeaderInfo];
}

- (void)initMemberHeaderInfo {
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 144*self.scaleX)];
    headView.image = [UIImage imageNamed:@"memcenterBg.jpg"];
    UIImageView *appIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60*self.scaleX, 60*self.scaleX)];
    appIconImage.image = [UIImage imageNamed:@"circleIcon"];
    appIconImage.center = CGPointMake(self.view.frame.size.width/2, 144*self.scaleX/2);
    [headView addSubview:appIconImage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 30*self.scaleX)];
    label.center = CGPointMake(self.view.frame.size.width/2, 124*self.scaleX);
    label.text = [UserTool sharedUser].username;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [headView addSubview:label];
    [self.view addSubview:headView];
}

- (void)sendAccessLog {
    [RequestService sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:[[UserTool sharedUser] getTabbarModuleIdWithIndex:4] andInterfaceName:@"null"];
}

#pragma mark - UITableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imageAndTitleArr.count/2;
}



#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberCenterCell *showCell = (MemberCenterCell*)cell;
    showCell.titleLabel.text = _imageAndTitleArr[indexPath.row];
    showCell.iconImageView.image = [UIImage imageNamed:_imageAndTitleArr[indexPath.row + 7]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.view.frame.size.height > 568) {
        return 42.55*self.scaleX;
    }else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
            case 0:
            {
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:[[ReceiveNotificationSettingVC alloc] init] animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
                break;
            case 1:
            {
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:[[ChangeGestureCodeVC alloc] init] animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
                break;
            case 2:
            {
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:[[FeedBackViewCtrl alloc] init] animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
            break;
            case 3:
            {
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:[[AboutUsViewCtrl alloc] init] animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
                break;
            case 4:
            {
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:[[SystemMessageVC alloc] init] animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
                break;
            case 5:
            {
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:[[GeneralProblemsVC alloc] init] animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
                break;
            case 6:
            {
               [self versionDetection];
            }
                break;
            default:
                break;
        }
}


#pragma mark - PrivateMethods
- (UITableView *)operationTable {
    _operationTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 144*self.scaleX, self.view.frame.size.width, MainScreenHeight-144*self.scaleX-49) style:UITableViewStylePlain];
    _operationTable.delegate = self;
    _operationTable.dataSource = self;
    _operationTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if(MainScreenHeight > 568.0){
        _operationTable.scrollEnabled = NO;
    }
    _operationTable.backgroundColor = ColorWithRGB(240, 240, 240);
    [_operationTable registerNib:[UINib nibWithNibName:@"MemberCenterCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    
    NSLog(@"MainScreenHeight = %f MainScreenwidth= %f",MainScreenHeight, MainScreenWidth);
    
    float footerHight = 0;
    if (MainScreenHeight >568.0) {
        footerHight = 120*MainScreenHeight/480;
    }else {
        footerHight = 60;
    }
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  60*MainScreenHeight/480)];
    footerView.backgroundColor = ColorWithRGB(240, 240, 240);
    
    UIButton *quitAppBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quitAppBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 30*MainScreenWidth/320.0);
    quitAppBtn.center = CGPointMake(self.view.frame.size.width/2, footerView.frame.size.height/2);
    quitAppBtn.backgroundColor = ColorWithRGB(249, 100, 103);
    quitAppBtn.layer.cornerRadius = 15*MainScreenWidth/320.0;
    quitAppBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:20];
    [quitAppBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quitAppBtn setTitle:@"退出账户" forState:UIControlStateNormal];
    [quitAppBtn addTarget:self action:@selector(quitAppClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:quitAppBtn];
    _operationTable.tableFooterView = footerView;
    return _operationTable;
}

- (void)quitAppClick:(UIButton *)button {    
    [RequestService deleteBidingEquipWithEquipTpe:@"1" UUID:[UDIDManager getUDID] result:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            GeneralDataModel *dataModel = (GeneralDataModel *)object;
            if ([dataModel.code isEqualToString:@"success"]) {
                [self setupPotraitDisplayView];
//                [self.navigationController.parentViewController dismissViewControllerAnimated:YES completion:^{
//                }];
//                RegisterViewController *regVc = [[RegisterViewController alloc] init];
//                BlueNavigationController *navi = [[BlueNavigationController alloc] initWithRootViewController:regVc];
//                [self presentViewController:navi animated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserLogoutSuccessNotification object:nil];
                
                [self updateLoginToken];
                [UserTool sharedUser].isLogin = NO;
                [UserTool sharedUser].isBindingDevice = NO;
                [UserTool sharedUser].authenticationState = NO;
                [[UserTool sharedUser] clearGestureCode];
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

- (void)updateLoginToken {
    [RequestService sendBindingTokenWithUDID:[UDIDManager getUDID] andLoginTolen:@"userLogout" andResult:^(BOOL success, id object) {
    }];
}


- (void)versionDetection {
    [WJHUD showOnView:self.view];
    [RequestService upgradeDetectionWithResult:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            AppUpgradeModel *upgradeModel = (AppUpgradeModel*)object;
            if ([upgradeModel.versionStatus isEqualToString:@"0"]) {
                [WJHUD showText:AlertMessageNewestVersion onView:self.view];
                
            }else if([upgradeModel.versionStatus isEqualToString:@"1"]) {
                //建议升级，弹出升级提示框，若不升级可以关闭提示框
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:upgradeModel.instruction preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                UIAlertAction *upgradeAction = [UIAlertAction actionWithTitle:@"升级" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //去下载APP  upgradeModel.downloadURL;
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
//                    [[UserTool sharedUser] exitApplication];
//                }];
                
                UIAlertAction *upgradeAction = [UIAlertAction actionWithTitle:@"升级" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //去下载APP  upgradeModel.downloadURL;
                   
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

- (void)initImageAndTitleArr {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _imageAndTitleArr = [[NSMutableArray alloc] init];
    
    [_imageAndTitleArr addObject:@"推送设置"];
    [_imageAndTitleArr addObject:@"手势密码"];
    [_imageAndTitleArr addObject:@"意见反馈"];
    [_imageAndTitleArr addObject:@"关于我们"];
    [_imageAndTitleArr addObject:@"系统公告"];
    [_imageAndTitleArr addObject:@"常见问题"];
    [_imageAndTitleArr addObject:[NSString stringWithFormat:@"版本检测（当前%@）", app_Version]];
    [_imageAndTitleArr addObject:@"pushSetting"];
    [_imageAndTitleArr addObject:@"gestureIcon"];
    [_imageAndTitleArr addObject:@"feedBack"];
    [_imageAndTitleArr addObject:@"aboutus"];
    [_imageAndTitleArr addObject:@"systemMessage"];
    [_imageAndTitleArr addObject:@"generalQuestion"];
    [_imageAndTitleArr addObject:@"versionDetect"];
}
@end
