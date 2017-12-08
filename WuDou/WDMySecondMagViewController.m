//
//  WDMySecondMagViewController.m
//  WuDou
//
//  Created by huahua on 16/10/17.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMySecondMagViewController.h"
#import "WDLunBoView.h"

@interface WDMySecondMagViewController ()<UIWebViewDelegate,WDLunBoViewDelegate>
{
    UIView * _navView;  //自定义导航栏
    UIScrollView *_detailScrollView;
    UIView *_topView;
    UILabel *_secondGoodsPrice;
    UIWebView *_detailWebView;
    UIView *_bottomView;
    UIControl *_bottomControl;
    UIActivityIndicatorView *_activityIndicatorView;
    WDLunBoView *lunboView;
    UILabel *details;
    UILabel *satelabel;
    UILabel *fabuTime;
    UILabel *connectPerson;
    UILabel *phoneNum;
    
    //是否收藏
    BOOL _isLike;
    UIImageView * _likeImage;
    //分享
    UIView * bigShareView;
    UIView * wirtShareView;
    UIButton * _shareBtn;
}
@property(nonatomic,strong)NSMutableArray *lunboArray;

@end

@implementation WDMySecondMagViewController

- (instancetype)initWithTitle:(NSString *)myTitle showPriceLabelEnabled:(BOOL)isShow{
    
    if (self = [super init]) {
        
        _navTitle = myTitle;
        _isShowPrice = isShow;
    }
    return self;
}

- (NSMutableArray *)lunboArray{
    
    if (! _lunboArray) {
        
        _lunboArray = [NSMutableArray array];
    }
    
    return _lunboArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self _setNavTabUI];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _loadModelDatas];
    
    [self _setUIView];
}

//  自定义导航栏
- (void)_setNavTabUI{
    
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navView.backgroundColor =KSYSTEM_COLOR;
    [self.view addSubview:_navView];
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 31, 15, 20)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backBtn];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 100, 31, 200, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _navTitle;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_navView addSubview:titleLabel];
    
}

//  返回按钮
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_loadModelDatas{
    
    if (_isShowPrice == YES) {
        
        [WDMineManager requestMySecondGoodsMsgWithPid:self.pid completion:^(WDCreditProductsModel *model, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            details.text = model.name;
            satelabel.text = model.sate;
            if (_isShowPrice) {
                _secondGoodsPrice.text = [NSString stringWithFormat:@"￥%@",model.shopprice];
            }
            fabuTime.text = [NSString stringWithFormat:@"发布时间 ：%@",model.time];
            connectPerson.text = model.contacts;
            phoneNum.text = model.mobile;
            
            NSDictionary *images = model.images;
            NSString *ret = images[@"ret"];
            if ([ret isEqualToString:@"0"]) {
                
                NSArray *data = images[@"data"];
                for (NSDictionary *dic in data) {
                    
                    NSString *img = dic[@"img"];
                    NSString *urlImg = [NSString stringWithFormat:@"%@%@",IMAGE_URL,img];
                    [self.lunboArray addObject:urlImg];
                }
                
                lunboView.imageURLStringsGroup = self.lunboArray;
            }
            
        }];
    }else{
        
        [WDMineManager requestLoadMyServiceMsgWithNewsid:self.newsid completion:^(WDCreditProductsModel *model, NSString *error) {
            
            if (error) {
                SHOW_ALERT(error)
                return ;
            }
            
            details.text = model.name;
            satelabel.text = model.sate;
            fabuTime.text = [NSString stringWithFormat:@"发布时间 ：%@",model.time];
            connectPerson.text = model.contacts;
            phoneNum.text = model.mobile;
            
            NSDictionary *images = model.images;
            NSString *ret = images[@"ret"];
            if ([ret isEqualToString:@"0"]) {
                
                NSArray *data = images[@"data"];
                for (NSDictionary *dic in data) {
                    
                    NSString *img = dic[@"img"];
                    NSString *urlImg = [NSString stringWithFormat:@"%@%@",IMAGE_URL,img];
                    [self.lunboArray addObject:urlImg];
                }
                
                lunboView.imageURLStringsGroup = self.lunboArray;
            }
            
        }];
    }
}

/** 设置UI界面 */
- (void)_setUIView{
    
    // 创建滑动视图
    [self _createScrollView];
    
    // 创建顶部topView
    [self _createTopView];
    
    // 创建中间的webView
    [self _createWebView];
    
    // 创建底部视图
    [self _createBottomView];
}

/** 创建滑动视图 */
- (void)_createScrollView{
    
    _detailScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_navView.frame), kScreenWidth, kScreenHeight)];
    _detailScrollView.backgroundColor = kViewControllerBackgroundColor;
    _detailScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_detailScrollView];
}

/** 创建顶部topView */
- (void)_createTopView{
    
    CGFloat topViewH = kScreenWidth * 0.5;
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, topViewH+70)];
    _topView.backgroundColor = [UIColor whiteColor];
    
    // 创建轮播图
    lunboView = [WDLunBoView lunBoViewWithFrame:CGRectMake(0, 0, kScreenWidth, topViewH) delegate:self placeholderImage:[UIImage imageNamed:@"noproduct.png"]];
    lunboView.autoScrollTimeInterval = 2.0f;
    lunboView.showPageControl = YES;
    lunboView.pageControlBottomOffset = -12;
    lunboView.pageControlAliment = WDLunBoViewPageContolAlimentCenter;
    lunboView.currentPageDotColor = KSYSTEM_COLOR;
    lunboView.pageDotColor = [UIColor lightGrayColor];
    [_topView addSubview:lunboView];
    
    // 创建商品名称
    details = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lunboView.frame)+10, kScreenWidth - 60, 20)];
    details.font = [UIFont systemFontOfSize:15.0];
    [_topView addSubview:details];
    
    // 创建 商家/个人发布状态
    satelabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 50, CGRectGetMaxY(lunboView.frame)+10, 40, 20)];
    satelabel.textAlignment = NSTextAlignmentCenter;
    satelabel.font = [UIFont systemFontOfSize:15.0];
    [_topView addSubview:satelabel];
    
//    UIImageView *storeLogo = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(details.frame)+10, CGRectGetMaxY(lunboView.frame)+10, 29, 15)];
//    storeLogo.image = [UIImage imageNamed:@"商家图标"];
//    [_topView addSubview:storeLogo];
    
    // 创建二手品详情页面中的价格label
    if (_isShowPrice) {
        
        _secondGoodsPrice = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(details.frame), kScreenWidth - 30, 20)];
        _secondGoodsPrice.font = [UIFont systemFontOfSize:18.0];
        _secondGoodsPrice.textColor = [UIColor orangeColor];
        [_topView addSubview:_secondGoodsPrice];
        self.priceLabel = _secondGoodsPrice;
    }
    
    // 创建发布时间
    fabuTime = [[UILabel alloc]init];
    if (_secondGoodsPrice) {
        
        fabuTime.frame = CGRectMake(15, CGRectGetMaxY(_secondGoodsPrice.frame), kScreenWidth - 30, 20);
    }else{
        fabuTime.frame = CGRectMake(15, CGRectGetMaxY(details.frame)+10, kScreenWidth - 30, 20);
    }
    fabuTime.font = [UIFont systemFontOfSize:13.0];
    fabuTime.textColor = [UIColor lightGrayColor];
    [_topView addSubview:fabuTime];
    
    [_detailScrollView addSubview:_topView];
}

/** 创建中间的webView */
- (void)_createWebView{
    
    _detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame)+10, kScreenWidth, 0)];
    
    _detailWebView.delegate = self;
    _detailWebView.scrollView.scrollEnabled = NO;  //禁止滑动
    _detailWebView.scalesPageToFit = YES;  //网页自适应屏幕
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr;
    if (_isShowPrice == YES) {
        
        urlStr = [NSString stringWithFormat:@"%@wapapp/secondhand.html?access_token=%@&pid=%@",HTML5_URL,token,self.pid];
    }else{
        
        urlStr = [NSString stringWithFormat:@"%@wapapp/myserviceinfo.html?access_token=%@&newsid=%@",HTML5_URL,token,self.newsid];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_detailWebView loadRequest:request];
    
    //  添加loading控件
    CGFloat width = self.view.center.x;
    CGFloat height = self.view.center.y;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width-30, height-80, 60, 60)];
    [view setTag:333];
    [view setBackgroundColor:[UIColor grayColor]];
    [view setAlpha:0.5];
    view.layer.cornerRadius = 10;
    [self.view addSubview:view];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [_activityIndicatorView setCenter:view.center];
    _activityIndicatorView.color = [UIColor blackColor];
    [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:_activityIndicatorView];
    
    [_detailScrollView addSubview:_detailWebView];
    
}

/** 创建底部视图 */
- (void)_createBottomView{
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 70, kScreenWidth, 70)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 50)];
    _bottomView.backgroundColor = KSYSTEM_COLOR;
    //    _bottomView.alpha = 0.9;
    
    // 创建 打电话图标
    UIImageView *phoneLogo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    phoneLogo.image = [UIImage imageNamed:@"电话"];
    [_bottomView addSubview:phoneLogo];
    
    // 创建 联系人 label
    connectPerson = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneLogo.frame)+15, 15, 80, 20)];
    connectPerson.font = [UIFont systemFontOfSize:14.0];
    connectPerson.textColor = [UIColor whiteColor];
    
    [_bottomView addSubview:connectPerson];
    
    // 创建 电话号码 label
    phoneNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(connectPerson.frame), 15, kScreenWidth - (CGRectGetMaxX(connectPerson.frame)), 20)];
    phoneNum.font = [UIFont systemFontOfSize:14.0];
    phoneNum.textColor = [UIColor whiteColor];
    
    [_bottomView addSubview:phoneNum];
    
    [backgroundView addSubview:_bottomView];
    
    _bottomControl = [[UIControl alloc]initWithFrame:backgroundView.frame];
    _bottomControl.backgroundColor = [UIColor clearColor];
    [_bottomControl addTarget:self action:@selector(callToSomeone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomControl];
    
}
// 跳转至打电话界面
- (void)callToSomeone:(UIControl *)call{
    
    NSString *allString = [NSString stringWithFormat:@"tel:10086"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}

#pragma mark - UIWebViewDelegate
// 加载网页动画
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [_activityIndicatorView startAnimating];  //开始加载数据
    
}
// 数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];  //根据网页内容计算webview的高度
    CGFloat height = [height_str intValue];
    //    NSLog(@"%lf",height);
    webView.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame)+10, kScreenWidth, height);
    
    
    [_activityIndicatorView stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:333];
    [view removeFromSuperview];
}


- (void)viewWillLayoutSubviews{

    [super viewWillLayoutSubviews];

    _detailScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_detailWebView.frame) + 70);
}


@end
