//
//  MessageDetail.h
//  WoJK
//
//  Created by Megatron on 16/5/10.
//  Copyright © 2016年 zhilong. All rights reserved.
//


#import "BaseViewController.h"
#import "SystemMessageModel.h"
@interface MessageDetail : BaseViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLB;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UILabel *sendTimeLB;
@property(nonatomic, strong) SystemMessageModel *messageModel;
@end
