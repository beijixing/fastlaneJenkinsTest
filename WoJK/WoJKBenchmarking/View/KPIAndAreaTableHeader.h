//
//  KPIAndAreaTableHeader.h
//  WoJK
//
//  Created by Megatron on 16/5/12.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "BaseTableHeaderView.h"
typedef void(^TableHeaderSelectedBlock)();
@interface KPIAndAreaTableHeader : BaseTableHeaderView
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIButton *flagBtn;
@property (nonatomic, strong) UIView *checkActionView;
@property (nonatomic, strong) UIView *flagActionView;
@property (copy, nonatomic) TableHeaderSelectedBlock checkBlock;
@property (copy, nonatomic) TableHeaderSelectedBlock flagBlock;
@end
