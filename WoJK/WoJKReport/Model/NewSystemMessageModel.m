//
//  NewSystemMessageModel.m
//  WoJK
//
//  Created by Megatron on 16/5/17.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "NewSystemMessageModel.h"

@implementation NewSystemMessageModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.code = [dict objectForKey:@"code"];
        NSDictionary *notice = [dict objectForKey:@"Notice"];
        self.content = [NSString stringWithFormat:@"%@", [notice objectForKey:@"content"]];
        self.contentId = [NSString stringWithFormat:@"%@", [notice objectForKey:@"id"]];
        self.noticeType = [[notice objectForKey:@"noticeType"] integerValue];
        self.noticeTypeName = [NSString stringWithFormat:@"%@", [notice objectForKey:@"noticeTypeName"]];
        self.title = [NSString stringWithFormat:@"%@", [notice objectForKey:@"title"]];
    }
    return self;
}
@end
