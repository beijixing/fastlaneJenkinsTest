//
//  NSURLAdditions.h
//  HD100-Custom
//
//  Created by fosung_mac02 on 15/7/10.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Parse)


/**
 * 解析URL quary的返回字典。
 */
- (NSDictionary *)quaryDictionary;

/**
 *返回URLDecode 之后的数据
 */
- (NSDictionary *)jsonDictionaryWithKey:(NSString *)key;
@end
