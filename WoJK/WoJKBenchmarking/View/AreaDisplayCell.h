//
//  AreaDisplayCell.h
//  WoJK
//
//  Created by Megatron on 16/5/12.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DeleteButtonBlock)();
@interface AreaDisplayCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *flagImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLB;
@property (copy, nonatomic) DeleteButtonBlock deleteBlock;
@end
