//
//  AreaDataMdel.h
//  WoJK
//
//  Created by Megatron on 16/5/11.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaDataModel : NSObject
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *areaCode;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) NSInteger areaFlag;
@property (nonatomic, assign) NSInteger flag;//标杆城市 0不是标杆城市， 1 是标杆城市

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
