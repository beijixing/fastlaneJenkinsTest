//
//  WarnSettingHeader.m
//  WoJK
//
//  Created by Megatron on 16/5/5.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "WarnSettingHeader.h"

@implementation WarnSettingHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor lightGrayColor];
    }
    
    return _titleLabel;
}
- (void)layoutSubviews {
    self.titleLabel.frame = CGRectMake(15, 0, self.frame.size.width-15, self.frame.size.height);
}
@end
