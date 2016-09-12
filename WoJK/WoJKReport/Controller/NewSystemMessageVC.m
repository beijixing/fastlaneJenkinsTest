//
//  NewSystemMessageVC.m
//  WoJK
//
//  Created by Megatron on 16/5/13.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "NewSystemMessageVC.h"

@interface NewSystemMessageVC ()
@property (strong, nonatomic) IBOutlet UILabel *titleLB;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation NewSystemMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLB.text = self.messageModel.title;
    self.contentTextView.text = self.messageModel.content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionClose:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
