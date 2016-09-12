//
//  SystemMessageModel.h
//  WoJK
//
//  Created by Megatron on 16/5/15.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMessageModel : NSObject
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *contentId;
@property(nonatomic, copy) NSString *noticeTypeName;
@property(nonatomic, assign) NSInteger readStatus;
@property(nonatomic, assign) NSInteger noticeType;
@property(nonatomic, copy) NSString *sendTime;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *sendUserName;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
