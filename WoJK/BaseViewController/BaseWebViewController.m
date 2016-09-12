//
//  BaseWebViewController.m
//  HD100-Custom
//
//  Created by fosung_mac02 on 15/7/23.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "BaseWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "Macro.h"
#import "UIWebViewAdditions.h"
#import "MJRefresh.h"

@interface BaseWebViewController ()

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
    
    [self configWebView];
    [self initJSBridge];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    }
    return _webView;
}

-(void)leftBackButtonTouchUpInside:(UIButton *)sender{
    _bridge = nil;
    [super leftBackButtonTouchUpInside:sender];
}

- (void)initJSBridge{
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    __weak __typeof(self)weakSelf = self;
    [_bridge registerHandler:@"reload404" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf showWebView];
    }];
}

- (void)configWebView{
    __weak __typeof(self)weakSelf = self;
    self.webView.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf showWebView];
    }];
}

- (void)showWebView{
    
//    NSMutableURLRequest * mutableRequest = [URLRequestHelper requestWithURL:HomeURL parameter:self.url.absoluteString];
//    if (mutableRequest) {
//        [self.webView loadRequest:mutableRequest];
//    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
     [self setupActivityIndicatorView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [self stopActivityIndicatorView];
    [webView.scrollView.header endRefreshing];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [webView loadError];
    [self stopActivityIndicatorView];
    [webView.scrollView.header endRefreshing];
}


- (void)updateWebView {
    if (self.webView) {
        self.webView.frame = self.view.bounds;
        DLog(@" self.view.bounds(x,y,w= %f,h=%f) ", self.webView.frame.size.width,self.webView.frame.size.height );
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
