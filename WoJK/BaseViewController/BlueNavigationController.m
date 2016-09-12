//
//  OrangeNavigationController.m
//  HD100-Custom
//
//  Created by fosung_mac02 on 15/7/2.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "BlueNavigationController.h"
#import "Macro.h"
#import "Colours.h"

@interface BlueNavigationController ()

@end

@implementation BlueNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (AboveiOS7) {
        self.navigationBar.barTintColor = MAIN_COLOR;
    }else{
        self.navigationBar.tintColor = MAIN_COLOR;
    }
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
}

- (BOOL)shouldAutorotate {
    UIViewController *lastVc = [self.viewControllers lastObject];
    return [lastVc shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIViewController *lastVc = [self.viewControllers lastObject];
    return [lastVc supportedInterfaceOrientations];
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
