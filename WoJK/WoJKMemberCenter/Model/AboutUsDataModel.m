//
//  AboutUsDataModel.m
//  WoJK
//
//  Created by Megatron on 16/5/13.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "AboutUsDataModel.h"

@implementation AboutUsDataModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.appDesc = [NSString stringWithFormat:@"%@", [dict objectForKey:@"APP_DESC"]];
        self.appId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"APP_ID"]];
        self.depDesc = [NSString stringWithFormat:@"%@", [dict objectForKey:@"DEP_DESC"]];
        self.linkManDesc = [NSString stringWithFormat:@"%@", [dict objectForKey:@"LINK_MAN_DESC"]];
        self.status = [[dict objectForKey:@"STATUS"] integerValue];
        self.ercodeUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"CODE_URL"]];
        self.code = [NSString stringWithFormat:@"%@", [dict objectForKey:@"code"]];
    }
    return self;
}
@end
