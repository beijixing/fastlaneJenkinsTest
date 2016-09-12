//
//  IncomeInfoView.h
//  WoJK
//
//  Created by Megatron on 16/4/21.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncomeInfoView;
@protocol IncomeInfoViewDelegate <NSObject>

- (void)incomeInfoView:(IncomeInfoView*)incomeView tapped:(NSInteger)tag;

@end

@interface IncomeInfoView : UIView
@property(nonatomic, weak) id <IncomeInfoViewDelegate>delegate;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *income;
@property(nonatomic, strong) UILabel *huanbiLb;
@property(nonatomic, strong) UILabel *tongbiLb;
@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UIView *dataBgView;
@property(nonatomic, strong) UIImageView *bgImage;

- (void)setLargeFont;
- (void)setSmallFont;
- (void)setLabelColorAndBgColor:(BOOL)isSelected;
@end
