//
//  NSDate+CustomDate.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/6.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "NSDateAdditions.h"

@implementation NSDate (CurrentTime)
+(NSString *)getCurrentTime
{
    NSString *currentTime;
    @autoreleasepool {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateNow = [NSDate date];
        currentTime = [dateFormatter stringFromDate:dateNow];
    }
    return currentTime;
}
@end
