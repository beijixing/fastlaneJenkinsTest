//
//  ContactUSVC.h
//  WoJK
//
//  Created by Megatron on 16/5/12.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutUsDataModel.h"

@interface ContactUSVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *apartmentLB;
@property (strong, nonatomic) IBOutlet UILabel *contactOneLB;
@property (strong, nonatomic) IBOutlet UILabel *contactTwoLB;
@property (strong, nonatomic) IBOutlet UITextView *contactTextView;
@property (nonatomic, strong) AboutUsDataModel *aboutUsDataModel;
@end
