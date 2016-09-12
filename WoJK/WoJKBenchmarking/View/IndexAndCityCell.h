//
//  IndexAndCityCell.h
//  WoJK
//
//  Created by Megatron on 16/5/9.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CellSelectedBlock)();
@interface IndexAndCityCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *checkBtn;
@property (strong, nonatomic) IBOutlet UIButton *flagBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLB;
@property (copy, nonatomic) CellSelectedBlock checkBlock;
@property (copy, nonatomic) CellSelectedBlock flagBlock;
@property (strong, nonatomic) IBOutlet UIView *checkActionView;
@property (strong, nonatomic) IBOutlet UIView *flagActionView;
@property (nonatomic) BOOL canTouchFlagView;
@end
