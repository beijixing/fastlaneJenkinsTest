//
//  WoJKReportVC.m
//  WoJK
//
//  Created by Megatron on 16/4/14.
//  Copyright (c) 2016年 zhilong. All rights reserved.
//
#import "WoJKReportVC.h"
#import "Macro.h"
#import "CircleButton.h"
#import "MobileIncomeVC.h"
#import "NSStringAdditions.h"
#import "IncomeInfoView.h"
#import "MobileServiceDevelopVC.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "MonitorReportModel.h"
#import "ReportModuleModel.h"
#import "HomePageDataManager.h"
#import "CommonWebViewVC.h"
#import "ReportResponseModel.h"
#import "ReportCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "ScrollMessageView.h"
#import "SystemMessageModel.h"
#import "NewSystemMessageModel.h"
#import "UserTool.h"
#import "TapGestureLabel.h"
#import "PDFDisplayVC.h"
#import "MessageDetail.h"
#import "DeviceModel.h"
#import "ZDGZZBWebVC.h"
#import "JKYBWebVC.h"
#import "CFCoverFlowView.h"
#define ServiceCollectionViewTag 1000
#define ServiceScrollViewTag 1001

@interface WoJKReportVC ()<UIScrollViewDelegate,  TapGestureLabelDelegate, ScrollMessageViewDelegate, CFCoverFlowViewDelegate>
{
    UIView *_configModulesView;
    NSMutableArray *_kpiItemsArr;
    NewSystemMessageModel *_messageModel;
    ScrollMessageView *_messageView;
    BOOL _hasNotice;
    UIView *_chartTabBgView;
    UIImageView *_chartTabBtnBG;
    TapGestureLabel *_leftTappedLabel;
    TapGestureLabel *_middleTappedLabel;
    TapGestureLabel *_rightTappedLabel;
    UIView *_statusBarView;
    UIPageControl *_pageControl;
    float _itemLayoutRatio;
    float _importantKpiItemHeight;
    float _pageWidth;
    float _itemMinScale;
    float _dateLabelTopPadding;
    
    BOOL _showCellAnim;
    BOOL _showNoticeDetail;
    
    CFCoverFlowView *_importantKpiScrollView;
    float _scvHeight;
    
    NSMutableArray *_tapGestureLabels;
    NSString *_currentTabName;
}
@end

@implementation WoJKReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _scaleX = MainScreenWidth/320.0;
    _itemLayoutRatio = 1.1;
//    self.navigationItem.title = @"沃监控";
    self.view.backgroundColor = [UIColor whiteColor];
    _collectionViewDataArr = [[NSMutableArray alloc] init];
    [self getSystemNotice];
    [self hideNavigationBarDividedLine];
    _curDate = [NSDate date];
//    _showImageData = NO;
    _showCellAnim = NO;
    
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    _statusBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_statusBarView];
    
    
//    if (AboveiOS7) {
//        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    }else{
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    }
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,nil]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _showNoticeDetail = NO;
//    if (_hasNotice) {
//        [self addScrollMessageView];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
//        self.navigationController.navigationBar.translucent = NO;
//    }else {
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//    }
    
//    if (AboveiOS7) {
//        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    }else{
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    }
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,nil]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!_showNoticeDetail) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)getMonitorReportData {
 
}

- (void)getChannelInfo {
 
}

- (void)initChannelInfo {
    NSString *selectedValue;
     if ([[UserTool sharedUser].currentModuleId isEqualToString:[[UserTool sharedUser] getTabbarModuleIdWithIndex:0]]) {//日报
         selectedValue = [UserTool sharedUser].defaultDaySelection;
     }else {
         selectedValue = [UserTool sharedUser].defaultMonthSelection;
     }
    if (!selectedValue) {
        selectedValue = @"1";
    }
    NSSet *filterSet = [self generateViewTypeFilterWith:_responseModel selectedTabId:[selectedValue integerValue]];
    [self getReportModuleDataWithConditions:filterSet];
    
    [self addChartTabButton];
    //    [self addServiceDesLabel];
    if (_hasNotice) {
        [self addScrollMessageView];
    }
}

- (void)getSystemNotice {
    [RequestService getSystemNoticeWithResult:^(BOOL success, id object) {
        if (success) {
            _messageModel = object;
            if ([_messageModel.code isEqualToString:@"success"] && _messageModel.content.length>0 ) {
                _hasNotice = YES;
            }else {
                _hasNotice = NO;
            }
        }else {
            DLog(@"error = %@", object);
              _hasNotice = NO;
        }
        
        [self addLayerScrollView];
    }];
}

- (void)addLayerScrollView{
//    _hasNotice = YES;
//    if (_hasNotice) {
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//        self.navigationController.navigationBar.translucent = NO;
//    }else {
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//    }
    _itemLayoutRatio = _hasNotice ? 1.3 : 1.1;
    if ([[DeviceModel getCurrentDeviceModel] isEqualToString:@"iPhone4"] || [[DeviceModel getCurrentDeviceModel] isEqualToString:@"iPhone4S"]) {
        _itemLayoutRatio = 1.5;
    }
    DLog(@"Model = %@", [DeviceModel getCurrentDeviceModel]);
//    float scrollviewSizeHeight = _hasNotice ? MainScreenHeight - 64 - 49: MainScreenHeight - 49 -20 ;
//    float contentSizeHeight = _hasNotice ? 568-64-49 : 568-49;
    _layerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 49)];
    _layerScrollView.contentSize = CGSizeMake(MainScreenWidth, 568-64-49);
    _layerScrollView.backgroundColor = ColorWithRGB(240, 240, 240);
    [self.view addSubview:_layerScrollView];
    if (MainScreenHeight >= 568.0) {
        _layerScrollView.scrollEnabled = NO;
    }
    _dateLabelTopPadding = 5;
//    UIView *collectionBgView = [UIView ];
    [self addGradiantBgImage];
    [self addLeftDateBtn];
    [self addRightDateBtn];
    [self addDateLabel];
}

- (void)addGradiantBgImage {
    //0, MainScreenHeight-MainScreenWidth/itemLayoutRatio-64-49 - 30*_scaleX
    UIImageView *headerBgimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-MainScreenWidth/_itemLayoutRatio-64-49 - 30*_scaleX)];
    headerBgimage.image = [UIImage imageNamed:@"reportHeadBg.jpg"];
    headerBgimage.backgroundColor = [UIColor redColor];
//    [_layerScrollView addSubview:headerBgimage];
}

- (void)addScrollMessageView {
    _messageView = [[ScrollMessageView alloc] initWithFrame:CGRectMake(0,CGRectGetMinY(_chartTabBgView.frame) - 45*_scaleX, MainScreenWidth, 40*_scaleX)];
    _messageView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    _messageView.messageTypeName = _messageModel.noticeTypeName;
    _messageView.content = _messageModel.content;
//    _messageView.layer.cornerRadius = 4;
    _messageView.delegate = self;
    [_layerScrollView addSubview:_messageView];
//    self.navigationItem.titleView = _messageView;
//    [self.view addSubview:_messageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_messageView startTimer];
    });
}

- (void)scrollMessageView:(ScrollMessageView *)messageView clicked:(BOOL)click {
    MessageDetail *detail = [[MessageDetail alloc] init];
    SystemMessageModel *messageModel = [[SystemMessageModel alloc] init];
    messageModel.content = _messageModel.content;
    messageModel.contentId = _messageModel.contentId;
    messageModel.noticeTypeName = _messageModel.noticeTypeName;
    messageModel.readStatus = 0;
    messageModel.noticeType = _messageModel.noticeType;
    messageModel.sendTime = @"";
    messageModel.title = _messageModel.title;
    messageModel.sendUserName = @"";
    detail.messageModel = messageModel;
    _showNoticeDetail = YES;
    [self.navigationController  pushViewController:detail animated:YES];
}

- (void)getChartModelData {
    [_collectionViewDataArr removeAllObjects];
    
    if ([[UserTool sharedUser].currentModuleId isEqualToString:[[UserTool sharedUser] getTabbarModuleIdWithIndex:0]]) {//日报
        for (ReportModuleModel *reportModuleModel in _responseModel.reportModuleArr) {
            if (reportModuleModel.report_style == 2 || reportModuleModel.report_style == 3) {
                [_collectionViewDataArr addObject:reportModuleModel];
            }
        }
    }else{
        for (ReportModuleModel *reportModuleModel in _responseModel.reportModuleArr) {
            if (reportModuleModel.report_style == 2 || reportModuleModel.report_style == 3 || reportModuleModel.report_style == 4) {
                [_collectionViewDataArr addObject:reportModuleModel];
            }
        }
    }
}

- (void)getImageModelData {
    [_collectionViewDataArr removeAllObjects];
    for (ReportModuleModel *reportModuleModel in _responseModel.reportModuleArr) {
        if (reportModuleModel.report_style == 1 || reportModuleModel.report_style == 3) {
            [_collectionViewDataArr addObject:reportModuleModel];
        }
    }
}

- (void)getIndexExplainModelData {
    [_collectionViewDataArr removeAllObjects];
    for (ReportModuleModel *reportModuleModel in _responseModel.reportModuleArr) {
        if (reportModuleModel.report_style == 5) {
            [_collectionViewDataArr addObject:reportModuleModel];
        }
    }
}

- (void)getReportModuleDataWithConditions:(NSSet *)conditions {
    [_collectionViewDataArr removeAllObjects];
    for (ReportModuleModel *reportModuleModel in _responseModel.reportModuleArr) {
        if ( [conditions containsObject:[NSNumber numberWithInteger:reportModuleModel.report_style]] ) {
            [_collectionViewDataArr addObject:reportModuleModel];
        }
    }
}

#pragma mark - 左右按钮及日期
- (void)addLeftDateBtn {
    self.leftDateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.leftDateBtn setImage:[UIImage imageNamed:@"report_left"] forState:UIControlStateNormal];
    self.leftDateBtn.frame = CGRectMake(20*_scaleX, _dateLabelTopPadding, 25*_scaleX, 25*_scaleX);
    [self.leftDateBtn setTintColor:[UIColor blackColor]];
    [self.leftDateBtn addTarget:self action:@selector(leftDateBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_layerScrollView addSubview:self.leftDateBtn];
}

- (void)leftDateBtnEvent:(UIButton *)btn {
    if(_reportDataList.count == 0){
        [self.leftDateBtn setTintColor:[UIColor lightGrayColor]];
        [self.rightDateBtn setTintColor:[UIColor blackColor]];
        return;
    }
    if (_currDataIndex < _reportDataList.count) {
        _currDataIndex ++;
        if(_currDataIndex == _reportDataList.count) {
            _currDataIndex = _reportDataList.count-1;
            return;
        }else if(_currDataIndex==_reportDataList.count-1){
            [self.leftDateBtn setTintColor:[UIColor lightGrayColor]];
            [self.rightDateBtn setTintColor:[UIColor blackColor]];
        }else{
            [self.leftDateBtn setTintColor:[UIColor blackColor]];
            [self.rightDateBtn setTintColor:[UIColor blackColor]];
        }
    }
    
    _showedReportData = _reportDataList[_currDataIndex];
    id kpiList = [_showedReportData objectForKey:@"kpiList"];
    [self updateScrollviewItemData:kpiList];
    [self updateDateLabel];
}

-(void)addRightDateBtn {
    self.rightDateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.rightDateBtn setImage:[UIImage imageNamed:@"report_right"] forState:UIControlStateNormal];
    self.rightDateBtn.frame = CGRectMake(MainScreenWidth - 45*_scaleX, _dateLabelTopPadding, 25*_scaleX, 25*_scaleX);
    [self.rightDateBtn setTintColor:[UIColor lightGrayColor]];
    [self.rightDateBtn addTarget:self action:@selector(rightDateBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_layerScrollView addSubview:self.rightDateBtn];
}

- (void)rightDateBtnEvent:(UIButton *)btn {
    if(_reportDataList.count == 0){
        return;
    }
    if (_currDataIndex >= 0) {
        _currDataIndex --;
        if (_currDataIndex < 0) {
            _currDataIndex = 0;
            return;
        }else if(_currDataIndex==0){
            [self.leftDateBtn setTintColor:[UIColor blackColor]];
            [self.rightDateBtn setTintColor:[UIColor lightGrayColor]];
        } else {
            [self.leftDateBtn setTintColor:[UIColor blackColor]];
            [self.rightDateBtn setTintColor:[UIColor blackColor]];
        }
    }
    _showedReportData = _reportDataList[_currDataIndex];
    NSArray *kpiList = [_showedReportData objectForKey:@"kpiList"];
    [self updateScrollviewItemData:kpiList];
    [self updateDateLabel];
}

-(void)addDateLabel {
//    NSDate *date = [NSDate date];
//    NSDateComponents *comps = [[NSCalendar currentCalendar] componentsInTimeZone:[NSTimeZone localTimeZone] fromDate:date];
  
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth-90*_scaleX, 30*_scaleX)];
    self.dateLabel.center = CGPointMake(MainScreenWidth/2, (15+_dateLabelTopPadding/2)*_scaleX);
//    self.dateLabel.text = [NSString stringWithFormat:@"", comps.month, comps.day];
//    self.dateLabel.text = [NSString formatNumberWithComma:@"234342343423"];
    self.dateLabel.font = [UIFont fontWithName:@"Arial" size:14*_scaleX];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.textColor = ColorWithRGB(71, 71, 71);
    [_layerScrollView addSubview:self.dateLabel];
}

- (void)updateDateLabel {
    NSString *areaDes = [NSString stringWithFormat:@"%@%@",_reportDataModel.areaName, _reportDataModel.valueType];
    NSString *showText = [NSString stringWithFormat:@"%@%@", [_showedReportData objectForKey:@"acctDate"], areaDes ];
     self.dateLabel.text = showText;
}

#pragma mark -业务描述
- (void)addServiceDesLabel {
    self.serviceDes = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth/2+45, 3, MainScreenWidth, 30)];
//    self.serviceDes.center = CGPointMake(MainScreenWidth/2, 17.5);
    self.serviceDes.numberOfLines = 2;
    self.serviceDes.font = [UIFont fontWithName:@"Arial" size:13];
    self.serviceDes.textAlignment = NSTextAlignmentLeft;
    self.serviceDes.textColor = [UIColor whiteColor];
//    [_layerScrollView addSubview:self.serviceDes];
    
    if([[UserTool sharedUser].currentModuleId isEqualToString:[[UserTool sharedUser] getTabbarModuleIdWithIndex:1]]){
        self.serviceDes.text = [NSString stringWithFormat:@"%@本年累计", [UserTool sharedUser].area];
    }else {
        self.serviceDes.text = [NSString stringWithFormat:@"%@本月累计", [UserTool sharedUser].area];
    }
}

#pragma mark -业务滚动视图
- (void)addServiceScrollView {
    id tempList = [_showedReportData objectForKey:@"kpiList"];
    NSArray *kpiList;
    if ([tempList isKindOfClass:[NSArray class]]) {
        kpiList = tempList;
    }else if([tempList isKindOfClass:[NSDictionary class]]){
        kpiList = [NSArray arrayWithObjects:tempList, nil];
    }
    
    if (_hasNotice) {
        _scvHeight = CGRectGetMinY(_messageView.frame)- 30*_scaleX;
    }else {
        _scvHeight = CGRectGetMinY(_chartTabBgView.frame) - 30*_scaleX;//MainScreenHeight-MainScreenWidth/_itemLayoutRatio-64-49-60*_scaleX;
    }

    int lastSelectIndex;
    if([[UserTool sharedUser].currentModuleId isEqualToString:[[UserTool sharedUser] getTabbarModuleIdWithIndex:1]]) {
        lastSelectIndex = [[UserTool sharedUser].lastImportantKpiMonthIndex intValue];
    }else {
        lastSelectIndex = [[UserTool sharedUser].lastImportantKpiDayIndex intValue];
    }
    
    if (lastSelectIndex >= kpiList.count) {
        lastSelectIndex = 0;
    }
    
    
    _serviceScrollViewItemArr = [[NSMutableArray alloc] init];
    _importantKpiScrollView = [[CFCoverFlowView alloc] initWithFrame:CGRectMake(0, 25*_scaleX, MainScreenWidth, 2*_scvHeight)];
    _importantKpiScrollView.delegate = self;
    _importantKpiScrollView.pageItemWidth = 130*_scaleX;
    _importantKpiScrollView.pageItemCoverWidth = -25.0*_scaleX;
    _importantKpiScrollView.pageItemHeight = _scvHeight;
    _importantKpiScrollView.pageItemCornerRadius = 0.0;
    NSInteger itemCnt;
    if (kpiList.count<3) {
        itemCnt = kpiList.count * 4;
    }else {
        itemCnt = kpiList.count * 2;
    }
    [_importantKpiScrollView setPageItemsWithImageNames:itemCnt];
    [_layerScrollView addSubview:_importantKpiScrollView];
    [_layerScrollView sendSubviewToBack:_importantKpiScrollView];
    
    if (lastSelectIndex != 0) {
        for (int i=0; i<lastSelectIndex; i++) {
            [_importantKpiScrollView scrollTopageWithIndex:lastSelectIndex];
        }
    }
}

- (void)coverFlowView:(CFCoverFlowView *)coverFlowView addDataView:(UIView *)view atIndex:(NSInteger)index {
    IncomeInfoView *incomeView = [[IncomeInfoView alloc] initWithFrame:view.bounds];
//    incomeView.delegate = self;
    id tempList = [_showedReportData objectForKey:@"kpiList"];
    NSArray *kpiList;
    if ([tempList isKindOfClass:[NSArray class]]) {
        kpiList = tempList;
    }else if([tempList isKindOfClass:[NSDictionary class]]){
        kpiList = [NSArray arrayWithObjects:tempList, nil];
    }
    
    NSDictionary *dataModel = kpiList[index%kpiList.count];
    incomeView.title.text = [NSString stringWithFormat:@"%@(%@)",[dataModel objectForKey:@"kpiName"], [dataModel objectForKey:@"unit"]];
    incomeView.income.text = [NSString stringWithFormat:@"%@", [dataModel objectForKey:@"sumValue"]];
    if([[UserTool sharedUser].currentModuleId isEqualToString:[[UserTool sharedUser] getTabbarModuleIdWithIndex:1]]){
        incomeView.huanbiLb.text = [NSString stringWithFormat:@"环比:%@", [dataModel objectForKey:@"avgRatio"]];
        incomeView.tongbiLb.text = @"";
    }else {
        incomeView.huanbiLb.text = [NSString stringWithFormat:@"环比:%@", [dataModel objectForKey:@"avgRatio"]];
        incomeView.tongbiLb.text = [NSString stringWithFormat:@"同比:%@", [dataModel objectForKey:@"tbRatio"]];
    }
    
    if (index == 0) {
        [incomeView setLabelColorAndBgColor:YES];
        [incomeView setLargeFont];
    }else {
        [incomeView setLabelColorAndBgColor:NO];
        [incomeView setSmallFont];
    }
    [view addSubview:incomeView];
    [_serviceScrollViewItemArr addObject:incomeView];
}

- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didScrollPageItemToIndex:(NSInteger)index {
    NSLog(@"didScrollPageItemToIndex >>> %@", @(index));
    for (int i = 0; i < _serviceScrollViewItemArr.count; i++) {
        IncomeInfoView *incomeView = _serviceScrollViewItemArr[i];
        if (i == index) {
            [incomeView setLargeFont];
            [incomeView setLabelColorAndBgColor:YES];
        }else {
            [incomeView setSmallFont];
            [incomeView setLabelColorAndBgColor:NO];
        }
    }
    
    id tempList = [_showedReportData objectForKey:@"kpiList"];
    NSArray *kpiList;
    if ([tempList isKindOfClass:[NSArray class]]) {
        kpiList = tempList;
    }else if([tempList isKindOfClass:[NSDictionary class]]){
        kpiList = [NSArray arrayWithObjects:tempList, nil];
    }
    if (kpiList.count > 0) {
         NSInteger seledtedIdx = index % kpiList.count;
        
        if([[UserTool sharedUser].currentModuleId isEqualToString:[[UserTool sharedUser] getTabbarModuleIdWithIndex:1]]) {
            [UserTool sharedUser].lastImportantKpiMonthIndex = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:seledtedIdx]];
        }else {
            [UserTool sharedUser].lastImportantKpiDayIndex = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:seledtedIdx]];
        }
    }
}

- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didSelectPageItemAtIndex:(NSInteger)index {
    NSLog(@"didSelectPageItemAtIndex >>> %@", @(index));
    
    id tempList = [_showedReportData objectForKey:@"kpiList"];
    NSArray *kpiList;
    if ([tempList isKindOfClass:[NSArray class]]) {
        kpiList = tempList;
    }else if([tempList isKindOfClass:[NSDictionary class]]){
        kpiList = [NSArray arrayWithObjects:tempList, nil];
    }
    
    NSDictionary *kpiDict = kpiList[index%kpiList.count];
    ZDGZZBWebVC *zdzbWebVc = [[ZDGZZBWebVC alloc] init];
    NSMutableString *reportFileName = [[NSMutableString alloc] initWithString:[_reportDataModel.reportUrl lastPathComponent]];
    [reportFileName replaceOccurrencesOfString:@".html" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, reportFileName.length)];
    zdzbWebVc.reportFileName = reportFileName;
    zdzbWebVc.dataDict = kpiDict;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zdzbWebVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

- (void)updateScrollviewItemData:(id)reportData {
    NSMutableArray *exchangedArr;
    if ([reportData isKindOfClass:[NSArray class]]) {
        exchangedArr = [NSMutableArray arrayWithArray:reportData];
    }else if ([reportData isKindOfClass:[NSDictionary class]]){
        exchangedArr = [NSMutableArray arrayWithObjects:reportData, nil];
    }
    
    for (int i = 0; i < _serviceScrollViewItemArr.count; i++) {
        IncomeInfoView *incomeView = _serviceScrollViewItemArr[i];
        NSDictionary *dataModel = exchangedArr[i%exchangedArr.count];
        incomeView.title.text = [NSString stringWithFormat:@"%@(%@)",[dataModel objectForKey:@"kpiName"], [dataModel objectForKey:@"unit"]];
        incomeView.income.text = [NSString stringWithFormat:@"%@", [dataModel objectForKey:@"sumValue"]];
        if([[UserTool sharedUser].currentModuleId isEqualToString:[[UserTool sharedUser] getTabbarModuleIdWithIndex:1]]){
            incomeView.huanbiLb.text = [NSString stringWithFormat:@"环比:%@", [dataModel objectForKey:@"avgRatio"]];
            incomeView.tongbiLb.text = @"";
        }else {
            incomeView.huanbiLb.text = [NSString stringWithFormat:@"环比:%@", [dataModel objectForKey:@"avgRatio"]];
            incomeView.tongbiLb.text = [NSString stringWithFormat:@"同比:%@", [dataModel objectForKey:@"tbRatio"]];
        }
    
        incomeView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [UIView animateWithDuration:0.2 animations:^{
            incomeView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
}

#pragma mark -图表切换标签
- (void)addChartTabButton {
    NSString *selectedValue;
    if ([[UserTool sharedUser].currentModuleId isEqualToString:ModuleDailyReport]) {
        selectedValue = [UserTool sharedUser].defaultDaySelection;
    }else {
        selectedValue = [UserTool sharedUser].defaultMonthSelection;
    }
    
    _chartTabBgView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight-MainScreenWidth/_itemLayoutRatio-64-49 - 35*_scaleX, MainScreenWidth, MainScreenHeight-175*_scaleX)];
    _chartTabBgView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [_layerScrollView addSubview:_chartTabBgView];
    
    UIScrollView *tmpScv = [[UIScrollView alloc] initWithFrame:_chartTabBgView.bounds];
    tmpScv.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    float fwidth =  _chartTabBgView.frame.size.width/3;
    NSArray *tabList = _responseModel.tabList;
    tmpScv.contentSize = CGSizeMake(fwidth*tabList.count, _chartTabBgView.frame.size.height);
    _tapGestureLabels = [[NSMutableArray alloc] init];
    
    UIColor *txtColor = [UIColor blackColor];
    UIColor *bgColor = [UIColor clearColor];
    BOOL yes = NO;
    for (int i = 1; i<=tabList.count; i++) {
        NSDictionary *dataDict = tabList[i-1];
        
        if ([selectedValue integerValue] == i) {
            txtColor = MAIN_COLOR;
            bgColor = [UIColor whiteColor];
            yes = NO;
        }else {
            txtColor = [UIColor blackColor];
            bgColor = [UIColor clearColor];
            if (i == [selectedValue integerValue] + 1) {
                 yes = NO;
            }else if (i >= [selectedValue integerValue]+2 || ((i>1) && ([selectedValue integerValue]>i)) ) {
                 yes = YES;
            }
        }
        
        TapGestureLabel *label = [self createTappedLabelWithPosX:(i-1)*fwidth text:[dataDict objectForKey:@"tabName"] textColor:txtColor backgroundColor:bgColor   addVerticalLine:yes];
        label.tag = i;
        [tmpScv addSubview:label];
        [_tapGestureLabels addObject:label];
    }
    [_chartTabBgView addSubview:tmpScv];
}

- (TapGestureLabel *)createTappedLabelWithPosX:(float)posX text:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor addVerticalLine:(BOOL)yes{
    TapGestureLabel *tapLabel = [[TapGestureLabel alloc] initWithFrame:CGRectMake(posX, 0, _chartTabBgView.frame.size.width/3, 35*_scaleX)];
    tapLabel.userInteractionEnabled = YES;
    tapLabel.text = text;
    tapLabel.textColor = textColor;
    bgColor ? tapLabel.backgroundColor = bgColor : 0;
    tapLabel.delegate = self;
    yes ? [tapLabel setVerticalLineWithStarPoint:CGPointMake(0, 5*_scaleX) lineWidth:0.5 lineColor:[UIColor grayColor]] : 0;
    return tapLabel;
}

- (void)labelTapped:(TapGestureLabel *)label {
    NSString *selectedVal;
    
    for (TapGestureLabel *tapLabel in _tapGestureLabels) {
        if (tapLabel.tag == label.tag) {
            tapLabel.textColor = MAIN_COLOR;
            tapLabel.backgroundColor = [UIColor whiteColor];
            [tapLabel removeVerticalLine];
        }else {
            tapLabel.textColor = [UIColor blackColor];
            tapLabel.backgroundColor = [UIColor clearColor];
            if (tapLabel.tag == label.tag + 1) {
                [tapLabel removeVerticalLine];
            }else if (tapLabel.tag >= label.tag+2 || ((tapLabel.tag>1) && (label.tag>tapLabel.tag)) ) {
                [tapLabel setVerticalLineWithStarPoint:CGPointMake(0, 5*_scaleX) lineWidth:0.5 lineColor:[UIColor grayColor]];
            }
        }
        selectedVal = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:label.tag]];
    }
    
    NSSet *filterSet = [self generateViewTypeFilterWith:_responseModel selectedTabId:label.tag];
    [self getReportModuleDataWithConditions:filterSet];
    
    _showCellAnim = YES;
    //指标不够一屏显示的隐藏分页指示控件
    _pageControl.numberOfPages = ceilf(_collectionViewDataArr.count / 9.0f);
    if (_collectionViewDataArr.count <= 9) {
        _pageControl.hidden = YES;
    }else {
        _pageControl.hidden = NO;
    }
    //更新指标显示
    [self updateKpiScrollItemData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[UserTool sharedUser].currentModuleId isEqualToString:[[UserTool sharedUser] getTabbarModuleIdWithIndex:0]]) {
            [UserTool sharedUser].defaultDaySelection = selectedVal;
        }else {
            [UserTool sharedUser].defaultMonthSelection = selectedVal;
        }
    });
}
- (NSSet *)generateViewTypeFilterWith:(ReportResponseModel *)responseModel selectedTabId:(NSInteger)idx {
    NSArray *tabList = responseModel.tabList;
    NSDictionary *dict = tabList ? (NSDictionary*)tabList[idx-1] : nil;
    NSString *viewTypeStr = [dict objectForKey:@"viewType"];
    _displayReportType = [[dict objectForKey:@"visitType"] integerValue];
    _currentTabName = [dict objectForKey:@"tabName"];
    NSArray *viewTypeComponents;
    if ([viewTypeStr isKindOfClass:[NSString class]]) {
        viewTypeComponents = [viewTypeStr componentsSeparatedByString:@","];
    }else {
        viewTypeComponents = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", viewTypeStr], nil];
    }
    NSMutableSet *filterSet = [[NSMutableSet alloc] init];
    for (NSString *str in viewTypeComponents) {
        [filterSet addObject:[NSNumber numberWithInteger:[str integerValue]]];
    }
    return filterSet;
}

#pragma mark -其他业务
- (void)addOtherServiceCollectionView {
//    
    NSLog(@"_itemLayoutRatio = %f", _itemLayoutRatio);
    NSLog(@"MainScreenWidth/_itemLayoutRatio = %f", MainScreenWidth/_itemLayoutRatio);
    
    _kpiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MainScreenHeight-MainScreenWidth/_itemLayoutRatio-64-49, MainScreenWidth, MainScreenWidth/_itemLayoutRatio)];
    _kpiScrollView.delegate = self;
    _kpiScrollView.tag = ServiceCollectionViewTag;
    _kpiScrollView.backgroundColor = [UIColor whiteColor];
    _kpiScrollView.showsHorizontalScrollIndicator = NO;
    _kpiScrollView.pagingEnabled = YES;
    _kpiScrollView.contentOffset = CGPointMake(0, 0);
    _kpiItemsArr = [[NSMutableArray alloc] init];
    [self.view addSubview:_kpiScrollView];
    [self updateKpiScrollItemData];
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(MainScreenWidth/2-100*_scaleX, MainScreenHeight-MainScreenWidth/_itemLayoutRatio-64-49, 200*_scaleX, 20)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.currentPageIndicatorTintColor = MAIN_COLOR ;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPage = 0;
//    _pageControl.userInteractionEnabled = NO;
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = ceilf(_collectionViewDataArr.count / 9.0f);
    if (_collectionViewDataArr.count <= 9) {
        _pageControl.hidden = YES;
    }
}

- (void)updateKpiScrollItemData {
    for (UIView *view in _kpiItemsArr) {
        [view removeFromSuperview];
    }
    [_kpiItemsArr removeAllObjects];
    
    float contentWidth = MainScreenWidth * ceilf(_collectionViewDataArr.count/9.0);
    _kpiScrollView.contentSize = CGSizeMake(contentWidth, 0);
    float itemWidth = (MainScreenWidth-0)/3;
    float space = 0.0;
    
    for (int i = 0; i<_collectionViewDataArr.count; i++) {
        
        float posX = MainScreenWidth*floor(i/9.0) + i%3*(itemWidth + space);
        float posY = i%9/3*(itemWidth + space)/_itemLayoutRatio;
        
        CircleButton *kpiItem = [[CircleButton alloc] initWithFrame:CGRectMake(posX, posY, itemWidth,itemWidth/_itemLayoutRatio)];
        kpiItem.backgroundColor = [UIColor whiteColor];
        //       incomeView.delegate = self;
        ReportModuleModel *reportModuleModel = _collectionViewDataArr[i];
        kpiItem.tag = i;
        kpiItem.titleLabel.text = reportModuleModel.moduleName;
        
        NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:reportModuleModel.moduleName];
        [mutableStr replaceOccurrencesOfString:@"\\n" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutableStr.length)];
        kpiItem.titleLabel.text = mutableStr;//@"移动业\n务发展报告高嘎嘎嘎个";//
        kpiItem.titleLabel.verticalAlignment = VerticalAlignmentTop;
        
        if(!reportModuleModel.pictureURL || [reportModuleModel.pictureURL isEqualToString:@""]) {
            kpiItem.cirCleButton.image = [UIImage imageNamed:@"im_2"];
        }else {
            [kpiItem.cirCleButton sd_setImageWithURL:[NSURL URLWithString:reportModuleModel.pictureURL] placeholderImage:[UIImage imageNamed:@"im_2"]];
        }
        
        //showCell.alpha = 0;
        if (_showCellAnim) {
            kpiItem.transform = CGAffineTransformMakeScale(0, 0);
            float animTime = rand()%200 *0.005;
            //DLog(@"animTime********* = %f", animTime);
            
            [UIView animateWithDuration:animTime animations:^{
                kpiItem.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                kpiItem.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }
        
        typeof(self) __weak weakSelf = self;
        kpiItem.btnClickBlock = ^(NSInteger tag, NSString *title){
            [weakSelf selectedKpiItemWithIndex:tag];
        };
        
        [_kpiScrollView addSubview:kpiItem];
        [_kpiItemsArr addObject:kpiItem];
    }
}

- (void)selectedKpiItemWithIndex:(NSInteger)index {
    ReportModuleModel *dataModel = _collectionViewDataArr[index];
    [self sendAccessLog:dataModel];
    if ([dataModel.reportUrl containsString:@"viewer.html"]) {
        [self openPdfFileWithDataModel:dataModel];
    }else if (_displayReportType == 1) {
        //H5图形报表
        [self openCommonWebPage:dataModel];
    }else if(_displayReportType == 2){
        //MSTR报表
        [self openOtherAppWithUrlstr:dataModel.moduleURL];
    }else {
        NSLog(@"error visitType = %@",  [NSNumber numberWithInteger:_displayReportType]);
    }
}

- (void)openCommonWebPage:(ReportModuleModel *)dataModel {
    CommonWebViewVC *commonWebViewVC = [[CommonWebViewVC alloc] init];
    commonWebViewVC.dataModel = dataModel;
    NSMutableString *reportFileName = [[NSMutableString alloc] initWithString:[dataModel.reportUrl lastPathComponent]];
    
    [reportFileName replaceOccurrencesOfString:@".html" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, reportFileName.length)];
    NSInteger location = [reportFileName rangeOfString:@"?"].location;
    if (location != NSNotFound) {
        reportFileName = [NSMutableString stringWithString:[reportFileName substringToIndex:location]];
    }
    commonWebViewVC.reportFileName = reportFileName;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commonWebViewVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)openPdfFileWithDataModel:(ReportModuleModel *)dataModel {
    PDFDisplayVC *pdfVc = [[PDFDisplayVC alloc] init];
    pdfVc.dataModel = dataModel;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pdfVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)sendAccessLog:(ReportModuleModel *)dataModel {
    [RequestService sendRecordAccessLogWithEquipModel:[DeviceModel getCurrentDeviceModel] andModuleId:dataModel.moduleId andInterfaceName:[NSString stringWithFormat:@"%@", _currentTabName]];
}

- (void)openOtherAppWithUrlstr:(NSString *)url {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else {
        DLog(@"安装app");
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _kpiScrollView) {
        _pageControl.currentPage = fabs(floor(_kpiScrollView.contentOffset.x/MainScreenWidth));
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
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
