//
//  GeneralProblemsVC.m
//  WoJK
//
//  Created by Megatron on 16/6/20.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "GeneralProblemsVC.h"
#import "RequestService.h"
#import "CommonQuestionCell.h"
#import "ProblemsDetailVC.h"
#import "Macro.h"

@interface GeneralProblemsVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_questionArr;
}
@property (strong, nonatomic) IBOutlet UITableView *commonQuestionTable;

@end

@implementation GeneralProblemsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"常见问题";
    [self setupLeftBackButton];
    
    [self.commonQuestionTable registerNib:[UINib nibWithNibName:@"CommonQuestionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.commonQuestionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getCommonQuestionList];
}

- (void)getCommonQuestionList {
    [RequestService getAppCommonQuestionListWithResult:^(BOOL success, id object) {
        if (success) {
            NSDictionary *appQuestion = [(NSDictionary*)object objectForKey:@"appQuestion"];
            id questionList = [appQuestion objectForKey:@"questionList"];
            if([questionList isKindOfClass:[NSArray class]])
            {
                _questionArr = questionList;
            }else{
                _questionArr = [NSArray arrayWithObjects:questionList, nil];
            }
            
            [self.commonQuestionTable reloadData];
            DLog(@"object = %@", object);
        }else {
        
            DLog(@"object = %@", object);
        }
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _questionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     answer = 22222;
     id = 402882a85570d162015570d28a390001;
     question = 11111;
     updateTime = "2016-06-21";
     updateUser = "管理员";
     */
    CommonQuestionCell *showCell = (CommonQuestionCell*)cell;
    NSDictionary *dataDict = _questionArr[indexPath.row];
    showCell.tittleLb.text = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"question"]];
    
    showCell.timeLb.text = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"updateTime"]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDict = _questionArr[indexPath.row];
    ProblemsDetailVC *detailVc = [[ProblemsDetailVC alloc] init];
    detailVc.questionDict = dataDict;
    [self.navigationController pushViewController:detailVc animated:YES];
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
