//
//  IndexCell.h
//  WoJK
//
//  Created by Megatron on 16/6/20.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^IndexCellSelectedBlock)();
@interface IndexCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *checkBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLB;
@property (copy, nonatomic) IndexCellSelectedBlock checkBlock;
@end
