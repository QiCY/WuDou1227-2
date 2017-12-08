//
//  WDWebViewController.m
//  WuDou
//
//  Created by huahua on 16/8/6.
//  Copyright © 2016年 os1. All rights reserved.
//  H5页面

#import "WDWebViewController.h"

@interface WDWebViewController ()<UIWebViewDelegate>
{
    UIWebView *_WDWebView;
    UIActivityIndicatorView *_myActivityIndicator;
}
@end

@implementation WDWebViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _navTitle;
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self _setupNavigation];
    
    _WDWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49-15)];
    _WDWebView.delegate = self;
    _WDWebView.scalesPageToFit = YES;
    _WDWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _WDWebView.backgroundColor = kViewControllerBackgroundColor;
    
    NSString *urlStr = _urlString;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_WDWebView loadRequest:request];
    [self.view addSubview:_WDWebView];
    
    
    CGFloat width = self.view.center.x;
    CGFloat height = self.view.center.y;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width-30, height-80, 60, 60)];
    [view setTag:103];
    [view setBackgroundColor:[UIColor grayColor]];
    [view setAlpha:0.5];
    view.layer.cornerRadius = 10;
//    [_WDWebView addSubview:view];
    
    _myActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [_myActivityIndicator setCenter:view.center];
     _myActivityIndicator.color = [UIColor blackColor];
    [_myActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [_WDWebView addSubview:_myActivityIndicator];
    
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 15, 20);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate
//加载网页动画
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
//    [_myActivityIndicator startAnimating];  //开始加载数据
   
} 

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    [_myActivityIndicator stopAnimating];
//    UIView *view = (UIView *)[self.view viewWithTag:103];
//    [view removeFromSuperview];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

@end
