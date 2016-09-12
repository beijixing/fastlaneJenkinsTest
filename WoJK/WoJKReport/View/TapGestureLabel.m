//
//  TapGestureLabel.m
//  WoJK
//
//  Created by Megatron on 16/5/17.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "TapGestureLabel.h"
@interface TapGestureLabel ()
@property(nonatomic, strong)CAShapeLayer *pathLayer;
@end

@implementation TapGestureLabel
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont fontWithName:@"Arial" size:14.0];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapped:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)actionTapped:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(labelTapped:)]) {
        [self.delegate labelTapped:self];
    }
}

- (void)setVerticalLineWithStarPoint:(CGPoint)sPoint lineWidth:(float)width lineColor:(UIColor *)color {
    if (self.pathLayer) {
        return;
    }
    UIBezierPath *beziPath = [UIBezierPath bezierPath];
    //create a path
    [beziPath moveToPoint:sPoint];
    [beziPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
    //draw the path using a CAShapeLayer
    self.pathLayer = [CAShapeLayer layer];
    self.pathLayer.path = beziPath.CGPath;
    self.pathLayer.fillColor = color.CGColor;
    self.pathLayer.strokeColor = color.CGColor;
    self.pathLayer.lineWidth = width;
    [self.layer addSublayer:self.pathLayer];
}

- (void)removeVerticalLine {
    if (self.pathLayer) {
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
    }
}
@end
