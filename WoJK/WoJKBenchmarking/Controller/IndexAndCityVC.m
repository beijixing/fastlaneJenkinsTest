//
//  IndexAndCityVC.m
//  WoJK
//
//  Created by Megatron on 16/5/9.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "IndexAndCityVC.h"
#import "Macro.h"
#import "RequestService.h"
#import "UserTool.h"
#import "BaseTableHeaderView.h"
#import "IndexAndCityCell.h"
#import "KPIModel.h"
#import "WJHUD.h"
#import "AreaResponseModel.h"
#import "AreaDataModel.h"
#import "SelectedAreaDataManager.h"
#import "SelectedKPIDataManager.h"
#import "KPIAndAreaTableHeader.h"
#import "IndexCell.h"
#define lastOpenSection 9999
@interface IndexAndCityVC ()<TableHeaderViewDelegate,UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_dataTableView;
    NSArray *_provinceInfoArr;
//    NSArray *_cityInfoArr;
    NSMutableArray *_sourceDataOpenState;
    NSInteger _lastOpenedSection;
    NSMutableDictionary *_cityInfoCache;
    UISegmentedControl *_segmentedControl;
    BOOL _isIndexSelected;
    KPIModel *_kpiModel;
    
    NSMutableDictionary *_selectedKpiCache;
    NSMutableDictionary *_selectedAreaCache;
    AreaDataModel *_selectedPoleCity;
    
    NSInteger _maxIndexCnt;
    NSInteger _maxAreaCnt;
}
@end


@implementation IndexAndCityVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _lastOpenedSection = lastOpenSection;
    _isIndexSelected = YES;
    _cityInfoCache = [[NSMutableDictionary alloc] init];
//    _selectedKpiCache = [[NSMutableDictionary alloc] init];
//    _selectedAreaCache = [[NSMutableDictionary alloc] init];
    [self getCacheData];
    [self addSegmentedControl];
    [self setupLeftBackButton];
    [self addDataTableView];
    
    if (self.isIndex) {
        self.navigationItem.title = @"选择指标";
        _isIndexSelected = YES;
        _segmentedControl.selectedSegmentIndex = 0;
        [self getKpiList];
    }else {
        self.navigationItem.title = @"选择城市";
        _segmentedControl.selectedSegmentIndex = 1;
        _isIndexSelected = NO;
        [self getProvinceDataList];
        
    }
}

- (void)getCacheData{
    _selectedKpiCache = [NSMutableDictionary dictionaryWithDictionary:[SelectedKPIDataManager querySelectedKPIData]];
    
    _selectedAreaCache = [NSMutableDictionary dictionaryWithDictionary:[SelectedAreaDataManager querySelectedAreaData]];
    
    NSArray *allKeys = [_selectedAreaCache allKeys];
    for (NSString *areaCode in allKeys) {
        AreaDataModel *dataModel = [_selectedAreaCache objectForKey:areaCode];
        if (dataModel.flag == 1) {
            _selectedPoleCity = dataModel;
            break;
        }
    }
}

- (void)saveCacheData {
    [SelectedKPIDataManager saveSelectedKPIData:_selectedKpiCache];
    [SelectedAreaDataManager saveSelectedAreaData:_selectedAreaCache];
}

- (void)setupLeftBackButton {
    typeof(self) __weak weakSelf = self;
    [self setLeftNavigationBarButtonItemWithImage:@"nav_icon_back" andAction:^{
        [weakSelf saveCacheData];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

}

- (void)getKpiList{
    [WJHUD showOnView:self.view];
    [RequestService getKpiListWithResult:^(BOOL success, id object){
        [WJHUD hideFromView:self.view];
        if (success) {
            KPIModel *kpiModel = (KPIModel *)object;
            if ([kpiModel.code isEqualToString:@"success"]) {
                _kpiModel = kpiModel;
                _maxIndexCnt = kpiModel.maxNum;
                [_dataTableView reloadData];
            }else {
                [WJHUD showText:AlertMessageGetDataFailure onView:self.view];
            }
        }else {
            DLog(@"error = %@", object);
        }
    }];
}

- (void)getProvinceDataList {
    [WJHUD showOnView:self.view];
    [RequestService getAreaListWithAreaId:@"null" result:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            AreaResponseModel *responseModel = (AreaResponseModel*)object;
            if ([responseModel.code isEqualToString:@"success"]) {
                _provinceInfoArr = responseModel.areaDataModelArr;
                _maxAreaCnt = responseModel.maxNum;
                [self initSourceDataOpenState];
                [_dataTableView reloadData];
            }else {
                [WJHUD showText:responseModel.message onView:self.view];
            }
            
        }else {
            DLog(@"error = %@", object);
        }
    }];
}

- (void)getCityDataListWithAreaCode:(NSString *)areaCode {
    [RequestService getAreaListWithAreaId:areaCode result:^(BOOL success, id object) {
        if (success) {
            AreaResponseModel *responseModel = (AreaResponseModel*)object;
            if ([responseModel.code isEqualToString:@"success"]) {
                if (responseModel.areaDataModelArr) {
                    [_cityInfoCache setObject:responseModel.areaDataModelArr forKey:areaCode];
                    [_dataTableView reloadData];
                }
            }else {
                [WJHUD showText:AlertMessageGetDataFailure onView:self.view];
            }
            
        }else {
            DLog(@"error = %@", object);
        }
    }];
}

- (void)addSegmentedControl {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    bgView.backgroundColor = MAIN_COLOR;
    [self.view addSubview:bgView];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"选择指标",@"选择城市", nil]];
    [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = ColorWithRGB(255, 255, 255);
    _segmentedControl.layer.cornerRadius = 14.5;
    _segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    _segmentedControl.layer.borderWidth = 1.0;
    _segmentedControl.layer.frame = CGRectMake(MainScreenWidth/2-80, 0, 160, 30);
    
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.layer.masksToBounds = YES;
    [self.view addSubview:_segmentedControl];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    _isIndexSelected = !_isIndexSelected;
    if (_isIndexSelected) {
        if (!_kpiModel) {
            [self getKpiList];
        }else {
            [_dataTableView reloadData];
        }
    }else {
        if (!_provinceInfoArr) {
            [self getProvinceDataList];
        }else {
            [_dataTableView reloadData];
        }
    }
}

- (void)setupLeftBackBtn {
    typeof(self) __weak weakSelf = self;
    [self setLeftNavigationBarButtonItemWithImage:@"nav_icon_back.png" andAction:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)initSourceDataOpenState{
    _sourceDataOpenState = [[NSMutableArray alloc] init];
    for (int i = 0; i< [_provinceInfoArr count]; i++) {
        [_sourceDataOpenState addObject:[NSNumber numberWithBool:false]];
    }
}

#pragma mark 添加数据显示列表
- (void)addDataTableView {
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, MainScreenWidth, MainScreenHeight-109) style:UITableViewStylePlain];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_dataTableView registerNib:[UINib nibWithNibName:@"IndexAndCityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [_dataTableView registerNib:[UINib nibWithNibName:@"IndexCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"IndexCell"];
    [self.view addSubview:_dataTableView];
}

#pragma mark TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isIndexSelected) {
        NSArray *KPIModelDataArr = _kpiModel.kpiDataModelArr;
        return KPIModelDataArr.count;
    }else {
        NSNumber *number = _sourceDataOpenState[section];
        BOOL state = [number boolValue];
        if (state) {
            AreaDataModel *provinceModel = _provinceInfoArr[section];
            NSArray *cityInfoArr = [_cityInfoCache objectForKey:provinceModel.areaCode];
            return cityInfoArr.count;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (_isIndexSelected){
        cell = [tableView dequeueReusableCellWithIdentifier:@"IndexCell"];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isIndexSelected) {
        return 1;
    }
    else{
        return _provinceInfoArr.count;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(_isIndexSelected){
        return 0;
    }else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_isIndexSelected) {
        return 0;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    typeof(self) __weak weakSelf = self;
    if (_isIndexSelected) {
        IndexCell *showCell = (IndexCell *)cell;
        typeof(showCell) __weak weakCell = showCell;
        NSArray *KPIModelDataArr = _kpiModel.kpiDataModelArr;
        KPIDataModel *dataModel = KPIModelDataArr[indexPath.row];
        showCell.titleLB.text = dataModel.kpiName;
//        showCell.flagBtn.hidden = YES;
//        showCell.canTouchFlagView = NO;
        
        KPIDataModel *selectedKpiModel = [_selectedKpiCache objectForKey:dataModel.kpiCode];
        if (selectedKpiModel) {
            [showCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            showCell.checkBtn.selected = YES;
        }else {
            [showCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
            showCell.checkBtn.selected = NO;
        }
        
        showCell.checkBlock = ^(){
            weakCell.checkBtn.selected = !weakCell.checkBtn.selected;
            if (weakCell.checkBtn.isSelected) {
                if ([weakSelf addSelectedKPI:dataModel]) {
                    [weakCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
                }
                [_dataTableView reloadData];
            }else {
                [weakCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
                [weakSelf deleteSelectedKPI:dataModel];
                [_dataTableView reloadData];
                
            }
        };
        
    }else {
        IndexAndCityCell *showCell = (IndexAndCityCell *)cell;
        typeof(showCell) __weak weakCell = showCell;
//        showCell.flagBtn.hidden = NO;
        showCell.canTouchFlagView = YES;
        AreaDataModel *cityModel = [self getCityAreaModelWithIndexPath:indexPath];
        showCell.titleLB.text = cityModel.areaName;
        if (_selectedPoleCity && [_selectedPoleCity.areaCode isEqualToString:cityModel.areaCode]) {
            [showCell.flagBtn setBackgroundImage:[UIImage imageNamed:@"poleSelected"] forState:UIControlStateNormal];
            showCell.flagBtn.selected = YES;
        }else {
            [showCell.flagBtn setBackgroundImage:[UIImage imageNamed:@"pole"] forState:UIControlStateNormal];
            showCell.flagBtn.selected = NO;
        }
        
        AreaDataModel *selectedCityModel = [_selectedAreaCache objectForKey:cityModel.areaCode];
        if (selectedCityModel) {
            [showCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            showCell.checkBtn.selected = YES;
        }else {
            [showCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
            showCell.checkBtn.selected = NO;
        }
        
        showCell.checkBlock = ^(){
            weakCell.checkBtn.selected = !weakCell.checkBtn.selected;
            if (weakCell.checkBtn.isSelected) {
                if ([weakSelf addSelectedCity:cityModel andPole:NO]) {
                    [weakCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
                }
                [_dataTableView reloadData];
                
            }else {
                [weakCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
                [weakSelf deleteSelectedCity:cityModel andPole:NO];
                [_dataTableView reloadData];
                
            }
        };
        
        showCell.flagBlock = ^(){
            weakCell.flagBtn.selected = !weakCell.flagBtn.selected;
            if (weakCell.flagBtn.isSelected) {
                if ([weakSelf addSelectedCity:[weakSelf getCityAreaModelWithIndexPath:indexPath] andPole:YES]) {
                    [weakCell.flagBtn setBackgroundImage:[UIImage imageNamed:@"poleSelected"] forState:UIControlStateNormal];
                }
                [_dataTableView reloadData];
            }else {
                [weakCell.flagBtn setBackgroundImage:[UIImage imageNamed:@"pole"] forState:UIControlStateNormal];
                [weakSelf deleteSelectedCity:[weakSelf getCityAreaModelWithIndexPath:indexPath] andPole:YES];
                [_dataTableView reloadData];
                
            }
        };

    }

}

- (BOOL)addSelectedCity:(AreaDataModel *)areaModel andPole:(BOOL)pole {
    areaModel.flag = 0;
    
    if (pole && _selectedAreaCache.count == _maxAreaCnt && ![_selectedAreaCache objectForKey:areaModel.areaCode]) {
         [WJHUD showText:@"请在已选区域中选择标杆" onView:self.view];
        return NO;
    }
    
    if (pole && _selectedAreaCache.count <= _maxAreaCnt) {
        if (_selectedPoleCity) {
            _selectedPoleCity.flag = 0;
        }
        _selectedPoleCity = areaModel;
        _selectedPoleCity.flag = 1;
        
        if([_selectedAreaCache objectForKey:_selectedPoleCity.areaCode]) {
             _selectedPoleCity = [_selectedAreaCache objectForKey:_selectedPoleCity.areaCode];
            _selectedPoleCity.flag = 1;
        }
    }
   
    if (_selectedAreaCache.count>= _maxAreaCnt) {
        if (pole) {
            if (![_selectedAreaCache objectForKey:areaModel.areaCode] ) {
                [WJHUD showText:@"请在已选区域中选择标杆" onView:self.view];
            }
        }else {
            [WJHUD showText:[NSString stringWithFormat:@"最多选择%@个区域", [NSNumber numberWithInteger:_maxAreaCnt]] onView:self.view];
        }
        return NO;
    }
    [_selectedAreaCache setObject:areaModel forKey:areaModel.areaCode];
    return YES;
}

- (void)deleteSelectedCity:(AreaDataModel *)areaModel andPole:(BOOL)pole{
    if (pole && [areaModel.areaCode isEqualToString:_selectedPoleCity.areaCode]) {
        _selectedPoleCity.flag = 0;
        _selectedPoleCity = nil;
        return;
    }
//    }else if(pole && ![areaModel.areaCode isEqualToString:_selectedPoleCity.areaCode] && [_selectedAreaCache objectForKey:areaModel.areaCode] ) {
//        _selectedPoleCity.flag = 0;
//        _selectedPoleCity = areaModel;
//        _selectedPoleCity.flag = 1;
//        return;
//    }
    
    if ([areaModel.areaCode isEqualToString:_selectedPoleCity.areaCode] ) {
        _selectedPoleCity.flag = 0;
        _selectedPoleCity = nil;
    }
    
    [_selectedAreaCache removeObjectForKey:areaModel.areaCode];
}

- (BOOL)addSelectedKPI:(KPIDataModel *)kpiModel {
    if (_selectedKpiCache.count>= _maxIndexCnt) {
        [WJHUD showText:[NSString stringWithFormat:@"最多选择%ld个指标", (long)_maxIndexCnt] onView:self.view];
        return NO;
    }
    [_selectedKpiCache setObject:kpiModel forKey:kpiModel.kpiCode];
    return YES;
}

- (void)deleteSelectedKPI:(KPIDataModel *)kpiModel {
    [_selectedKpiCache removeObjectForKey:kpiModel.kpiCode];
}


- (AreaDataModel *)getCityAreaModelWithIndexPath:(NSIndexPath *)indexPath {
    AreaDataModel *provinceModel = _provinceInfoArr[indexPath.section];
    NSArray *cityInfoArr = [_cityInfoCache objectForKey:provinceModel.areaCode];
    AreaDataModel *cityModel = cityInfoArr[indexPath.row];
    return cityModel;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_isIndexSelected){
        return NULL;
    }else {
        static NSString *headerFooterViewIdentify = @"headerFooter";
        KPIAndAreaTableHeader *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterViewIdentify];
        if (!headerFooterView) {
            headerFooterView = [[KPIAndAreaTableHeader alloc] initWithReuseIdentifier:headerFooterViewIdentify];
            headerFooterView.delegate = self;
            headerFooterView.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        headerFooterView.sectionIndex = section;
        AreaDataModel *dataModel = _provinceInfoArr[section];
        headerFooterView.titleLabel.text = [NSString stringWithFormat:@"%@", dataModel.areaName];
        headerFooterView.isOpen = [_sourceDataOpenState[section] boolValue];
        
        if (_selectedPoleCity && [_selectedPoleCity.areaCode isEqualToString:dataModel.areaCode]) {
            [headerFooterView.flagBtn setBackgroundImage:[UIImage imageNamed:@"poleSelected"] forState:UIControlStateNormal];
            headerFooterView.flagBtn.selected = YES;
        }else {
            [headerFooterView.flagBtn setBackgroundImage:[UIImage imageNamed:@"pole"] forState:UIControlStateNormal];
            headerFooterView.flagBtn.selected = NO;
        }
        
        if (dataModel.areaFlag == 1) {
            headerFooterView.indicatorImgView.hidden = YES;
        }else {
            headerFooterView.indicatorImgView.hidden = NO;
        }
        
        
        AreaDataModel *selectedCityModel = [_selectedAreaCache objectForKey:dataModel.areaCode];
        if (selectedCityModel) {
            [headerFooterView.checkBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            headerFooterView.checkBtn.selected = YES;
        }else {
            
            [headerFooterView.checkBtn setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
             headerFooterView.checkBtn.selected = NO;
        }
        
        
        typeof(self) __weak weakSelf = self;
        typeof(headerFooterView) __weak weakCell = headerFooterView;
        headerFooterView.checkBlock = ^(){
            weakCell.checkBtn.selected = !weakCell.checkBtn.selected;
            if (weakCell.checkBtn.isSelected) {
                if ([weakSelf addSelectedCity:dataModel andPole:NO]) {
                    [weakCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
                }
                [_dataTableView reloadData];
            }else {
                [weakCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
                [weakSelf deleteSelectedCity:dataModel andPole:NO];
                [_dataTableView reloadData];
                
            }
        };
        
        headerFooterView.flagBlock = ^(){
            weakCell.flagBtn.selected = !weakCell.flagBtn.selected;
            if (weakCell.flagBtn.isSelected) {
                if ([weakSelf addSelectedCity:dataModel andPole:YES]) {
                    [weakCell.flagBtn setBackgroundImage:[UIImage imageNamed:@"poleSelected"] forState:UIControlStateNormal];
                }
                [_dataTableView reloadData];
            }else {
                [weakCell.flagBtn setBackgroundImage:[UIImage imageNamed:@"pole"] forState:UIControlStateNormal];
                [weakSelf deleteSelectedCity:dataModel andPole:YES];
                [_dataTableView reloadData];
            }
        };
        return headerFooterView;
    }
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
    
    AreaDataModel *provinceModel = _provinceInfoArr[sectionIndex];
    NSArray *cityInfoArr = [_cityInfoCache objectForKey:provinceModel.areaCode];
    if (cityInfoArr) {
        [_dataTableView reloadData];
    }else {
        [self getCityDataListWithAreaCode:provinceModel.areaCode];
    }
}
@end
