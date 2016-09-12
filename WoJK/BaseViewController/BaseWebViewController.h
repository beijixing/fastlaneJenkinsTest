//
//  BaseWebViewController.h
//  HD100-Custom
//
//  Created by fosung_mac02 on 15/7/23.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "BaseViewController.h"
#import "WebViewJavascriptBridge.h"

@interface BaseWebViewController : BaseViewController<UIWebViewDelegate>{
    WebViewJavascriptBridge * _bridge;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, assign) BOOL refresh;

- (void)showWebView;
- (void)updateWebView;
@end
