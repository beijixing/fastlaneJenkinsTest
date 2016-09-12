//
//  WarningSettingVC.m
//  WoJK
//
//  Created by Megatron on 16/4/22.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "WarningSettingVC.h"
#import "Macro.h"
#import "RequestService.h"
#import "WarnSettingCell.h"
#import "WarningSettingDataModel.h"
#import "WJHUD.h"
#import "WarnSettingSectionModel.h"
#import "WarnSettingTargetModel.h"
#import "WarnSettingHeader.h"
#import "GeneralDataModel.h"

@interface WarningSettingVC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *settingSegmentControl;
@property (nonatomic, strong) WarningSettingDataModel *warningSettingModel;
@property (nonatomic, strong) UITableViewCell *prototypeCell;
@property (strong, nonatomic) IBOutlet UITableView *warningSettingTable;
@end

@implementation WarningSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBackButton];
    self.navigationItem.title = @"告警设置";
    [self hideNavigationBarDividedLine];
    [self setupSettingSegmentedControl];
    
    
    if (self.isDayWarning) {
        self.settingSegmentControl.selectedSegmentIndex = 0;
    }else {
        self.settingSegmentControl.selectedSegmentIndex = 1;
    }
    
    [self getDailyTargetSearch];
    [self setupWarningSettingTable];
}

- (void)setupWarningSettingTable {
    
    
    [self.warningSettingTable registerNib:[UINib nibWithNibName:@"WarnSettingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WarnSettingCell"];
    self.warningSettingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.warningSettingTable registerClass:[WarnSettingHeader class]forHeaderFooterViewReuseIdentifier:@"WarnSettingHeader"];
    self.prototypeCell = [self.warningSettingTable dequeueReusableCellWithIdentifier:@"WarnSettingCell"];
}

- (void)getDailyTargetSearch {
    [WJHUD showOnView:self.view];
    [RequestService getDailyTargetSearchWithTargetType:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.settingSegmentControl.selectedSegmentIndex+1]] result:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            WarningSettingDataModel *dataModel = (WarningSettingDataModel*)object;
            if ([dataModel.code isEqualToString:@"success"]) {
                self.warningSettingModel = dataModel;
                [self.warningSettingTable reloadData];
            }else {
                [WJHUD showText:AlertMessageGetDataFailure onView:self.view];
            }
    
        }else {
            DLog(@"error = %@", object);
        }
    }];
}

- (void)setupSettingSegmentedControl {
    self.settingSegmentControl.tintColor = [UIColor whiteColor];
    self.settingSegmentControl.layer.cornerRadius = 14.5;
    self.settingSegmentControl.layer.masksToBounds = YES;
    self.settingSegmentControl.layer.borderWidth = 1.0;
    self.settingSegmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
    self.settingSegmentControl.layer.frame = CGRectMake(MainScreenWidth/2-80, 0, 160, 30);
}
- (IBAction)segmentedControlAction:(UISegmentedControl *)sender {
    [self getDailyTargetSearch];
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.warningSettingModel.settingSectionModelArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WarnSettingSectionModel *sectionDataModel = [self.warningSettingModel.settingSectionModelArr objectAtIndex:section];
    
    return sectionDataModel.settingTargetArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WarnSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarnSettingCell"];
    cell.warnStateSwitch.onTintColor = MAIN_COLOR;
    return cell;
}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    WarnSettingSectionModel *sectionDataModel = [self.warningSettingModel.settingSectionModelArr objectAtIndex:section];
//    return sectionDataModel.targetSpeciesName;
//}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WarnSettingCell *showCell = (WarnSettingCell *)cell;
    WarnSettingSectionModel *sectionDataModel = [self.warningSettingModel.settingSectionModelArr objectAtIndex:indexPath.section];
    WarnSettingTargetModel *settingTargetModel = sectionDataModel.settingTargetArr[indexPath.row];
    showCell.indexName.text = settingTargetModel.targetName;
    showCell.warnStateSwitch.on = settingTargetModel.isSelect == 0 ? NO : YES;
    
    showCell.switchAction = ^(BOOL on){
        NSString *operationType = @"";
        if (on) {
            operationType = @"add";
        }else {
            operationType = @"delete";
        }
        
        [RequestService setDailySettingWithTargetId:settingTargetModel.targetId targetType:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.settingSegmentControl.selectedSegmentIndex+1]] operate:operationType andResult:^(BOOL success, id object) {
            if (success) {
                GeneralDataModel *dataMoedl = (GeneralDataModel*)object;
                if([dataMoedl.code isEqualToString:@"success"]) {
                    //[WJHUD showText:AlertMessageSetDataSuccess onView:self.view];
                }else {
                    //[WJHUD showText:dataMoedl.message onView:self.view];
                }
            }else {
                DLog(@"error=%@", object);
            }
            
        }];
    
    };
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WarnSettingHeader *tableHeader = (WarnSettingHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WarnSettingHeader"];
   WarnSettingSectionModel *sectionDataModel = [self.warningSettingModel.settingSectionModelArr objectAtIndex:section];
    tableHeader.titleLabel.text = sectionDataModel.targetSpeciesName;
    return tableHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WarnSettingCell *cell = (WarnSettingCell *)self.prototypeCell;
    WarnSettingSectionModel *sectionDataModel = [self.warningSettingModel.settingSectionModelArr objectAtIndex:indexPath.section];
    WarnSettingTargetModel *settingTargetModel = sectionDataModel.settingTargetArr[indexPath.row];
    cell.indexName.text = settingTargetModel.targetName;
   
    UILabel * tempLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-72, CGFLOAT_MAX)];//随便写反正不添加到cell上面
    
    tempLabel.text = settingTargetModel.targetName;
    
    CGSize size =[self labelheight:tempLabel];
    
    DLog(@"h=%f", size.height + 12);
    if (size.height + 12 > 44) {
        return size.height + 12;
    }else{
        return 44;
    }
    
}

- (CGSize)labelheight:(UILabel *)detlabel

{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 72, CGFLOAT_MAX);
    
    CGSize contentactually = [detlabel.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    
    return contentactually;
    
}


//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//   
//}


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
