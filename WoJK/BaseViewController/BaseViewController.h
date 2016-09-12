//
//  BaseViewController.h
//  HD100-Custom
//
//  Created by fosung_mac02 on 15/7/1.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LeftBarButtonItemBlock)(void);
typedef void (^RightBarButtonItemBlock)(void);

@interface BaseViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView * scrollView;
@property(nonatomic) float scaleX;
-(void)setupLeftBackButton;
-(void)leftBackButtonTouchUpInside:(UIButton *)sender;

- (void)setupActivityIndicatorView;
- (void)stopActivityIndicatorView;

- (void)hideNavigationBarDividedLine;

- (void)setupPotraitDisplayView;
- (void)setupLandScapeDisplayView;

- (void)setLeftNavigationBarButtonItemWithImage:(NSString *)imageName andAction:(LeftBarButtonItemBlock)action;

- (void)setRightNavigationBarButtonItemWithImage:(NSString *)imageName andAction:(RightBarButtonItemBlock)action;

@end
