//
//  AreaResponseModel.m
//  WoJK
//
//  Created by Megatron on 16/5/11.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "AreaResponseModel.h"

@implementation AreaResponseModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.code = [NSString stringWithFormat:@"%@", [dict objectForKey:@"code"]];
        self.maxNum = [[dict objectForKey:@"maxNum"] integerValue];
        NSArray *dataList = [dict objectForKey:@"dataList"];
        if (dataList) {
            NSMutableArray *areaDataModelArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dataDict in dataList) {
                AreaDataModel *areaDataModel = [[AreaDataModel alloc] initWithDictionary:dataDict];
                [areaDataModelArr addObject:areaDataModel];
            }
            
            self.areaDataModelArr = areaDataModelArr;
        }
        self.message = [NSString stringWithFormat:@"%@", [dict objectForKey:@"message"]];
        
    }
    return self;
}
@end
