//
//  DisplayAreaHeader.h
//  WoJK
//
//  Created by Megatron on 16/5/18.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "BaseTableHeaderView.h"

typedef void(^HeaderActionBlock)();
@interface DisplayAreaHeader : BaseTableHeaderView
@property(nonatomic, copy) HeaderActionBlock deleteBlock;
@property(nonatomic, copy) HeaderActionBlock settingsBlock;
@end
