//
//  DeleteAreaAndIndexVC.m
//  WoJK
//
//  Created by Megatron on 16/5/18.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "DeleteAreaAndIndexVC.h"
#import "DeleteDataCell.h"
#import "KPIDataModel.h"
#import "AreaDataModel.h"
#import "SelectedAreaDataManager.h"
#import "SelectedKPIDataManager.h"

@interface DeleteAreaAndIndexVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *deleteDataTable;
@property (strong, nonatomic) NSMutableDictionary *willDeletedData;
@property(nonatomic, strong) NSMutableDictionary *dataDict;
@end

@implementation DeleteAreaAndIndexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择删除的数据";
    self.willDeletedData = [[NSMutableDictionary alloc] init];
    [self setupLeftBackButton];
    [self getCacheData];
    [self setupDataTable];
    typeof(self) __weak weakSelf = self;
    [self setRightNavigationBarButtonItemWithImage:@"navBtnDelete" andAction:^{
        [weakSelf.dataDict removeObjectsForKeys:[weakSelf.willDeletedData allKeys]];
        if (weakSelf.isAreaData) {
            for(NSString *key in [weakSelf.willDeletedData allKeys]){
                [SelectedAreaDataManager deleteAreaDataByCode:key];
            }
            
        }else {
            for(NSString *key in [weakSelf.willDeletedData allKeys]){
                [SelectedKPIDataManager deleteKPIByCode:key];
            }
        }
        [weakSelf.deleteDataTable reloadData];
    }];
}
- (void)getCacheData{
    if (self.isAreaData) {
        self.dataDict = [NSMutableDictionary dictionaryWithDictionary:[SelectedAreaDataManager querySelectedAreaData]];
    }else {
    
       self.dataDict = [NSMutableDictionary dictionaryWithDictionary:[SelectedKPIDataManager querySelectedKPIData]];
    }
}

- (void)setupDataTable {
    self.deleteDataTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.deleteDataTable registerNib:[UINib nibWithNibName:@"DeleteDataCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DeleteDataCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *allKeys = [self.dataDict allKeys];
    return allKeys.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeleteDataCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DeleteDataCell *showCell = (DeleteDataCell *)cell;
    showCell.checkImageView.image = [UIImage imageNamed:@"unselected"];
    NSArray *allKeys = [self.dataDict allKeys];
    if (self.isAreaData) {
        AreaDataModel *areaModel = [self.dataDict objectForKey:allKeys[indexPath.row]];
        showCell.titleLabel.text = areaModel.areaName;
    }else {
        KPIDataModel *kpiModel = [self.dataDict objectForKey:allKeys[indexPath.row]];
        showCell.titleLabel.text = kpiModel.kpiName;
    }
    
    typeof(showCell) __weak weakCell = showCell;
    showCell.tappedBlock = ^(){
        if ([self.willDeletedData objectForKey:allKeys[indexPath.row]]) {
            [self.willDeletedData removeObjectForKey:allKeys[indexPath.row]];
            weakCell.checkImageView.image = [UIImage imageNamed:@"unselected"];
        }else {
            [self.willDeletedData setObject:allKeys[indexPath.row] forKey:allKeys[indexPath.row]];
            weakCell.checkImageView.image = [UIImage imageNamed:@"selected"];
        }
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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
