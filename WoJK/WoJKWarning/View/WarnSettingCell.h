//
//  WarnSettingCell.h
//  WoJK
//
//  Created by Megatron on 16/5/4.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^WarnStateBlock)(BOOL on);

@interface WarnSettingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UISwitch *warnStateSwitch;
@property (nonatomic, copy) WarnStateBlock switchAction;
@property (strong, nonatomic) IBOutlet UILabel *indexName;
@end
