//
//  IncomeInfoView.m
//  WoJK
//
//  Created by Megatron on 16/4/21.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "IncomeInfoView.h"
#import "Macro.h"


@implementation IncomeInfoView
{
    float _scaleX;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _scaleX = [UIScreen mainScreen].bounds.size.width/320.0;
//        [self addSubview:self.bgImage];
        [self addSubview:self.title];
        [self addSubview:self.dataBgView];
        
        [self.dataBgView addSubview:self.income];
        [self.dataBgView addSubview:self.tongbiLb];
        [self.dataBgView addSubview:self.huanbiLb];

//        [self.dataBgView addSubview:self.maskView];
        [self addTapGesture];
    }
    return self;
}

- (void)addTapGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGetureEvent:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapGetureEvent:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(incomeInfoView:tapped:)]) {
        [self.delegate incomeInfoView:self tapped:self.tag];
    }
}

- (void)layoutSubviews {
    self.title.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/4);
    self.title.center = CGPointMake( self.frame.size.width/2, self.frame.size.height/6);
    
    self.dataBgView.frame = CGRectMake(0, CGRectGetMaxY(self.title.frame),  self.frame.size.width,  self.frame.size.height - self.title.frame.size.height);
    
    self.income.frame = CGRectMake(0, 0, self.dataBgView.frame.size.width, self.dataBgView.frame.size.height/2);
    self.income.center = CGPointMake( self.dataBgView.frame.size.width/2, self.dataBgView.frame.size.height/4);
    
   
    if (self.tongbiLb.text.length>0) {
         self.huanbiLb.frame = CGRectMake(0, self.dataBgView.frame.size.height*2.5/5, self.dataBgView.frame.size.width, self.dataBgView.frame.size.height/5);
        
         self.tongbiLb.frame = CGRectMake(0, self.dataBgView.frame.size.height*3.5/5, self.dataBgView.frame.size.width, self.dataBgView.frame.size.height/5);
    }else {
        self.huanbiLb.frame = CGRectMake(0, self.dataBgView.frame.size.height*2.8/5, self.dataBgView.frame.size.width, self.dataBgView.frame.size.height/5);
    
    }
    
   
    
    
//    self.maskView.frame = self.bounds;
//    self.maskView.center = CGPointMake( self.frame.size.width/2, self.frame.size.height/2);
    
//    self.bgImage.frame = self.bounds;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
        _title.font = [UIFont fontWithName:@"Arial" size:11*_scaleX];
    }
    return _title;
}

- (UILabel *)income {
    if (!_income) {
        _income = [[UILabel alloc] init];
        _income.textAlignment = NSTextAlignmentCenter;
        _income.textColor = [UIColor colorWithRed:1.000 green:1.0 blue:1.0 alpha:1.000];
        _income.font = [UIFont fontWithName:@"Arial" size:22*_scaleX];
    }
    return  _income;
}


- (UILabel *)huanbiLb {
    if (!_huanbiLb) {
        _huanbiLb = [[UILabel alloc] init];
        _huanbiLb.textAlignment = NSTextAlignmentCenter;
        _huanbiLb.textColor = [UIColor colorWithRed:0 green:1.0 blue:1.0 alpha:1.000];
        _huanbiLb.font = [UIFont fontWithName:@"Arial" size:10*_scaleX];
    }
    return _huanbiLb;
}

- (UILabel *)tongbiLb {
    if (!_tongbiLb) {
        _tongbiLb = [[UILabel alloc] init];
        _tongbiLb.textAlignment = NSTextAlignmentCenter;
        _tongbiLb.textColor = [UIColor colorWithRed:0 green:1.0 blue:1.0 alpha:1.000];
        _tongbiLb.font = [UIFont fontWithName:@"Arial" size:10*_scaleX];
    }
    return _tongbiLb;
}



- (UIView *)maskView {

    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    return _maskView;
}

- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] init];
    }
    return _bgImage;
}

- (UIView *)dataBgView{
    if (!_dataBgView) {
        _dataBgView = [[UIView alloc] init];
    }
    return _dataBgView;
}

- (void)setLargeFont {
    self.income.font = [UIFont fontWithName:@"Arial" size:18.0];
    self.title.font = [UIFont fontWithName:@"Arial" size:10.0*_scaleX];
    self.tongbiLb.font = [UIFont fontWithName:@"Arial" size:13.0];
    self.huanbiLb.font = [UIFont fontWithName:@"Arial" size:13.0];
}

- (void)setSmallFont {
    self.income.font = [UIFont fontWithName:@"Arial" size:12.0];
    self.title.font = [UIFont fontWithName:@"Arial" size:8.0*_scaleX];
    self.tongbiLb.font = [UIFont fontWithName:@"Arial" size:10.0];
    self.huanbiLb.font = [UIFont fontWithName:@"Arial" size:10.0];
}

- (void)setLabelColorAndBgColor:(BOOL)isSelected {
    if (isSelected) {
        self.income.textColor = [UIColor whiteColor];
        self.title.textColor = MAIN_COLOR;
        self.tongbiLb.textColor = [UIColor whiteColor];
        self.huanbiLb.textColor = [UIColor whiteColor];
        self.dataBgView.backgroundColor = MAIN_COLOR;
    }else {
        self.income.textColor = ColorWithRGB(71, 71, 71);
        self.title.textColor = ColorWithRGB(71, 71, 71);;
        self.tongbiLb.textColor = ColorWithRGB(71, 71, 71);;
        self.huanbiLb.textColor = ColorWithRGB(71, 71, 71);
        self.dataBgView.backgroundColor = [UIColor whiteColor];
    }
}
@end
