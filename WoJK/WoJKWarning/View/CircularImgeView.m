//
//  CircularImgeView.m
//  WoJK
//
//  Created by Megatron on 16/4/21.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "CircularImgeView.h"

@interface CircularImgeView()
{
    UILabel *_titleLabel;
}
@end

@implementation CircularImgeView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width*2/3, frame.size.height*2/3)];
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:_titleLabel];
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.borderWidth = 2.0;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor andBorderColor:(UIColor *)borderColor andTitleColor:(UIColor *)titleColor {
    self.backgroundColor = backgroundColor;
    self.layer.borderColor = borderColor.CGColor;
    _titleLabel.textColor = titleColor;
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _titleLabel.text = _title;
    }
}
@end
