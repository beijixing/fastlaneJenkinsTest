//
//  NSURLAdditions.m
//  HD100-Custom
//
//  Created by fosung_mac02 on 15/7/10.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "NSURLAdditions.h"

@implementation NSURL (Parse)

/**
 * 解析URL quary的返回字典。
 */
- (NSDictionary *)quaryDictionary{
    NSArray *pairs = [self.query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *val =[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
    }
    return params;
}

- (NSDictionary *)jsonDictionaryWithKey:(NSString *)key{
    if (!key) {
        return nil;
    }
    NSDictionary * quaryDic = [self quaryDictionary];
    NSString * value = quaryDic[key];
    NSData *jsonData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    return jsonDic;
}



@end
