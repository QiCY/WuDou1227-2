//
//  WDJifenMsgViewController.m
//  WuDou
//
//  Created by huahua on 16/10/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDJifenMsgViewController.h"
#import "WDLunBoView.h"
#import "WDjifenAddressCell.h"
#import "WDAddressTableVController.h"
#import "WDMyOrderViewController.h"

@interface WDJifenMsgViewController ()<WDLunBoViewDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *_mainScrollView;
    WDLunBoView *_topLunboView;
    UIView *_middleView;
    UILabel *_jifenLabel;
    UIButton *_convertBtn;
    UIWebView *_bottomWebView;
    UIActivityIndicatorView *_activityIndicatorView;
    UIView *popView;
    UIControl *_grayBoard; //蒙板
    UITableView *_addressTableView;
    
    WDLoadAddressModel *_addressModel;
}
@property(nonatomic,strong)NSMutableArray *lunboArray;

@end

@implementation WDJifenMsgViewController

- (NSMutableArray *)lunboArray{
    
    if (! _lunboArray) {
        
        _lunboArray = [NSMutableArray array];
    }
    
    return _lunboArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self _loadNormalAddress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setupNavigation];
    
    [self _loadDatas];
    
    [self _setUI];
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

- (void)_loadDatas{
    
    [WDMainRequestManager requestLoadJifenStoreProductsMsgWithPid:self.pid completion:^(WDCreditProductsModel *pmodel, NSString *error) {
        
        if (error) {
            
            return;
        }
        
        _jifenLabel.text = [NSString stringWithFormat:@"%@积分",pmodel.shopprice];
        
        NSDictionary *images = pmodel.images;
        NSString *ret = images[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = images[@"data"];
            for (NSDictionary *dic in data) {
                
                NSString *img = dic[@"img"];
                NSString *urlImg = [NSString stringWithFormat:@"%@%@",IMAGE_URL,img];
                [self.lunboArray addObject:urlImg];
            }
            
            _topLunboView.imageURLStringsGroup = self.lunboArray;
        }
        
    }];
}

- (void)_setUI{
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:_mainScrollView];
    
    [self _createTopLunboView];
    
    [self _createMiddleMsgView];
    
    [self _createBottomWebView];
}

/** 顶部轮播*/
- (void)_createTopLunboView{
    
    CGFloat lunboH = kScreenWidth * 0.5;
    _topLunboView = [WDLunBoView lunBoViewWithFrame:CGRectMake(0, 0, kScreenWidth, lunboH) delegate:self placeholderImage:[UIImage imageNamed:@"noproduct.png"]];
    _topLunboView.autoScrollTimeInterval = 2.0f;
    _topLunboView.showPageControl = YES;
    _topLunboView.pageControlBottomOffset = -12;
    _topLunboView.pageControlAliment = WDLunBoViewPageContolAlimentCenter;
    _topLunboView.currentPageDotColor = KSYSTEM_COLOR;
    _topLunboView.pageDotColor = [UIColor grayColor];
    [_mainScrollView addSubview:_topLunboView];
}

/** 中间商品信息*/
- (void)_createMiddleMsgView{
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topLunboView.frame), kScreenWidth, 60)];
    [_mainScrollView addSubview:_middleView];
    
    // 分隔线
    UIView *fengeLine = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-1)*0.5, 15, 1, 30)];
    fengeLine.backgroundColor = [UIColor grayColor];
    [_middleView addSubview:fengeLine];
    
    // 金币图标
    UIImageView *coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 20, 16, 20)];
    coinImageView.image = [UIImage imageNamed:@"钱币"];
    [_middleView addSubview:coinImageView];
    
    // 积分数
    CGFloat labelW = CGRectGetMaxX(fengeLine.frame) - 20 - CGRectGetMaxX(coinImageView.frame);
    _jifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coinImageView.frame)+10, 20, labelW, 20)];
    _jifenLabel.font = [UIFont systemFontOfSize:13.0];
    [_middleView addSubview:_jifenLabel];
    
    // 立即兑换
    CGFloat btnW = kScreenWidth*0.5 - 80;
    _convertBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fengeLine.frame)+40, 15, btnW, 30)];
    _convertBtn.backgroundColor = KSYSTEM_COLOR;
    [_convertBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [_convertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _convertBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_convertBtn addTarget:self action:@selector(convertBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_middleView addSubview:_convertBtn];
    
}

/** 立即兑换*/
- (void)convertBtnAction:(UIButton *)sender{
    
    // 创建蒙板
    _grayBoard = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _grayBoard.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [_grayBoard addTarget:self action:@selector(touchBoard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_grayBoard];
    
    popView = [[UIView alloc] initWithFrame:CGRectMake(0, _grayBoard.height, kScreenWidth, 223)];
    popView.backgroundColor = [UIColor whiteColor];
    [_grayBoard addSubview:popView];
    
    popView.transform = CGAffineTransformMakeTranslation(0, -223);
    
    //订单详情label
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 120, 30)];
    detail.text = @"订单详情";
    detail.textColor = [UIColor redColor];
    [popView addSubview:detail];
    
    //分隔线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detail.frame)+5, kScreenWidth, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [popView addSubview:line1];
    
    //选择地址
    _addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), kScreenWidth, 60) style:UITableViewStylePlain];
    _addressTableView.delegate = self;
    _addressTableView.dataSource = self;
    _addressTableView.scrollEnabled = NO;
    _addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [popView addSubview:_addressTableView];
    
    [_addressTableView registerNib:[UINib nibWithNibName:@"WDjifenAddressCell" bundle:nil] forCellReuseIdentifier:@"jifenaddress"];
    
    //分隔线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_addressTableView.frame), kScreenWidth, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [popView addSubview:line2];
    
    //所需积分
    UILabel *jifen = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line2.frame)+15, 100, 30)];
    jifen.text = @"所需积分：";
    [popView addSubview:jifen];
    
    UILabel *jifenCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(jifen.frame), jifen.y, kScreenWidth - CGRectGetMaxX(jifen.frame) - 20 , 30)];
    NSString *textlabel = [NSString stringWithFormat:@"%@",_jifenLabel.text];
    jifenCount.text = [textlabel substringToIndex:textlabel.length - 2];
    jifenCount.textAlignment = NSTextAlignmentRight;
    jifenCount.textColor = [UIColor orangeColor];
    jifenCount.font = [UIFont systemFontOfSize:20.0];
    [popView addSubview:jifenCount];
    
    //分隔线
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(jifenCount.frame)+15, kScreenWidth, 1)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [popView addSubview:line3];
    
    //立即支付按钮
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-200)*0.5, CGRectGetMaxY(line3.frame)+10, 200, 40)];
    payBtn.backgroundColor = KSYSTEM_COLOR;
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    payBtn.layer.cornerRadius = 20;
    [payBtn addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:payBtn];
    
}
/** 点击蒙板事件*/
- (void)touchBoard:(UIControl *)board{
    
    popView.transform = CGAffineTransformIdentity;
    [board removeFromSuperview];
}
/** 立即支付*/
- (void)payButtonClick:(UIButton *)btn{
    
    [WDMainRequestManager requestExchangeJIfenGoodsWithAddressId:self.addressId goodsId:self.pid completion:^(NSString *result, NSString *error) {
       
        if (error) {
            
            SHOW_ALERT(error)
            return ;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"兑换成功，查看订单" preferredStyle:UIAlertControllerStyleAlert];
        
        //用模态的方法显示对话框
        [self presentViewController:alert animated:YES completion:nil];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            popView.transform = CGAffineTransformIdentity;
            [_grayBoard removeFromSuperview];
            
        }];
        [alert addAction:cancel];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            WDMyOrderViewController *orderVC = [[WDMyOrderViewController alloc]init];
            orderVC.istype = 1;
            [self.navigationController pushViewController:orderVC animated:YES];
            
        }];
        [alert addAction:sure];
        
    }];
}

/** 加载默认地址*/
- (void)_loadNormalAddress{
    
    [WDMineManager requestSendAddressWithCompletion:^(NSMutableArray *array, NSString *resultRet, NSString *error) {
        
        if (error) {
            
            _addressModel = nil;
            
        }else{
            
            _addressModel = array[0];
            self.addressId = _addressModel.said;
        }
        
        [_addressTableView reloadData];
    }];
}

/** 底部H5*/
- (void)_createBottomWebView{
    
    _bottomWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_middleView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(_middleView.frame))];
    _bottomWebView.delegate = self; 
    _bottomWebView.scrollView.scrollEnabled = NO;  //禁止滑动
    _bottomWebView.scalesPageToFit = YES;  //网页自适应屏幕
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/creditsinfo.html?access_token=%@&pid=%@",HTML5_URL,token,self.pid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_bottomWebView loadRequest:request];
    
    [_mainScrollView addSubview:_bottomWebView];
    
}

#pragma mark - UIWebViewDelegate
// 数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [_bottomWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGSize websize = [[change objectForKey:@"new"] CGSizeValue];
    
    _bottomWebView.height = websize.height;
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_bottomWebView.frame));
    NSLog(@"contentSize = %@",NSStringFromCGSize(_mainScrollView.contentSize));
    
}

- (void)dealloc
{
    [_bottomWebView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_addressModel) {
        
        return 44;
    }else{
        
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDjifenAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jifenaddress"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.model) {
        
        if (_addressModel) {
            
            cell.userName.text = _addressModel.consignee;
            cell.userMobile.text = _addressModel.mobile;
            cell.userAddress.text = _addressModel.address;
            
        }else{
            
            UITableViewCell *nothingCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nothing"];
            nothingCell.textLabel.text = @"请选择收货地址";
            nothingCell.textLabel.font = [UIFont systemFontOfSize:15.0];
            nothingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return nothingCell;
        }
        
    }
    else{
        
        cell.userName.text = self.model.consignee;
        cell.userMobile.text = self.model.mobile;
        cell.userAddress.text = self.model.address;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDAddressTableVController *addTV = [[WDAddressTableVController alloc]init];
    addTV.sourceType = @"选择收货地址";
    [self.navigationController pushViewController:addTV animated:YES];
}


- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
}

@end
