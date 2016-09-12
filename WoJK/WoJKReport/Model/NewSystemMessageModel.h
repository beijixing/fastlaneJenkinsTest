//
//  NewSystemMessageModel.h
//  WoJK
//
//  Created by Megatron on 16/5/17.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewSystemMessageModel : NSObject
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *contentId;
@property(nonatomic) NSInteger noticeType;
@property(nonatomic, copy) NSString *noticeTypeName;
@property(nonatomic, copy) NSString *title;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
