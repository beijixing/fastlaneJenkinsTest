//
//  NSURLRequest+Header.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/14.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "NSURLRequest+Header.h"

@implementation NSURLRequest (Header)
-(BOOL)hasCustomHeader
{
    NSDictionary *dict = [self allHTTPHeaderFields];
    if ([dict.allKeys  containsObject:@"SIGN"]) {
        return YES;
    }
    return NO;
}
@end
