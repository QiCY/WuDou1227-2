//
//  WDNewsViewController.m
//  WuDou
//
//  Created by huahua on 16/8/15.
//  Copyright © 2016年 os1. All rights reserved.
//  首页 -- 消息

#import "WDNewsViewController.h"
#import "WDNearDetailsViewController.h"
#import "WDLoginViewController.h"
#import "WDStoreDetailViewController.h"

@interface WDNewsViewController ()<UIWebViewDelegate>
{
    UIWebView *_newsWebView;
}
@end

@implementation WDNewsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息中心";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setupNavigationBar];
    
    _newsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _newsWebView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]];
    [_newsWebView loadRequest:request];
    
    [self.view addSubview:_newsWebView];
}

//  自定义导航栏返回按钮
- (void)_setupNavigationBar{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 15, 20);
    [btn setImageEdgeInsets:UIEdgeInsetsMake(4, 3, 4,3)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nativelocation:(NSString *)sid{
    
//    WDNearDetailsViewController *detailsVC = [[WDNearDetailsViewController alloc] init];
    WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
    nearVC.type = 1;
    nearVC.storeId = sid;
    [self.navigationController pushViewController:nearVC animated:YES];
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"URL = %@",urlString);
    
    if ([urlString containsString:@"nativelocation"]) {
        
        //  http://120.55.160.226:902/nativelocation/?nativesate=1&storeid=11
        
        NSString *sub1 = @"http://120.55.160.226:902/";
        NSString *string1 = [urlString substringFromIndex:sub1.length];
        
        NSString *sub2 = @"nativelocation/";
        NSString *methedName = [string1 substringToIndex:sub2.length];
        methedName = [methedName stringByReplacingOccurrencesOfString:@"/" withString:@":"]; //方法名
        
        NSString *sub3 = @"nativelocation/?nativesate=1&storeid=";
        NSString *pram = [string1 substringFromIndex:sub3.length];  // 参数
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        //含警告的代码
        [self performSelector:NSSelectorFromString(methedName) withObject:pram];
        
#pragma clang diagnostic pop
        
        return NO; //  拦截js的跳转
    }
    if ([urlString containsString:@"login"]) {
        
        //URL = http://120.55.160.226:902/wapapp/login.html
        //      http://admin.wudoll.com/wapapp/login.html
        
        NSString *sub1 = @"http://admin.wudoll.com/wapapp/";
        NSString *string1 = [urlString substringFromIndex:sub1.length];
        
        NSString *methedStr = [string1 substringToIndex:5];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        //含警告的代码
        [self performSelector:NSSelectorFromString(methedStr) withObject:nil];
        
#pragma clang diagnostic pop
        
        return NO; //  拦截js的跳转
    }
    
    return YES;
}

/** 拦截JS，跳转到登陆界面*/
- (void)login{
    
    WDLoginViewController *loginVC = [[WDLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
