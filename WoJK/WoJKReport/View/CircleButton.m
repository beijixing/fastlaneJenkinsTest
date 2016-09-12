//
//  CircleButton.m
//  HiSchool
//
//  Created by ybon on 16/3/8.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "CircleButton.h"
#import "Masonry.h"
#import "UIButton+WebCache.h"
@interface CircleButton()
@property(nonatomic) float scaleX;
@end

@implementation CircleButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.cirCleButton];
        _scaleX = [UIScreen mainScreen].bounds.size.width/320.0;
        
        UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick:)];
        [self addGestureRecognizer:tapGeture];
        [self addSubview:self.titleLabel];
        [self layoutSubviews];
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0].CGColor;
    }
    return self;
}

- (void)buttonClick:(UITapGestureRecognizer *)tapGesture {
    if (self.btnClickBlock) {
        self.btnClickBlock(self.tag, self.titleLabel.text);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.cirCleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40*_scaleX, 40*_scaleX));
//        make.top.mas_equalTo(self.mas_top).offset(0);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-10*_scaleX);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.cirCleButton.mas_bottom);
        make.bottom.mas_equalTo(self).offset(0);
    }];
}

- (ZLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[ZLabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    }
    return _titleLabel;
}

- (UIImageView *)cirCleButton {
    if (!_cirCleButton) {
        _cirCleButton = [[UIImageView alloc] init];
    }
    return _cirCleButton;
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    
//}
@end
