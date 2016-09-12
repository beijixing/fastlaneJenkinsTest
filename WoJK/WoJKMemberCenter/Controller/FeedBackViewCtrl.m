//
//  FeedBackViewCtrl.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/14.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "FeedBackViewCtrl.h"
#import "WJTextView.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "Validator.h"
#import "Constant.h"
#import "WXApi.h"
#import "GeneralDataModel.h"

@interface FeedBackViewCtrl ()
@property (strong, nonatomic) IBOutlet WJTextView *textView;

@end

@implementation FeedBackViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBackButton];
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.fontOfPlaceHolder = [UIFont systemFontOfSize:15];
    self.navigationItem.title = @"意见反馈";
}


#pragma mark - 提交
- (IBAction)actionCommit:(UIButton *)sender {
    if ([Validator isSpaceOrEmpty:_textView.text]) {
        [WJHUD showText:AlertMessageNOContent onView:self.view];
        return;
    }
    [WJHUD showOnView:self.view];
    [RequestService feedBackWithContent:_textView.text result:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            GeneralDataModel *model = object;
            if ([model.code isEqualToString:@"success"]) {
                [WJHUD showText:AlertMessageSetDataSuccess onView:self.view completionBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else {
                [WJHUD showText:AlertMessageGetDataFailure onView:self.view];
            }

        }
    }];
}
@end
