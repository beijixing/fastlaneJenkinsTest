//
//  DisplayAreaHeader.m
//  WoJK
//
//  Created by Megatron on 16/5/18.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "DisplayAreaHeader.h"
#import "UIView+Additions.h"
#import "Macro.h"
@interface DisplayAreaHeader()
@property(nonatomic, strong) UIButton *deleteBtn;
@property(nonatomic, strong) UIButton *settingsBtn;
//@property(nonatomic, strong) UIButton *deleteTitleBtn;
//@property(nonatomic, strong) UIButton *settingsTitleBtn;

@end
@implementation DisplayAreaHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:17.0];
        [self.sectionTitleView addSubview:self.deleteBtn];
        [self.sectionTitleView addSubview:self.settingsBtn];
//        [self.sectionTitleView addSubview:self.deleteTitleBtn];
//        [self.sectionTitleView addSubview:self.settingsTitleBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(48, 0, self.sectionTitleView.width - 100, self.sectionTitleView.height);
   
    self.settingsBtn.frame  = CGRectMake( self.sectionTitleView.width - self.sectionTitleView.size.height/2-40, (self.sectionTitleView.height-24)/2 ,60, 24);
//    self.settingsTitleBtn.frame  = CGRectMake( CGRectGetMinX( self.settingsBtn.frame) - self.sectionTitleView.size.height, CGRectGetMinY(self.settingsBtn.frame), self.sectionTitleView.size.height, self.sectionTitleView.size.height/2);

    self.deleteBtn.frame = CGRectMake(8, (self.sectionTitleView.height-24)/2, 60, 24);
//    self.deleteTitleBtn.frame = CGRectMake(CGRectGetMaxX(self.deleteBtn.frame), CGRectGetMinY(self.deleteBtn.frame), self.sectionTitleView.size.height, self.sectionTitleView.size.height/2);
}

- (UIButton *)deleteBtn {
    if (_deleteBtn) {
        return _deleteBtn;
    }
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_deleteBtn setImage:[UIImage imageNamed:@"hxdb_delete"] forState:UIControlStateNormal];
    [_deleteBtn setTintColor:[UIColor grayColor]];
    [_deleteBtn addTarget:self action:@selector(actionDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _deleteBtn;

}

//- (UIButton *)deleteTitleBtn {
//    if (_deleteTitleBtn) {
//        return _deleteTitleBtn;
//    }
//    _deleteTitleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [_deleteTitleBtn setTitle:@"删除" forState:UIControlStateNormal];
//    [_deleteTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_deleteTitleBtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:18.0]];
//    [_deleteTitleBtn addTarget:self action:@selector(actionDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
//    return _deleteTitleBtn;
//}
- (void)actionDeleteBtn:(UIButton *)button {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (UIButton *)settingsBtn {
    if (_settingsBtn) {
        return _settingsBtn;
    }
    _settingsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_settingsBtn setImage:[UIImage imageNamed:@"hxdb_settings"] forState:UIControlStateNormal];
//    [_settingsBtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:18.0]];
//    [_settingsBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [_settingsBtn setTintColor:[UIColor grayColor]];
    [_settingsBtn addTarget:self action:@selector(actionSettingsBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return _settingsBtn;
}

//- (UIButton *)settingsTitleBtn {
//    if (_settingsTitleBtn) {
//        return _settingsTitleBtn;
//    }
//    _settingsTitleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [_settingsTitleBtn setTitle:@"设置" forState:UIControlStateNormal];
//    [_settingsTitleBtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:18.0]];
//    [_settingsTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    [_settingsTitleBtn addTarget:self action:@selector(actionSettingsBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    return _settingsTitleBtn;
//}


- (void)actionSettingsBtn:(UIButton *)btn {
    if (self.settingsBlock) {
        self.settingsBlock();
    }
}
@end
