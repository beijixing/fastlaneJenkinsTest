//
//  SystemMessageCell.h
//  WoJK
//
//  Created by Megatron on 16/5/10.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMessageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLB;
@property (strong, nonatomic) IBOutlet UILabel *timeLB;
@property (strong, nonatomic) IBOutlet UILabel *contentLB;
@property (strong, nonatomic) IBOutlet UILabel *readStatusLabel;
@end
