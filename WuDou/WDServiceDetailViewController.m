//
//  WDServiceDetailViewController.m
//  WuDou
//
//  Created by huahua on 16/8/12.
//  Copyright © 2016年 os1. All rights reserved.
//  主页 -- 便民服务 -- 服务详情

#import "WDServiceDetailViewController.h"
#import "WDLunBoView.h"

@interface WDServiceDetailViewController ()<WDLunBoViewDelegate,UIWebViewDelegate>
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
    UILabel *sateLabel;
    UILabel *fabuTime;
    UILabel *connectPerson;
    UILabel *phoneNum;
    UIView *backgroundView;  //花费积分购买之后的view
    UIView *bottomV;  //未花费积分购买之前的View
    
    //是否收藏
    BOOL _isLike;
    UIImageView * _likeImage;
    //分享
    UIView * bigShareView;
    UIView * wirtShareView;
    UIButton * _shareBtn;
    
    WDCreditProductsModel *_model;
    NSString *_needCount;  //兑换所需积分数
}

@property(nonatomic,strong)NSMutableArray *lunboArray;

@end

@implementation WDServiceDetailViewController

- (instancetype)initWithTitle:(NSString *)myTitle andShowPriceLabelEnabled:(BOOL)isShow{
    
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
    
    self.navigationController.navigationBarHidden = YES;
    [self _setNavTabUI];
    // 创建底部视图
    [self _createBottomView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _loadData];
    
    [self _setUIView];
}

- (void)_loadData{
    
    if (_isShowPrice == YES) {  //二手品
        
        [WDMainRequestManager requestLoadSecondStoreProductsMsgsWithPid:self.pid completion:^(WDCreditProductsModel *pmodel, NSString *error) {
            
            if (error) {
                SHOW_ALERT(error)
                return ;
            }
            _model = pmodel;
            details.text = pmodel.name;
            sateLabel.text = pmodel.sate;
            if (_isShowPrice) {
                _secondGoodsPrice.text = [NSString stringWithFormat:@"￥%@",pmodel.shopprice];
            }
            fabuTime.text = [NSString stringWithFormat:@"发布时间 ：%@",pmodel.time];
            _needCount = pmodel.creditsvalue;
            
            NSDictionary *images = pmodel.images;
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
            // 判断是否登陆
            [WDMineManager requestLoginEnabledWithCompletion:^(NSString *resultRet) {
                
                if ([resultRet isEqualToString:@"0"]) {
                    
                    _detailScrollView.height = kScreenHeight - 70;
                    
                    if (pmodel.mobile == nil || [pmodel.mobile isEqualToString:@""]) {  //需要积分兑换
                        
                        [self _useJIfenExchangeNumber];
                        
                    }else{  //直接显示
                        
                        [self.view addSubview:backgroundView];
                        [self.view addSubview:_bottomControl];
                        connectPerson.text = pmodel.contacts;
                        phoneNum.text = pmodel.mobile;
                        
                    }
                }
                else{
                    
                    NSLog(@"未登录");
                }
                
            }];
            
        }];
    }
    else{
        
        [WDMainRequestManager requestLoadConvenientProductsMsgsWithNewsId:self.newsid completion:^(WDCreditProductsModel *pmodel, NSString *error) {
        
            if (error) {
                SHOW_ALERT(error)
                return ;
            }
            _model = pmodel;
            details.text = pmodel.name;
            sateLabel.text = pmodel.sate;
            fabuTime.text = [NSString stringWithFormat:@"发布时间 ：%@",pmodel.time];
            _needCount = pmodel.creditsvalue;
            
            NSDictionary *images = pmodel.images;
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
            // 判断是否登陆
            [WDMineManager requestLoginEnabledWithCompletion:^(NSString *resultRet) {
                
                if ([resultRet isEqualToString:@"0"]) {  //登录
                    
                    _detailScrollView.height = kScreenHeight - 70;
                    
                    if (pmodel.mobile == nil || [pmodel.mobile isEqualToString:@""]) {  //需要积分兑换
                        
                        [self _useJIfenExchangeNumber];
                        
                    }else{  //直接显示
                        
                        [self.view addSubview:backgroundView];
                        [self.view addSubview:_bottomControl];
                        connectPerson.text = pmodel.contacts;
                        phoneNum.text = pmodel.mobile;
                        
                    }

                }
                else{
                    
                    NSLog(@"未登录");
                }
                
            }];
        }];
    }
}

/** 兑换积分换号码*/
- (void)_useJIfenExchangeNumber{
    
    bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 70, kScreenWidth, 70)];
    bottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomV];
    
    UIButton *jifenbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 50)];
    jifenbtn.backgroundColor = KSYSTEM_COLOR;
    [jifenbtn setTitle:@"查看联系方式" forState:UIControlStateNormal];
    [jifenbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jifenbtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [jifenbtn addTarget:self action:@selector(exchangeNumber) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:jifenbtn];
}
- (void)exchangeNumber{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"查看联系方式需要扣除 %@ 积分",_needCount] preferredStyle:UIAlertControllerStyleAlert];
    
    //用模态的方法显示对话框
    [self presentViewController:alert animated:YES completion:nil];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (_isShowPrice == YES) {  //二手品
            
            [WDMainRequestManager requestLookSecondGoodsMobileWithPid:self.pid completion:^(NSString *mobile, NSString *error) {
                
                if (error) {
                    
                    SHOW_ALERT(error)
                    return ;
                }
                
                if (bottomV) {
                    
                    [bottomV removeFromSuperview];
                }
                
                [self.view addSubview:backgroundView];
                [self.view addSubview:_bottomControl];
                connectPerson.text = _model.contacts;
                phoneNum.text = mobile;
                
            }];
        }
        else{   //便民服务
         
            [WDMainRequestManager requestLookConvenientMobileWithNewsId:self.newsid completion:^(NSString *mobile, NSString *error) {
                
                if (error) {
                    
                    SHOW_ALERT(error)
                    return ;
                }
                
                if (bottomV) {
                    
                    [bottomV removeFromSuperview];
                }
                
                [self.view addSubview:backgroundView];
                [self.view addSubview:_bottomControl];
                connectPerson.text = _model.contacts;
                phoneNum.text = mobile;
                
            }];
            
        }
    }];
    [alert addAction:sure];
}

//  自定义导航栏
- (void)_setNavTabUI{

    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navView.backgroundColor =KSYSTEM_COLOR;
    [self.view addSubview:_navView];
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 31, 15, 20)];
    backBtn.tag = 34;
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.enabled = NO;
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backBtn];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 100, 31, 200, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _navTitle;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_navView addSubview:titleLabel];
    
    _likeImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 31, 20, 20)];
    _likeImage.image = [UIImage imageNamed:@"收藏图标"];
//    [_navView addSubview:_likeImage];
    UIButton * likeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 31, 40, 40)];
    [likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
//    [_navView addSubview:likeBtn];
    
    UIImageView * shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 30, 31, 20, 20)];
    shareImage.image = [UIImage imageNamed:@"分享图标"];
//    [_navView addSubview:shareImage];
    _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 40, 31, 40, 40)];
    [_shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
//    [_navView addSubview:_shareBtn];
 
}

//  返回按钮
-(void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//  分享按钮
-(void)shareClick{
    
    [self shareUI];
    _shareBtn.userInteractionEnabled = NO;

}

//  收藏按钮
-(void)likeClick{
    
    _isLike = !_isLike;
    if (_isLike)
    {
        _likeImage.image = [UIImage imageNamed:@"icon_collection_write"];
    }
    else
    {
        _likeImage.image = [UIImage imageNamed:@"收藏图标"];
    }
}

//弹出分享
-(void)shareUI
{
    //灰色背景
    bigShareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 200)];
    bigShareView.backgroundColor = [UIColor blackColor];
    bigShareView.alpha = 0.5;
    UIButton * downBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 120)];
    [downBtn addTarget:self action:@selector(downShare) forControlEvents:UIControlEventTouchUpInside];
    [bigShareView addSubview:downBtn];
    //下面的白色背景
    wirtShareView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200)];
    wirtShareView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigShareView];
    [self.view addSubview:wirtShareView];
    
    UIImageView * WXImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 95, 40, 50, 50)];
    WXImage.image = [UIImage imageNamed:@"微信-1"];
    [wirtShareView addSubview:WXImage];
    UIButton * wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 95, 40, 50, 50)];
    [wxBtn addTarget:self action:@selector(shareClick:)forControlEvents:UIControlEventTouchUpInside];
    wxBtn.tag = 101;
    [wirtShareView addSubview:wxBtn];
    
    UILabel * wxLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 120, 90, 100, 20)];
    wxLabel.text = @"分享给微信好友";
    wxLabel.textAlignment = NSTextAlignmentCenter;
    wxLabel.textColor = [UIColor darkGrayColor];
    wxLabel.font = [UIFont systemFontOfSize:12.0];
    [wirtShareView addSubview:wxLabel];
    
    UIImageView * QQImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 + 45, 40, 50, 50)];
    QQImage.image = [UIImage imageNamed:@"朋友圈"];
    [wirtShareView addSubview:QQImage];
    UIButton * QQBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2 + 45, 40, 50, 50)];
    [QQBtn addTarget:self action:@selector(shareClick:)forControlEvents:UIControlEventTouchUpInside];
    QQBtn.tag = 102;
    [wirtShareView addSubview:QQBtn];
    UILabel * QQLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 + 20, 90, 100, 20)];
    QQLabel.text = @"分享到新浪微博";
    QQLabel.textAlignment = NSTextAlignmentCenter;
    QQLabel.textColor = [UIColor darkGrayColor];
    QQLabel.font = [UIFont systemFontOfSize:12.0];
    [wirtShareView addSubview:QQLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 159, kScreenWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [wirtShareView addSubview:line];
    UIButton * quxiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 160, kScreenWidth, 40)];
    [quxiaoBtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [quxiaoBtn addTarget:self action:@selector(downShare) forControlEvents:UIControlEventTouchUpInside];
    [wirtShareView addSubview:quxiaoBtn];
    
}
//选择分享的按钮
-(void)shareClick:(UIButton *)btn
{
    if (btn.tag == 101)
    {
        NSLog(@"分享到微信");
    }
    if (btn.tag == 102)
    {
        NSLog(@"分享到新浪微博");
    }
}

// 取消按钮
-(void)downShare
{
    _shareBtn.userInteractionEnabled = YES;
    [wirtShareView removeFromSuperview];
    [bigShareView removeFromSuperview];
}

/** 设置UI界面 */
- (void)_setUIView{
    
    // 创建滑动视图
    [self _createScrollView];
    
    // 创建顶部topView
    [self _createTopView];
    
    // 创建中间的webView
    [self _createWebView];
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
    
    CGFloat lunboViewH = kScreenWidth * 0.5;
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, lunboViewH + 70)];
    _topView.backgroundColor = [UIColor whiteColor];
    
    // 创建轮播图
    lunboView = [WDLunBoView lunBoViewWithFrame:CGRectMake(0, 0, kScreenWidth, lunboViewH) delegate:self placeholderImage:[UIImage imageNamed:@"noproduct.png"]];
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
    sateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 50, CGRectGetMaxY(lunboView.frame)+10, 40, 20)];
    sateLabel.textAlignment = NSTextAlignmentCenter;
    sateLabel.font = [UIFont systemFontOfSize:15.0];
    [_topView addSubview:sateLabel];
    
//    UIImageView *storeLogo = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(details.frame)+10, CGRectGetMaxY(lunboView.frame)+10, 29, 15)];
//    storeLogo.image = [UIImage imageNamed:@"商家图标"];
//    [_topView addSubview:storeLogo];
    
    // 创建二手品详情页面中的价格label
    if (_isShowPrice) {
        
        _secondGoodsPrice = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(details.frame), kScreenWidth - 30, 20)];
        _secondGoodsPrice.font = [UIFont systemFontOfSize:18.0];
        _secondGoodsPrice.textColor = [UIColor orangeColor];
        [_topView addSubview:_secondGoodsPrice];
        self.PriceLabel = _secondGoodsPrice;
    }
    
    // 创建发布时间
    fabuTime = [[UILabel alloc] init];
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
    
    _detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame)+10, kScreenWidth, kScreenHeight - CGRectGetMaxY(_topView.frame)-80)];

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
    
    [_detailScrollView addSubview:_detailWebView];
}

/** 创建底部视图（未兑换） */
- (void)_createBottomView{
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 70, kScreenWidth, 70)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 50)];
    _bottomView.backgroundColor = KSYSTEM_COLOR;
    
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
    
}
// 跳转至打电话界面
- (void)callToSomeone:(UIControl *)call{
    
    NSString *allString = [NSString stringWithFormat:@"tel:%@",phoneNum.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}

#pragma mark - UIWebViewDelegate
// 数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    UIButton *back = (UIButton *)[self.view viewWithTag:34];
    back.enabled = YES;
    
    [_detailWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGSize websize = [[change objectForKey:@"new"] CGSizeValue];
    
    _detailWebView.height = websize.height;
    _detailScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_detailWebView.frame));
    
}

- (void)dealloc
{
    [_detailWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}


@end
