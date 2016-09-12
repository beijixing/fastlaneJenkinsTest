//
//  SystemMessageVC.m
//  WoJK
//
//  Created by Megatron on 16/5/10.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "SystemMessageVC.h"
#import "MessageDetail.h"
#import "SystemMessageCell.h"
#import "RequestService.h"
#import "SystemMessageModel.h"
#import "WJHUD.h"
#import "Macro.h"

@interface SystemMessageVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_systemMessageArr;
}
@property (strong, nonatomic) IBOutlet UITableView *systemMessageTable;
@end

@implementation SystemMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"系统公告";
    [self setupLeftBackButton];
    [self setupMessageTable];
    [self getSystemMessageList];
}

- (void)viewWillAppear:(BOOL)animated {
    if (_systemMessageArr.count!=0) {
        [self.systemMessageTable reloadData];
    }
}

- (void)getSystemMessageList {
    [WJHUD showOnView:self.view];
    [RequestService getSystemNoticeListWithResult:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            _systemMessageArr = object;
            [self.systemMessageTable reloadData];
        }else {
            DLog(@"error= %@", object);
        }
    }];

}

- (void)setupMessageTable {
    [self.systemMessageTable registerNib:[UINib nibWithNibName:@"SystemMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.systemMessageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _systemMessageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemMessageModel *dataModel = _systemMessageArr[indexPath.row];
    SystemMessageCell *showCell = (SystemMessageCell*)cell;
    showCell.titleLB.text = dataModel.noticeTypeName;
    showCell.contentLB.text = dataModel.title;
    showCell.timeLB.text = [dataModel.sendTime substringToIndex:10];
    showCell.readStatusLabel.text = dataModel.readStatus == 0 ? @"未读" : @"已读";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.hidesBottomBarWhenPushed = YES;
    MessageDetail *messageDetail = [[MessageDetail alloc] init];
    messageDetail.messageModel = _systemMessageArr[indexPath.row];
    [self.navigationController pushViewController:messageDetail animated:YES];
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
