//
//  TapGestureLabel.h
//  WoJK
//
//  Created by Megatron on 16/5/17.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TapGestureLabel;
@protocol TapGestureLabelDelegate <NSObject>

- (void)labelTapped:(TapGestureLabel *)label;

@end

@interface TapGestureLabel : UILabel
@property(nonatomic, assign) id<TapGestureLabelDelegate> delegate;
- (void)setVerticalLineWithStarPoint:(CGPoint)sPoint lineWidth:(float)width lineColor:(UIColor *)color;
- (void)removeVerticalLine;
@end
