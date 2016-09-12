//
//  UIView+CornerRadius.m
//  addCornerRadiusForAllXib
//
//  Created by 黄少华 on 15/12/28.
//  Copyright © 2015年 黄少华. All rights reserved.
//

#import "UIView+CornerRadius.h"
#import <objc/runtime.h>

@implementation UIView (CornerRadius)


- (CGFloat)cornerRadius
{
    return [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue];
}
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius>0;
}


- (CGFloat)borderWidth
{
    return [objc_getAssociatedObject(self, @selector(borderWidth)) floatValue];
}
- (void)setBorderWidth:(CGFloat)borderWidth
{
    if (borderWidth<0) {
        return;
    }
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}


- (UIColor *)borderColor
{
    return objc_getAssociatedObject(self, @selector(borderColor));
}
- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}
@end
