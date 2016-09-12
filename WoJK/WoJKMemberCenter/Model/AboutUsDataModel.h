//
//  AboutUsDataModel.h
//  WoJK
//
//  Created by Megatron on 16/5/13.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AboutUsDataModel : NSObject
@property (nonatomic, copy) NSString *appLogo;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *linkManDesc;
@property (nonatomic, copy) NSString *depDesc;
@property (nonatomic, copy) NSString *appDesc;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *ercodeUrl;
@property (nonatomic, assign) NSInteger status;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
