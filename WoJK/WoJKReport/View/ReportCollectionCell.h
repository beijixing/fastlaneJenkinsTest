//
//  ReportCollectionCell.h
//  WoJK
//
//  Created by Megatron on 16/5/16.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLabel.h"
@interface ReportCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) IBOutlet ZLabel *titleLB;
@end
