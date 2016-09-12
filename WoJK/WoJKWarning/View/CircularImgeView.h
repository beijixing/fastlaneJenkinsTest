//
//  CircularImgeView.h
//  WoJK
//
//  Created by Megatron on 16/4/21.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularImgeView : UIImageView
@property(nonatomic, copy) NSString *title;
- (void)setBackgroundColor:(UIColor *)backgroundColor andBorderColor:(UIColor *)borderColor andTitleColor:(UIColor *)titleColor;
@end
