//
//  BenchmarkingVC.m
//  WoJK
//
//  Created by Megatron on 16/4/14.
//  Copyright (c) 2016年 zhilong. All rights reserved.
//

#import "BenchmarkingVC.h"
#import "Macro.h"
#import "RequestService.h"
#import "HomePageDataManager.h"
#import "UserTool.h"
#import "IndexAndCityVC.h"
#import "BaseTableHeaderView.h"
#import "SelectedAreaDataManager.h"
#import "SelectedKPIDataManager.h"
#import "AreaDataModel.h"
#import "KPIDataModel.h"
#import "AreaDisplayCell.h"
#import "DisplayAreaHeader.h"
#import "DeleteAreaAndIndexVC.h"
#import "DeviceModel.h"
#import "CompareKPIAndAreaVC.h"
#import "WJHUD.h"
#define lastOpenSection 9999
@interface BenchmarkingVC ()<UITableViewDelegate, UITableViewDataSource, TableHeaderViewDelegate>
{
    float _scaleX;
    UILabel *_selectedIndexLb;
    UILabel *_selectedCityLb;
    UITableView *_selectedIndexTable;
    UITableView *_selectedCityTable;
    
    NSMutableArray *_sectionData;
    NSMutableArray *_sourceDataOpenState;
    NSInteger _lastOpenedSection;
    
    
    NSMutableDictionary *_selectedKpiCache;
    NSMutableDictionary *_selectedAreaCache;
    
    BOOL _hideNavigationBar;
}
@end

@implementation BenchmarkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithRGB(240, 240, 240);
    self.navigationItem.title = @"横向对标";
    
    _scaleX = MainScreenWidth/320.0;
    [self hideNavigationBarDividedLine];
    [self addIndexSelectItem];
    [self addCompareButton];
}

- (void)sendAccessLog {
    [RequestService sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel]andModuleId:[[UserTool sharedUser] getTabbarModuleIdWithIndex:3] andInterfaceName:@"null"];
}

- (void)getCacheData{
    _selectedKpiCache = [NSMutableDictionary dictionaryWithDictionary:[SelectedKPIDataManager querySelectedKPIData]];
    
    _selectedAreaCache = [NSMutableDictionary dictionaryWithDictionary:[SelectedAreaDataManager querySelectedAreaData]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getCacheData];
    [_selectedIndexTable reloadData];
    [_selectedCityTable reloadData];
    [self setupPotraitDisplayView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _hideNavigationBar = NO;
    [UserTool sharedUser].currentModuleId = [[UserTool sharedUser] getTabbarModuleIdWithIndex:3];
    [self sendAccessLog];
    
//    if (AboveiOS7) {
//        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    }else{
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    }
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,nil]];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_hideNavigationBar) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)setupRightSettingBtn {
    typeof (self) __weak weakSelf = self;
    [self setRightNavigationBarButtonItemWithImage:@"settings" andAction:^{
        weakSelf.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:[[IndexAndCityVC alloc] init] animated:YES];
        weakSelf.hidesBottomBarWhenPushed = NO;
    }];
}

#pragma mark 指标和城市选择
- (void)addIndexSelectItem {
    _selectedIndexTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth-20, (MainScreenHeight-80-64-49)/2) style:UITableViewStylePlain];
//    _selectedIndexAndCityTable.backgroundColor = [UIColor redColor];
    _selectedIndexTable.delegate = self;
    _selectedIndexTable.dataSource = self;
//    _selectedIndexAndCityTable.scrollEnabled = NO;
    [_selectedIndexTable registerNib:[UINib nibWithNibName:@"AreaDisplayCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    _selectedIndexTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _selectedIndexTable.layer.cornerRadius = 4.0;
    [self.view addSubview:_selectedIndexTable];
    
    
    _selectedCityTable = [[UITableView alloc] initWithFrame:CGRectMake(10, (MainScreenHeight-80-64-49)/2+20, MainScreenWidth-20, (MainScreenHeight-80-64-49)/2) style:UITableViewStylePlain];
    //    _selectedIndexAndCityTable.backgroundColor = [UIColor redColor];
    _selectedCityTable.delegate = self;
    _selectedCityTable.dataSource = self;
    //    _selectedIndexAndCityTable.scrollEnabled = NO;
    [_selectedCityTable registerNib:[UINib nibWithNibName:@"AreaDisplayCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    _selectedCityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _selectedCityTable.layer.cornerRadius = 4.0;
    [self.view addSubview:_selectedCityTable];
    
    
    
    [self initSourceDataOpenState];
}

- (void)initSourceDataOpenState{
    _sectionData = [[NSMutableArray alloc] init];
    [_sectionData addObject:@"经营指标"];
    [_sectionData addObject:@"对标地区"];
    _sourceDataOpenState = [[NSMutableArray alloc] init];
    for (int i = 0; i< [_sectionData count]; i++) {
        [_sourceDataOpenState addObject:[NSNumber numberWithBool:true]];
    }
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _selectedIndexTable) {
        NSArray *allKeys = [_selectedKpiCache allKeys];
        return  allKeys ? allKeys.count : 0;
    }else {
        NSArray *allKeys = [_selectedAreaCache allKeys];
        return  allKeys ? allKeys.count : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    AreaDisplayCell *showCell = (AreaDisplayCell *)cell;
    if (tableView == _selectedIndexTable) {
        NSArray *allKeys = [_selectedKpiCache allKeys];
        DLog(@"_selectedKpiCache allKeys = %@", allKeys);
        KPIDataModel *dataModel = [_selectedKpiCache objectForKey:allKeys[indexPath.row]];
        showCell.titleLB.text = dataModel.kpiName;
        showCell.flagImage.hidden = YES;
        showCell.deleteBlock = ^(){
            [SelectedKPIDataManager deleteKPIByCode:dataModel.kpiCode];
            [_selectedKpiCache removeObjectForKey:dataModel.kpiCode];
            [_selectedIndexTable reloadData];
        };
    }else if(tableView == _selectedCityTable) {
        NSArray *allKeys = [_selectedAreaCache allKeys];
        DLog(@"_selectedAreaCache allKeys = %@", allKeys);
        AreaDataModel *dataModel = [_selectedAreaCache objectForKey:allKeys[indexPath.row]];
        showCell.titleLB.text = dataModel.areaName;
        if (dataModel.flag == 0) {
            showCell.flagImage.hidden = YES;
        }else if (dataModel.flag == 1){
            showCell.flagImage.hidden = NO;
        }
        showCell.deleteBlock = ^(){
            [SelectedAreaDataManager deleteAreaDataByCode:dataModel.areaCode];
            [_selectedAreaCache removeObjectForKey:dataModel.areaCode];
            [_selectedCityTable reloadData];
        };
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[DeviceModel getCurrentDeviceModel] containsString:@"iPhone6"]) {
        return tableView.frame.size.height/5;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerFooterViewIdentify = @"headerFooter";
    DisplayAreaHeader *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterViewIdentify];
    if (!headerFooterView) {
        headerFooterView = [[DisplayAreaHeader alloc] initWithReuseIdentifier:headerFooterViewIdentify];
        headerFooterView.indicatorImgView.hidden = YES;
        headerFooterView.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    NSString *headerTitle = @"";
    if (tableView == _selectedCityTable) {
        headerTitle = _sectionData[1];
    }else {
        headerTitle = _sectionData[0];
    }
    headerFooterView.titleLabel.text = [NSString stringWithFormat:@"%@", headerTitle];
    headerFooterView.titleLabel.font = [UIFont fontWithName:@"Arial" size:20];
    headerFooterView.titleLabel.textAlignment = NSTextAlignmentCenter;
    headerFooterView.titleLabel.textColor = MAIN_COLOR;
    headerFooterView.isOpen = [_sourceDataOpenState[section] boolValue];
    
    typeof(self) __weak weakSelf = self;
    headerFooterView.deleteBlock = ^(){
        DeleteAreaAndIndexVC *areaVc = [[DeleteAreaAndIndexVC alloc] init];
        if (tableView == _selectedIndexTable) {
            areaVc.isAreaData = NO;
        }else {
            areaVc.isAreaData = YES;
        }
        weakSelf.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:areaVc animated:YES];
        weakSelf.hidesBottomBarWhenPushed = NO;
    };
    
    headerFooterView.settingsBlock = ^(){
        IndexAndCityVC *areaAndIndexVc = [[IndexAndCityVC alloc] init];
        if (tableView == _selectedIndexTable) {
            areaAndIndexVc.isIndex = YES;
        }else {
            areaAndIndexVc.isIndex = NO;
        }
        weakSelf.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:areaAndIndexVc animated:YES];
        weakSelf.hidesBottomBarWhenPushed = NO;
    
    };
    
    return headerFooterView;
}

- (void)addCompareButton {
    UIButton *quitAppBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quitAppBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 30*MainScreenWidth/320.0);
    quitAppBtn.center = CGPointMake(self.view.frame.size.width/2, CGRectGetMaxY( _selectedCityTable.frame)+ (MainScreenHeight - 49 - 64 - CGRectGetMaxY( _selectedCityTable.frame))/2);
    quitAppBtn.backgroundColor = ColorWithRGB(249, 100, 103);
    quitAppBtn.layer.cornerRadius = 15*MainScreenWidth/320.0;
    quitAppBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:20];
    [quitAppBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quitAppBtn setTitle:@"开始对比" forState:UIControlStateNormal];
    [quitAppBtn addTarget:self action:@selector(startCompare:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitAppBtn];
}

#pragma mark - TableHeaderViewDelegate
- (void)headerViewDidTaped:(BaseTableHeaderView *)tableHeaderView sectionIndex:(NSInteger)sectionIndex
{
    if (_lastOpenedSection != lastOpenSection && _lastOpenedSection != sectionIndex) {
        //说明 有未关闭section 需先关闭
        NSNumber *number = _sourceDataOpenState[_lastOpenedSection];
        if ([number boolValue]) {
            NSNumber *numberNew = [NSNumber numberWithBool:![number boolValue]];
            [_sourceDataOpenState replaceObjectAtIndex:_lastOpenedSection withObject:numberNew];
        }
    }
    
    NSNumber *number = _sourceDataOpenState[sectionIndex];
    NSNumber *numberNew = [NSNumber numberWithBool:![number boolValue]];
    [_sourceDataOpenState replaceObjectAtIndex:sectionIndex withObject:numberNew];
    _lastOpenedSection = sectionIndex;
//    [_selectedIndexAndCityTable reloadData];
}

- (void)startCompare:(UIButton *)button {
    if (![self checkAreaAndKpiData]) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    _hideNavigationBar = YES;
    [self setupLandScapeDisplayView];
    CompareKPIAndAreaVC *compareVc = [[CompareKPIAndAreaVC alloc] init];
    compareVc.kpiDict = _selectedKpiCache;
    compareVc.areaDict = _selectedAreaCache;
    [self.navigationController pushViewController:compareVc animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

- (BOOL)checkAreaAndKpiData {
    if (_selectedKpiCache.count == 0) {
        [WJHUD showText:@"请选择指标" onView:self.view];
        return NO;
    }else if(_selectedAreaCache.count == 0){
        [WJHUD showText:@"请选择地区" onView:self.view];
        return NO;
    }
    return YES;
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

@end
