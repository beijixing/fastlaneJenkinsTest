//
//  CircleButton.h
//  HiSchool
//
//  Created by ybon on 16/3/8.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLabel.h"

typedef void(^CircleButtonClick)(NSInteger tag, NSString *title);

@interface CircleButton : UIView
@property (nonatomic, copy)CircleButtonClick btnClickBlock;
@property(nonatomic, strong) ZLabel *titleLabel;
@property(nonatomic, strong) UIImageView* cirCleButton;
@end
