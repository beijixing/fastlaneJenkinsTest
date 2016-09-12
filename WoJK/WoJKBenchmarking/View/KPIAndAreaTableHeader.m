//
//  KPIAndAreaTableHeader.m
//  WoJK
//
//  Created by Megatron on 16/5/12.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "KPIAndAreaTableHeader.h"
#import "UIView+Additions.h"

@implementation KPIAndAreaTableHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:17.0];
        [self.sectionTitleView addSubview:self.checkBtn];
        [self.sectionTitleView addSubview:self.flagBtn];
        [self.sectionTitleView addSubview:self.checkActionView];
        [self.sectionTitleView addSubview:self.flagActionView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(48, 0, self.sectionTitleView.width - 100, self.sectionTitleView.height);
    self.checkBtn.size = CGSizeMake(40, 40);
    self.checkBtn.left = 8;
    self.checkBtn.centerY = self.sectionTitleView.centerY;
    
    self.flagBtn.size = CGSizeMake(25, 25);
    self.flagBtn.right = self.sectionTitleView.width - 60;
    self.flagBtn.centerY = self.sectionTitleView.centerY;
    
    self.checkActionView.frame = CGRectMake(0, 0, self.size.width/3, self.size.height);
    self.flagActionView.frame = CGRectMake(self.size.width/2, 0, self.size.width/3, self.size.height);
}

- (UIButton *)checkBtn {
    if (_checkBtn) {
        return _checkBtn;
    }
    _checkBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_checkBtn setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//    [_checkBtn addTarget:self action:@selector(actionCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_checkBtn setTintColor:[UIColor clearColor]];
    return _checkBtn;
}

- (UIView *)checkActionView {
    if (_checkActionView) {
        return _checkActionView;
    }
    _checkActionView = [[UIView alloc] init];
    _checkActionView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *checkTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionCheck:)];
    [_checkActionView addGestureRecognizer:checkTapGesture];
    return _checkActionView;
}

- (void)actionCheck:(UITapGestureRecognizer *)gesture {
    if (self.checkBlock) {
        self.checkBlock();
    }
}

//- (void)actionCheckBtn:(UIButton *)btn {
//    if (self.checkBlock) {
//        self.checkBlock();
//    }
//}

- (UIButton *)flagBtn {
    if (_flagBtn) {
        return _flagBtn;
    }
    _flagBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_flagBtn setBackgroundImage:[UIImage imageNamed:@"pole"] forState:UIControlStateNormal];
//    [_flagBtn addTarget:self action:@selector(actionFlagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_flagBtn setTintColor:[UIColor clearColor]];
    return _flagBtn;
}

- (UIView *)flagActionView {
    if (_flagActionView) {
        return _flagActionView;
    }
    _flagActionView = [[UIView alloc] init];
    _flagActionView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *checkTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionFlag:)];
    [_flagActionView addGestureRecognizer:checkTapGesture];
    return _flagActionView;
}

- (void)actionFlag:(UITapGestureRecognizer *)gesture {
    if (self.flagBlock) {
        self.flagBlock();
    }
}

//- (void)actionFlagBtn:(UIButton *)btn {
//    if (self.flagBlock) {
//        self.flagBlock();
//    }
//}

@end
