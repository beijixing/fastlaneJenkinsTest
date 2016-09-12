//
//  WoJKReportVC.h
//  WoJK
//
//  Created by Megatron on 16/4/14.
//  Copyright (c) 2016年 zhilong. All rights reserved.
//

#import "BaseViewController.h"
@class MonitorReportModel;
@class ReportResponseModel;
@interface WoJKReportVC : BaseViewController
{
    UIScrollView *_serviceScrollView;
//    UICollectionView *_collectionView;
    UIScrollView *_kpiScrollView;
    UIScrollView *_layerScrollView;
    NSMutableArray *_serviceScrollViewItemArr;
    float _scaleX;
    NSDate *_curDate;
    NSInteger _displayReportType;//1,报表查看；2，图形报表；3，指标解释
    
    MonitorReportModel *_reportDataModel;
    NSArray *_reportDataList;
    NSDictionary *_showedReportData;
    NSMutableArray *_serviceBtnArr;
    
    
    NSInteger _currDataIndex;
    BOOL      _itemShouldAutoMove;
    
    BOOL _hideNavigationBar;
    ReportResponseModel *_responseModel;
    NSMutableArray *_collectionViewDataArr;
}

@property(nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic, strong) UIButton *leftDateBtn;
@property(nonatomic, strong) UIButton *rightDateBtn;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *serviceDes;

- (void)getChannelInfo;
- (void)getMonitorReportData;
- (void)updateDateLabel;
- (void)addServiceScrollView;
- (void)addOtherServiceCollectionView;
- (void)getImageModelData;
- (void)getChartModelData;
- (void)getIndexExplainModelData;
- (void)initChannelInfo;
@end
