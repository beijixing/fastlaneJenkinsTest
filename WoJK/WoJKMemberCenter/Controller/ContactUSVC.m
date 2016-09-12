//
//  ContactUSVC.m
//  WoJK
//
//  Created by Megatron on 16/5/12.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "ContactUSVC.h"

@interface ContactUSVC ()

@end

@implementation ContactUSVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableString *linkManDesc = [[NSMutableString alloc] initWithString: self.aboutUsDataModel.linkManDesc];
    [linkManDesc replaceOccurrencesOfString:@"\n" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, linkManDesc.length)];
    [linkManDesc replaceOccurrencesOfString:@"\r" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 5)];
//    NSArray *strArr = [linkManDesc componentsSeparatedByString:@"："];
    
//    if (strArr.count>1)
//    {
        self.contactTextView.text = linkManDesc;
//    }
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
