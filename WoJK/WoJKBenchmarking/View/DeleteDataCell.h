//
//  DeleteDataCell.h
//  WoJK
//
//  Created by Megatron on 16/5/18.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteCellTappedBlock)();
@interface DeleteDataCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkImageView;
@property (copy, nonatomic) DeleteCellTappedBlock tappedBlock;
@end
