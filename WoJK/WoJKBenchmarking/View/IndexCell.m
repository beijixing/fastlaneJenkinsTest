//
//  IndexCell.m
//  WoJK
//
//  Created by Megatron on 16/6/20.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "IndexCell.h"

@implementation IndexCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *checkTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionCheck:)];
    [self.contentView addGestureRecognizer:checkTapGesture];
}

- (void)actionCheck:(UITapGestureRecognizer *)sender {
    if (self.checkBlock) {
        self.checkBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
