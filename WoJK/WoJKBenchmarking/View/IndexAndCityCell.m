//
//  IndexAndCityCell.m
//  WoJK
//
//  Created by Megatron on 16/5/9.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "IndexAndCityCell.h"

@implementation IndexAndCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *checkTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionCheck:)];
    [self.checkActionView addGestureRecognizer:checkTapGesture];
    
    UITapGestureRecognizer *flagTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionFlag:)];
    [self.flagActionView addGestureRecognizer:flagTapGesture];
    self.canTouchFlagView = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)actionCheck:(UITapGestureRecognizer *)sender {
    if (self.checkBlock) {
        self.checkBlock();
    }
}

- (void)actionFlag:(UITapGestureRecognizer *)sender {
    if (self.flagBlock && self.canTouchFlagView) {
        self.flagBlock();
    }
    
}


@end
