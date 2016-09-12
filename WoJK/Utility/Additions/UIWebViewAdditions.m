//
//  UIWebViewAdditions.m
//  HD100-Custom
//
//  Created by fosung_mac02 on 15/7/24.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "UIWebViewAdditions.h"

@implementation UIWebView (Error)

- (void)loadError{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"404" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];

}

@end
