//
//  WarnSettingCell.m
//  WoJK
//
//  Created by Megatron on 16/5/4.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "WarnSettingCell.h"

@implementation WarnSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)stateSwitchAction:(UISwitch *)sender {
    if (self.switchAction) {
        self.switchAction(sender.on);
    }
}
@end
