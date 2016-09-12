//
//  NSString+MD5.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/6.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "NSStringAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)
-(NSString *)md5String
{
    const char *original_str = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, (uint32_t)strlen(original_str), result);
    NSMutableString *md5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [md5 appendFormat:@"%02X",result[i]];
    return [md5 lowercaseString];
}

+ (NSString *)formatNumberWithComma:(NSString *)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensure the right separator behavior
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    NSNumber *numberFromString = [numberFormatter  numberFromString:number];
    NSString *desStr = [numberFormatter stringForObjectValue:numberFromString];
    return desStr;
}

@end
