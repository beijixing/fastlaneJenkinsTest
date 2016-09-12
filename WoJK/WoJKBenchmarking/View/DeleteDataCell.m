//
//  DeleteDataCell.m
//  WoJK
//
//  Created by Megatron on 16/5/18.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "DeleteDataCell.h"

@implementation DeleteDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    [self.contentView addGestureRecognizer:tapGesture];

}

- (void)actionTapGesture:(UITapGestureRecognizer*)gesture {
    if (self.tappedBlock) {
        self.tappedBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
