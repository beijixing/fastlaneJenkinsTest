//
//  RegisterAgreementViewCtrl.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/22.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "RegisterAgreementViewCtrl.h"
#import "Constant.h"


@interface RegisterAgreementViewCtrl ()

@end

@implementation RegisterAgreementViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBackButton];
    [self showWebView];
}

- (void)showWebView{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app.php?s=/user/agreement.html",AppURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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
