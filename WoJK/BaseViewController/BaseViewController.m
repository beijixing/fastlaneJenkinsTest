//
//  BaseViewController.m
//  HD100-Custom
//
//  Created by fosung_mac02 on 15/7/1.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "BaseViewController.h"
#import "ToolBox.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIActivityIndicatorView * indicator;
@property (nonatomic, copy) LeftBarButtonItemBlock leftBarButtonBlock;
@property (nonatomic, copy) RightBarButtonItemBlock rightBarButtonBlock;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
//    self.view.backgroundColor = [UIColor whiteColor];
    self.scaleX = [UIScreen mainScreen].bounds.size.width/320.0;
}

- (void)setupActivityIndicatorView{
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicator.hidesWhenStopped = YES;
    [self.view addSubview:self.indicator];
    
    NSLayoutConstraint * centerX = [NSLayoutConstraint constraintWithItem:self.indicator.superview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.indicator attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem:self.indicator.superview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.indicator attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[centerX,centerY]];
    
    [self.indicator startAnimating];
}

- (void)stopActivityIndicatorView{
    [self.indicator stopAnimating];
}

#pragma mark - 导航栏左(后退)按钮
-(void)setupLeftBackButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.frame = CGRectMake(0, 0, 15, 25);
    [button addTarget:self action:@selector(leftBackButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_icon_back.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_icon_back.png"] forState:UIControlStateHighlighted];
    //    [button sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}


#pragma mark - 左(后退)按钮点击 默认行为 可以在子类中重写此方法实现自定义后退行为
-(void)leftBackButtonTouchUpInside:(UIButton *)sender{
    if ([self isPresentedViewController]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)isPresentedViewController{
    
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count > 1) {
            return NO;
        }
        return self.navigationController.presentingViewController != nil;
    }else{
        return self.presentingViewController != nil;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)hideNavigationBarDividedLine {
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)setupPotraitDisplayView {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)setupLandScapeDisplayView {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)setLeftNavigationBarButtonItemWithImage:(NSString *)imageName andAction:(LeftBarButtonItemBlock)action {
    
    UIButton *leftBtn = [ToolBox createButtonWithFrame:CGRectMake(0, 0, 15, 25) buttonImageName:imageName selector:@selector(leftButtonItemClick) target:self];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.leftBarButtonBlock = action;
}

- (void)leftButtonItemClick {
    if (self.leftBarButtonBlock) {
        self.leftBarButtonBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRightNavigationBarButtonItemWithImage:(NSString *)imageName andAction:(RightBarButtonItemBlock)action {
    
    UIButton *rightBtn = [ToolBox createButtonWithFrame:CGRectMake(0, 0, 24, 24) buttonImageName:imageName selector:@selector(rightButtonItemClick) target:self];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.rightBarButtonBlock = action;
}

- (void)rightButtonItemClick {
    if (self.rightBarButtonBlock) {
        self.rightBarButtonBlock();
    }
}

- (BOOL)shouldAutorotate {
    return NO;
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
