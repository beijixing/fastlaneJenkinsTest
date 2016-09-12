//
//  PullDownMenu.m
//  iOSDevTecKit
//
//  Created by ybon on 16/1/18.
//  Copyright © 2016年 郑光龙. All rights reserved.
//

#import "PullDownMenu.h"
#import "Macro.h"
@interface PullDownMenu() <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_dataTable;
    UIView *_tableHeader;
    UILabel *_titleLabel;
    UIImageView *_indicatorImageView;
    NSMutableArray *_dataSourceChache;
}
@end

@implementation PullDownMenu
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createControls];        
    }
    return self;
}

- (void)setIndicatorImageName:(NSString *)indicatorImageName {
    if (_indicatorImageName != indicatorImageName) {
        _indicatorImageName = indicatorImageName;
        _indicatorImageView.image = [UIImage imageNamed:indicatorImageName];
    }
}

- (void)setShowList:(BOOL)showList {
    if (_showList != showList) {
        _showList = showList;
        if (_showList) {
            self.frame = self.showListFrame;
//            _indicatorImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        }
        else {
            self.frame = self.hideListFrame;
//            _indicatorImageView.transform = CGAffineTransformMakeRotation(0);
        }
    }
}

- (void)createControls {
    _dataSourceChache = [[NSMutableArray alloc] init];
    _dataTable = [[UITableView alloc] initWithFrame:CGRectZero];
    _dataTable.delegate = self;
    _dataTable.dataSource = self;
    _dataTable.bounces = NO;
    _tableHeader = [[UIView alloc] initWithFrame:CGRectZero];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _indicatorImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_tableHeader addSubview:_titleLabel];
    [_tableHeader addSubview:_indicatorImageView];
    [_tableHeader addGestureRecognizer:tapGesture];
//  _indicatorImageView.image = [UIImage imageNamed:@"rightArrow"];
    
    [self addSubview:_dataTable];
    _tableHeader.backgroundColor = [UIColor colorWithRed:248/255.0 green:202/255.0 blue:192/255.0 alpha:1.0];
    _dataTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundColor = [UIColor clearColor];
    _dataTable.backgroundColor = [UIColor clearColor];
    _dataTable.bouncesZoom = NO;
}

- (void)tapGesture:(UIGestureRecognizer *)gesture {
    self.showList = !self.showList;
    if (self.showList) {
        self.frame = self.showListFrame;
//        _indicatorImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        if (self.showListViewEvent ) {
            self.showListViewEvent();
        }
    }
    else {
        self.frame = self.hideListFrame;
//        _indicatorImageView.transform = CGAffineTransformMakeRotation(0);
        if (self.hideListViewEvent) {
            self.hideListViewEvent();
        }
    }
    
//    int i;
//    for (i = 0; i  < self.dataSource.count; i++) {
//        if ([self.dataSource[i] isEqualToString:_titleLabel.text]) {
//            break;
//        }
//    }
    [_dataSourceChache removeAllObjects];
    [_dataSourceChache addObjectsFromArray:self.dataSource];
    DLog(@"before remove =  %@", _dataSourceChache);
    [_dataSourceChache removeObject:_titleLabel.text];
    DLog(@"after remove =  %@", _dataSourceChache);
    [_dataTable reloadData];
}

- (void)setDefaultDataId:(NSInteger)defaultDataId {
    _titleLabel.text = [NSString stringWithFormat:@"%@", self.dataSource[defaultDataId]];
    [_dataTable reloadData];
}

- (void)layoutSubviews {
    _dataTable.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _tableHeader.frame = CGRectMake(0, 0, self.frame.size.width, self.hideListFrame.size.height);
    _indicatorImageView.frame =  CGRectMake(self.frame.size.width - 30, (self.hideListFrame.size.height-25)/2 , 25, 25);
    _titleLabel.frame = CGRectMake(15, 0, CGRectGetMinX(_indicatorImageView.frame), self.hideListFrame.size.height);
    _indicatorImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
}

#pragma mark UITableView Delegate Methods
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.backgroundColor = [UIColor colorWithRed:248/255.0 green:202/255.0 blue:192/255.0 alpha:1.0];
    return cell;
}

//为cell赋值数据
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _dataSourceChache[indexPath.row]];
}

//tableview cell 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.showList) {
        return _dataSourceChache.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.hideListFrame.size.height;
}

//返回tableview头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _tableHeader;
}

//选择某一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _titleLabel.text = [NSString stringWithFormat:@"%@", _dataSourceChache[indexPath.row]];
    if (self.getSelectedDataIdx) {
        int i;
        for (i = 0; i  < self.dataSource.count; i++) {
            if ([self.dataSource[i] isEqualToString:_dataSourceChache[indexPath.row]]) {
                break;
            }
        }
        self.getSelectedDataIdx(i, _titleLabel.text);
    }
    self.showList = NO;
    _indicatorImageView.transform = CGAffineTransformMakeRotation(0);
    [_dataTable reloadData];
}

@end
