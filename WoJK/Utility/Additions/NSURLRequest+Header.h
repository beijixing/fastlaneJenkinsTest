//
//  NSURLRequest+Header.h
//  HD100-Custom
//
//  Created by WenJie on 15/7/14.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (Header)
/**
 *  判断Request是否已经添加了定制Header
 */
- (BOOL)hasCustomHeader;
@end
