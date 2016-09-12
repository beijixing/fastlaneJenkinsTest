//
//  SystemMessageModel.m
//  WoJK
//
//  Created by Megatron on 16/5/15.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "SystemMessageModel.h"
/**
 CONTENT = "开会12344";
 ID = 402882a8547a66de01547a6932100005;
 "NOTICE_TYPE" = 1;
 "NOTICE_TYPE_NAME" = "升级公告";
 "READ_STATUS" = 0;
 "SEND_TIME" = "2016-05-13 12:00:00";
 "SEND_USER" = 2c90859149656e020149656f3fd50044;
 "SEND_USER_NAME" = "管理员";
 TITLE = "开会";
 
 - returns: <#return value description#>
 */
@implementation SystemMessageModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.content = [NSString stringWithFormat:@"%@", [dict objectForKey:@"CONTENT"]];
        self.contentId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"ID"]];
        self.noticeType = [[dict objectForKey:@"NOTICE_TYPE"] integerValue];
        self.noticeTypeName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"NOTICE_TYPE_NAME"]];
        self.readStatus = [[dict objectForKey:@"READ_STATUS"] integerValue];
        self.title = [NSString stringWithFormat:@"%@", [dict objectForKey:@"TITLE"]];
        self.sendTime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"SEND_TIME"]];
        self.sendUserName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"SEND_USER_NAME"]];
    }
    
    return self;
}
@end
