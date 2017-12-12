//
//  WDWKViewController.m
//  WuDou
//
//  Created by huahua on 17/1/19.
//  Copyright © 2017年 os1. All rights reserved.
//

#import "WDWKViewController.h"
#import <WebKit/WebKit.h>
#import "WDUserJudgeCell.h"
#import "WDMainRequestManager.h"
@interface WDWKViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIWebView *_WDWebView;
    UIActivityIndicatorView *_myActivityIndicator;
    NSMutableArray *_judgeAllArray;
    NSMutableArray *_judgeArray;  //评论的条数
    NSString *_judgeCount;  //评价数
    NSString *_judgeBili;  //好评率
}

@property(nonatomic,strong)UITableView *judgeTableView;
@end

@implementation WDWKViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)getData{
    
     [WDMainRequestManager requestJudgementsWithPid:_goodID completion:^(NSMutableArray *array, NSString *error) {
     
     if (error) {
     
     //            SHOW_ALERT(error)
     //  暂无评论
     UILabel *noJudgement = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-100)*0.5, 100+ 25, 100, 20)];
     noJudgement.backgroundColor = [UIColor clearColor];
     noJudgement.text = @"暂无评论";
     noJudgement.tag = 123;
     noJudgement.textColor = [UIColor grayColor];
     noJudgement.textAlignment = NSTextAlignmentCenter;
     noJudgement.font = [UIFont systemFontOfSize:15.0];
     [self.view addSubview:noJudgement];
     
     return ;
     }
     
     _judgeAllArray = array;
     _judgeCount = array[0];
     _judgeBili = array[1];
     _judgeArray = array[2];
     
     CGFloat tableViewH = 0;
     NSInteger a;
     if (_judgeArray.count > 4) {
     
     a = 4;
     }else{
     
     a = _judgeArray.count;
     }
     
     for (int i = 0; i < a; i ++) {
     
     WDCellLayout *layout = _judgeArray[i];
     tableViewH += layout.cellHeight;
     }
     
     _judgeTableView.frame = CGRectMake(0, 0, kScreenWidth, tableViewH+100);
     
     
     
     [_judgeTableView reloadData];
     
     }];
     
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
        return _judgeArray.count;

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
  
    NSString *cellid =@"cellid";
    WDUserJudgeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WDCellLayout *layout = _judgeArray[indexPath.row];
    cell.layout = layout;
        
    return cell;
    
    
}

/** 创建评论列表*/
- (void)_createjudgeTableView{
    
    _judgeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _judgeTableView.delegate = self;
    _judgeTableView.dataSource = self;
    _judgeTableView.scrollEnabled = NO;
    [_judgeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_judgeTableView registerNib:[UINib nibWithNibName:@"WDUserJudgeCell" bundle:nil] forCellReuseIdentifier:@"cellid"];
    
    [self.view addSubview:_judgeTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _judgeAllArray = [[NSMutableArray alloc] init];
    _judgeArray = [[NSMutableArray alloc] init];
    [self getData];
    self.title = _navTitle;
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self _setupNavigation];
    
    
    // 1.创建webview，并设置大小，"20"为状态栏高度
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49-15)];
    
    // 2.创建请求
    webView.scrollView.bounces = NO;
    [webView sizeToFit];
    webView.UIDelegate = self;
    webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    webView.navigationDelegate = self;
    NSString *urlStr = _urlString;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3.加载网页
    [webView loadRequest:request];
    
    // 最后将webView添加到界面
//    [self.view addSubview:webView];
    [self _createjudgeTableView];
    
    //    _WDWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49-15)];
    //    _WDWebView.delegate = self;
    //    _WDWebView.scalesPageToFit = YES;
    //    _WDWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    _WDWebView.backgroundColor = kViewControllerBackgroundColor;
    
    //    NSString *urlStr = _urlString;
    //    NSURL *url = [NSURL URLWithString:urlStr];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    [_WDWebView loadRequest:request];
    //    [self.view addSubview:_WDWebView];
    
    
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
    [btn setImageEdgeInsets:UIEdgeInsetsMake(4, 3, 4,3)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
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
