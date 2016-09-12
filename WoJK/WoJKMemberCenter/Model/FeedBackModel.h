//
//  FeedBackModel.h
//  HD100-Custom
//
//  Created by WenJie on 15/7/14.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "JSONModel.h"
/**
 *  意见反馈
 */
@interface FeedBackModel : JSONModel
@property (nonatomic, assign) BOOL success;
@property (strong, nonatomic) NSString *msg;
@end
