//
//  IndexAndCityVC.h
//  WoJK
//
//  Created by Megatron on 16/5/9.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "BaseViewController.h"

@protocol IndexAndCityVCDelegate <NSObject>

- (void)getSelectedKPI:(NSDictionary *)kpiDict andArea:(NSDictionary *)areaDict andPolecity:(NSString *)areaCode;

@end

@interface IndexAndCityVC : BaseViewController
@property (nonatomic, assign) id <IndexAndCityVCDelegate> delegate;
@property (nonatomic) BOOL isIndex;
@end
