//
//  SelectedAreaDataManager.h
//  WoJK
//
//  Created by Megatron on 16/5/12.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedAreaDataManager : NSObject
+ (NSDictionary *)querySelectedAreaData;
+ (BOOL)saveSelectedAreaData:(NSDictionary *)selectedData;
+ (BOOL)deleteAreaDataByCode:(NSString *)areaCode;
@end
