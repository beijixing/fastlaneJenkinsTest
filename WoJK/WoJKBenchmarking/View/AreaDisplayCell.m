//
//  AreaDisplayCell.m
//  WoJK
//
//  Created by Megatron on 16/5/12.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "AreaDisplayCell.h"

@implementation AreaDisplayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)actionDelete:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
