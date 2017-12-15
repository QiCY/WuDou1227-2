//
//  WDGoodsInfoViewController.m
//  WuDou
//
//  Created by huahua on 16/8/8.
//  Copyright © 2016年 os1. All rights reserved.
//  商品详情页

#import "WDGoodsInfoViewController.h"
#import "WDLunBoView.h"
#import "StarView.h"
#import "WDNearDetailsViewController.h"
#import "WDAccountViewController.h"
#import "WDWKViewController.h"
#import "WDGoodList.h"
#import "WDTabbarViewController.h"
#import "WDLoginViewController.h"
#import "WDUserJudgeCell.h"
#import "WDCellLayout.h"
#import "WDNewsViewController.h"
#import "WDMyJudgementsViewController.h"

#define kEdgeSpace 10

@interface WDGoodsInfoViewController ()<WDLunBoViewDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *_goodsInfoScrolView;
    WDLunBoView *_lunboView;  //轮播视图
    UIView *_goodsinfos;  //商品详细信息
    UILabel *_goodsInfo;
    UILabel *_goodsPrice;
    UILabel *_sellGoods;
    UIButton *rightBtn;
    
    UILabel *_goodsCount;  //选中商品个数
    UIView *_storeInfosView;  //创建店铺信息视图
    UIImageView *_storeLogo;
    UIButton *_storeName;
    StarView *_starView;
    UILabel *_peisongPrice;
    UILabel *_qisongPrice;
    UIImageView *_businessImageView;
    UITableView *_moreInfosTableView;
    
    UIWebView *_webV;  //H5页面
    UIActivityIndicatorView *_activityIndicator;
    UITableView *_judgeTableView;  //评论列表
    UIView *_bottomView;  //底部购物车视图
    UIButton *_seeMoreBtn;  //查看更多
    
    NSMutableArray *_datasArray;
    NSMutableArray *_lunboImages;  //轮播图片
    NSInteger _count;
    NSMutableArray *_bigModelArr;
    NSMutableArray *_goodsInfosArr;
    NSMutableArray *_storeInfosArr;
    
    NSMutableArray *_judgeAllArray;
    NSMutableArray *_judgeArray;  //评论的条数
    NSString *_judgeCount;  //评价数
    NSString *_judgeBili;  //好评率
    
    //底部显示
    UIView *noPriceView;
    UILabel *noGoods;
    UIView *priceView;
    UILabel *price;
    UIView *middleView;
    UIButton *qisongBtn;
    UIButton *gotoCarBtn;
    
    //限度,起送价
    NSInteger _jiaDeJiaGe;
    NSString *_sid;  //店铺id
}

@property(nonatomic,strong)NSMutableArray *tableViewHeightArray;
@property(nonatomic,strong)UIImageView *goodinfoImg;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITableViewCell *lunBoCell;
@end

static NSString *cellId = @"WDUserJudgeCell";

@implementation WDGoodsInfoViewController

- (void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.tableView];
}
- (NSMutableArray *)tableViewHeightArray{
    
    if (_tableViewHeightArray == nil) {
        
        _tableViewHeightArray = [NSMutableArray array];
    }
    
    return _tableViewHeightArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self getCarGoodsData];
    
    
}
- (void)getCarGoodsData{
    NSMutableArray *array = [WDGoodList getAllGood];
    UILabel * countLabel = [self.view viewWithTag:345];
    if ([countLabel.text isEqualToString:@"0"]) {
        
        gotoCarBtn.enabled = NO;
        gotoCarBtn.backgroundColor = [UIColor lightGrayColor];
    }
    if (array.count != 0) {
        
        for (WDChooseGood *model in array) {
            
            if ([self.goodsID isEqualToString:model.goodID]) {
                
                countLabel.text = model.goodNum;
                _goodsCount.text = model.goodNum;
                NSInteger number = [model.goodNum integerValue];
                CGFloat sigleP = [model.goodPrice floatValue];
                price.text = [NSString stringWithFormat:@"￥%.2lf",number * sigleP];
                NSInteger qisong = [model.goodStartFee integerValue];
                
                if ([countLabel.text isEqualToString:@"0"])
                {
                    [middleView bringSubviewToFront:noPriceView];
                    [middleView sendSubviewToBack:priceView];
                    qisongBtn.backgroundColor = [UIColor lightGrayColor];
                    qisongBtn.enabled = NO;
                    [qisongBtn setTitle:@"去结算" forState:UIControlStateNormal];
                    
                    gotoCarBtn.enabled = NO;
                    gotoCarBtn.backgroundColor = [UIColor lightGrayColor];
                    
                }else
                {
                    [middleView bringSubviewToFront:priceView];
                    [middleView sendSubviewToBack:noPriceView];
                    CGFloat totalPrice = [[price.text substringFromIndex:1] floatValue];
                    NSInteger newJiaGe = qisong - totalPrice;
                    if (newJiaGe <= 0)
                    {
                        qisongBtn.enabled = YES;
                        [qisongBtn setTitle:@"结算" forState:UIControlStateNormal];
                        qisongBtn.backgroundColor = KSYSTEM_COLOR;
                        
                        gotoCarBtn.enabled = YES;
                        gotoCarBtn.backgroundColor = KSYSTEM_COLOR;
                    }
                    else
                    {
                        qisongBtn.enabled = YES;
                        qisongBtn.backgroundColor =KSYSTEM_COLOR;
                        [qisongBtn setTitle:@"结算" forState:UIControlStateNormal];
                        gotoCarBtn.enabled = YES;
                        gotoCarBtn.backgroundColor = KSYSTEM_COLOR;

                    }
                    
                }
            }
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self _setupNavigation];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setUI];
    
    [self getCarGoodsData];
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
    
    //  右侧聊天信息按钮
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 28)];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [rightBtn setImage:[UIImage imageNamed:@"消息图标-1"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(chartAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/** 聊天界面*/
- (void)chartAction:(UIButton *)btn{
    
    WDNewsViewController *webVC = [[WDNewsViewController alloc]init];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/message.html?access_token=%@&type=3&sid=%@&pid=%@",HTML5_URL,token,_sid,self.goodsID];
    webVC.requestUrl = urlStr;
    [self.navigationController pushViewController:webVC animated:YES];
}

/* 创建UI界面 **/
- (void)_setUI{
    
    //  请求数据
    [self _requestDatas];
    
    [self createTableView];
    //  创建H5页面

    
    //  创建底部购物栏
    [self _createBottomView];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(haveReceiveMsg:) name:@"HAVEMSG" object:nil];
}

/** 监听通知的方法：改变图标状态*/
- (void)haveReceiveMsg:(NSNotification *)noti{
    
    NSString *result = noti.userInfo[@"RESULT"];
    if ([result isEqualToString:@"1"]) {
        
        //        AudioServicesPlaySystemSound(1003);
        [rightBtn setImage:[UIImage imageNamed:@"xiaoxi11"] forState:UIControlStateNormal];
        
    }else{
        
        [rightBtn setImage:[UIImage imageNamed:@"消息图标-1"] forState:UIControlStateNormal];
    }
}

/** 移除通知*/
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HAVEMSG" object:nil];
}

/** 请求数据*/
- (void)_requestDatas{
    
    NSString * goodID = [[NSUserDefaults standardUserDefaults]objectForKey:@"goodID"];
    self.goodsID = goodID;
    NSLog(@"goodID = %@",goodID);
    
    [WDMainRequestManager requestGoodsMsgWithGoodsId:goodID completion:^(NSMutableArray *array, NSString *error) {
        if (error)
        {
            SHOW_ALERT(error)
            
            return ;
        }
        else{
    
            _bigModelArr = array;
            
            _goodsInfosArr = _bigModelArr[0];
            NSMutableArray *imageArr = [NSMutableArray array];
            for (WDGoodsMsgModel *model in _goodsInfosArr) {
                
                _goodsInfo.text = model.name;
                _goodsPrice.text = [NSString stringWithFormat:@"￥ %@",model.shopprice];
                _sellGoods.text = [NSString stringWithFormat:@"月销%@笔",model.monthlysales];
               
                self.goodsInfosModel = model;
                
                NSDictionary *imageDic = model.images;
                NSString *ret = imageDic[@"ret"];
                if ([ret isEqualToString:@"0"]) {
                    
                    NSArray *imageArray = imageDic[@"data"];
                    for (NSDictionary *dic in imageArray) {
                        
                        NSString *img = dic[@"img"];
                        NSString *imageName = [NSString stringWithFormat:@"%@%@",IMAGE_URL,img];
                        
                        [imageArr addObject:imageName];
                    }
                }
            }
            _lunboImages = imageArr;
            if (_lunboImages.count == 0) {
                
                _lunboView.imageURLStringsGroup = [NSMutableArray arrayWithObject:@"http://pic.baa.bitautotech.com/img/V2img4.baa.bitautotech.com/space/2011/03/04/b1c2da5e-52a6-4d9c-a67c-682a17fb8cb0_735_0_max_jpg.jpg"];
            }else{
                
                _lunboView.imageURLStringsGroup = _lunboImages;
            }
            
            _storeInfosArr = _bigModelArr[1];
            for (WDStoreMsgModel *model in _storeInfosArr) {
                
                [_storeLogo sd_setImageWithURL:[NSURL URLWithString:model.img]];
                [_storeName setTitle:model.name forState:UIControlStateNormal];
                _sid = model.storeid;
                CGFloat pingfen = [model.starcount floatValue];
                _starView.socre = pingfen*2;
                _jiaDeJiaGe = [model.startvalue integerValue];
                _qisongPrice.text = [NSString stringWithFormat:@"起送价 %@",model.startvalue];
                _peisongPrice.text = [NSString stringWithFormat:@"配送费 %@",model.startfee];
                NSInteger isopen = [model.isopen integerValue];
                if (isopen == 0) {
                    
                    _businessImageView.hidden = NO;
                }else{
                    
                    _businessImageView.hidden = YES;
                }
                self.storeInfosModel = model;
            }
        }
        
        [self.tableView reloadData];
        
    }];
    /*
    [WDMainRequestManager requestJudgementsWithPid:goodID completion:^(NSMutableArray *array, NSString *error) {
       
        if (error) {
            
//            SHOW_ALERT(error)
            //  暂无评论
            UILabel *noJudgement = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-100)*0.5, CGRectGetMaxY(_moreInfosTableView.frame)+ 25, 100, 20)];
            noJudgement.backgroundColor = [UIColor clearColor];
            noJudgement.text = @"暂无评论";
            noJudgement.tag = 123;
            noJudgement.textColor = [UIColor grayColor];
            noJudgement.textAlignment = NSTextAlignmentCenter;
            noJudgement.font = [UIFont systemFontOfSize:15.0];
            [_goodsInfoScrolView addSubview:noJudgement];
            
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
        
        _judgeTableView.frame = CGRectMake(0, CGRectGetMaxY(_moreInfosTableView.frame)+1, kScreenWidth, tableViewH+100);
        
        _goodsInfoScrolView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_judgeTableView.frame)+ _bottomView.height + 20);
        
        [_judgeTableView reloadData];
        
    }];
     */
}

/* 创建顶部轮播视图 **/
- (WDLunBoView *)_createTopLunboView{
    
    
    if (!_lunboView) {
        CGFloat lunboH =kScreenHeight -268 -64 - 50 ;
        _lunboView = [WDLunBoView lunBoViewWithFrame:CGRectMake(0, 0, kScreenWidth, lunboH) delegate:self placeholderImage:[UIImage imageNamed:@"noproduct.png"]];
        _lunboView.autoScrollTimeInterval = 2.0f;
        _lunboView.showPageControl = YES;
        _lunboView.pageControlBottomOffset = -12;
        _lunboView.pageControlAliment = WDLunBoViewPageContolAlimentCenter;
        _lunboView.currentPageDotColor = KSYSTEM_COLOR;
        _lunboView.pageDotColor = [UIColor grayColor];
        
    }
    
    return _lunboView;
    
}

- (void)clearCellSubView:(UITableViewCell *)cell{
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
}
/* 创建商品详情视图 **/
- (UIView *)_createGoodsInfosView
{
    if (!_goodsinfos) {
        _goodsinfos = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        _goodsinfos.backgroundColor = [UIColor whiteColor];
        
        //  商品信息
        _goodsInfo = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, _goodsinfos.bounds.size.width - 20, 20)];
        _goodsInfo.font = [UIFont systemFontOfSize:16.0];
        //    _goodsInfo.text = @"美国进口苹果1.5KG装";
        [_goodsinfos addSubview:_goodsInfo];
        
        //  商品价格
        _goodsPrice = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_goodsInfo.frame)+kEdgeSpace, 120, 30)];
        _goodsPrice.font = [UIFont systemFontOfSize:20];
        _goodsPrice.text = [NSString stringWithFormat:@"￥ %.2lf",7.80];
        _goodsPrice.textColor = [UIColor redColor];
        [_goodsinfos addSubview:_goodsPrice];
        
        //  月销售量
        _sellGoods = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_goodsPrice.frame)+kEdgeSpace*2, CGRectGetMaxY(_goodsInfo.frame)+kEdgeSpace*2, 100, 20)];
        _sellGoods.font = [UIFont systemFontOfSize:13];
        _sellGoods.text = [NSString stringWithFormat:@"月销%d笔",63];
        _sellGoods.textColor = [UIColor lightGrayColor];
        [_goodsinfos addSubview:_sellGoods];
        
        //  选择购买商品数目
        UIView *choiceGoodsCount = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 110, CGRectGetMaxY(_goodsInfo.frame)+kEdgeSpace, 100, 30)];
        // 减号按钮
        UIButton *subtractBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 1, 28, 28)];
        [subtractBtn setBackgroundImage:[UIImage imageNamed:@"减.png"] forState:UIControlStateNormal];
        [subtractBtn addTarget:self action:@selector(subtractBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [choiceGoodsCount addSubview:subtractBtn];
        
        // 选中的商品数目
        _goodsCount = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(subtractBtn.frame), 1, 29, 28)];
        _goodsCount.font = [UIFont systemFontOfSize:15];
        _goodsCount.text = [NSString stringWithFormat:@"%d",0];
        _goodsCount.textAlignment = NSTextAlignmentCenter;
        [choiceGoodsCount addSubview:_goodsCount];
        
        // 加号按钮
        UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_goodsCount.frame), 1, 28, 28)];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"加.png"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [choiceGoodsCount addSubview:addBtn];
        
        [_goodsinfos addSubview:choiceGoodsCount];
        
    }
    
    return _goodsinfos;
   
}

//  减号按钮
- (void)subtractBtnAction:(UIButton *)subtract{
    
    NSInteger count = [_goodsCount.text integerValue];
    UILabel * countLabel = [self.view viewWithTag:345];
    if (count > 0)
    {
        count --;
        if (count == 0) {
            [middleView sendSubviewToBack:priceView];
            [middleView bringSubviewToFront:noPriceView];
            _goodsCount.text = [NSString stringWithFormat:@"0"];
            countLabel.text = @"0";
            
            qisongBtn.enabled = NO;
            qisongBtn.backgroundColor = [UIColor lightGrayColor];
            [qisongBtn setTitle:@"去结算" forState:UIControlStateNormal];
            
            gotoCarBtn.enabled = NO;
            gotoCarBtn.backgroundColor = [UIColor lightGrayColor];
            
            [WDGoodList deleteGoodWithGoodsId:[self.goodsInfosModel.pid intValue]];  // 当减到0时删除该商品id下的记录
            return;
        }
        WDChooseGood * good = [[WDChooseGood alloc]init];
        good.goodName = self.goodsInfosModel.name;
        good.goodPrice = self.goodsInfosModel.shopprice;
        good.goodNum = [NSString stringWithFormat:@"%ld",count];
        good.goodID = self.goodsID;
        good.goodImage = self.goodsImage;
        good.goodStartFee = self.storeInfosModel.startvalue;
        good.goodDistributePrice = self.storeInfosModel.startfee;
        good.shopName = self.storeInfosModel.name;
        good.shopID = self.storeInfosModel.storeid;
        [WDGoodList upDateGood:good];  // 更新记录
        
        _goodsCount.text = [NSString stringWithFormat:@"%ld",(long)count];
        CGFloat allCount = [self.goodsInfosModel.shopprice floatValue] * count;
        price.text = [NSString stringWithFormat:@"￥%.2lf",allCount];
        countLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
        [middleView sendSubviewToBack:noPriceView];
        [middleView bringSubviewToFront:priceView];
        NSInteger newJiaGe = _jiaDeJiaGe - allCount;
        if (newJiaGe <= 0)
        {
            qisongBtn.enabled = YES;
            qisongBtn.backgroundColor =KSYSTEM_COLOR ;
            [qisongBtn setTitle:@"结算" forState:UIControlStateNormal];
            
            gotoCarBtn.enabled = YES;
            gotoCarBtn.backgroundColor =KSYSTEM_COLOR ;
        }
        else
        {
            qisongBtn.enabled = YES;
            gotoCarBtn.backgroundColor =KSYSTEM_COLOR ;
            [qisongBtn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
            
            gotoCarBtn.enabled = YES;
            gotoCarBtn.backgroundColor =KSYSTEM_COLOR ;
        }
    }
    else
    {
        [middleView sendSubviewToBack:priceView];
        [middleView bringSubviewToFront:noPriceView];
        _goodsCount.text = [NSString stringWithFormat:@"0"];
        countLabel.text = @"0";
        
        qisongBtn.enabled = NO;
        qisongBtn.backgroundColor = [UIColor lightGrayColor];
        [qisongBtn setTitle:@"去结算" forState:UIControlStateNormal];
        
        gotoCarBtn.enabled = NO;
        gotoCarBtn.backgroundColor = [UIColor lightGrayColor];
        
        [WDGoodList deleteGoodWithGoodsId:[self.goodsInfosModel.pid intValue]];  // 当减到0时删除该商品id下的记录
    }
    
}

//  加号按钮
- (void)addBtnAction:(UIButton *)add{
    
    NSInteger count = [_goodsCount.text integerValue];
    UILabel * countLabel = [self.view viewWithTag:345];
    if (count >= 0) {
        
        if (count == 0) {
            count ++;
            WDChooseGood * good = [[WDChooseGood alloc]init];
            good.goodName = self.goodsInfosModel.name;
            good.goodPrice = self.goodsInfosModel.shopprice;
            good.goodNum = [NSString stringWithFormat:@"%ld",count];
            good.goodID = self.goodsID;
            good.goodImage = self.goodsImage;
            good.goodStartFee = self.storeInfosModel.startvalue;
            good.goodDistributePrice = self.storeInfosModel.startfee;
            good.shopName = self.storeInfosModel.name;
            good.shopID = self.storeInfosModel.storeid;
            [WDGoodList insertGood:good];
            NSLog(@"%@--%@--%@--%@--%@--%@--",good.goodName,good.goodPrice,good.goodNum,good.goodID,good.shopName,good.shopID);
        }else{
            count ++;
            
            WDChooseGood * good = [[WDChooseGood alloc]init];
            good.goodName = self.goodsInfosModel.name;
            good.goodPrice = self.goodsInfosModel.shopprice;
            good.goodNum = [NSString stringWithFormat:@"%ld",count];
            good.goodID = self.goodsID;
            good.goodImage = self.goodsImage;
            good.goodStartFee = self.storeInfosModel.startvalue;
            good.goodDistributePrice = self.storeInfosModel.startfee;
            good.shopName = self.storeInfosModel.name;
            good.shopID = self.storeInfosModel.storeid;
            [WDGoodList upDateGood:good];  // 更新记录
        }
        
        _goodsCount.text = [NSString stringWithFormat:@"%ld",(long)count];
        CGFloat allCount = [self.goodsInfosModel.shopprice floatValue] * count;
        price.text = [NSString stringWithFormat:@"￥%.2lf",allCount];
        [middleView sendSubviewToBack:noPriceView];
        [middleView bringSubviewToFront:priceView];
        countLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
        NSInteger newJiaGe = _jiaDeJiaGe - allCount;
        if (newJiaGe <= 0)
        {
            qisongBtn.enabled = YES;
            qisongBtn.backgroundColor = KSYSTEM_COLOR;
            [qisongBtn setTitle:@"结算" forState:UIControlStateNormal];
            
            gotoCarBtn.enabled = YES;
            gotoCarBtn.backgroundColor =KSYSTEM_COLOR ;
        }
        else
        {
//            qisongBtn.enabled = NO;
//            qisongBtn.backgroundColor = [UIColor lightGrayColor];
//            [qisongBtn setTitle:[NSString stringWithFormat:@"差￥%ld起送",(long)newJiaGe] forState:UIControlStateNormal];
            qisongBtn.enabled = YES;
            qisongBtn.backgroundColor = KSYSTEM_COLOR;
            [qisongBtn setTitle:@"结算" forState:UIControlStateNormal];
            
            gotoCarBtn.enabled = YES;
            gotoCarBtn.backgroundColor =KSYSTEM_COLOR ;
//            gotoCarBtn.enabled = NO;
//            gotoCarBtn.backgroundColor = [UIColor lightGrayColor];
        }
        
    }
    else
    {
        [middleView sendSubviewToBack:priceView];
        [middleView bringSubviewToFront:noPriceView];
        
        _count = count;
        countLabel.text = [NSString stringWithFormat:@"%ld",(long)_count];
        
        qisongBtn.enabled = NO;
        qisongBtn.backgroundColor = [UIColor lightGrayColor];
        [qisongBtn setTitle:@"去结算" forState:UIControlStateNormal];
        
        gotoCarBtn.enabled = NO;
        gotoCarBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
}

/* 创建店铺信息视图 **/
- (UIView *)_createStoreInfosView{
    if (!_storeInfosView) {
        _storeInfosView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        _storeInfosView.backgroundColor = [UIColor whiteColor];
        
        // 店铺Logo
        _storeLogo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        _storeLogo.image = [UIImage imageNamed:@"品牌图标.png"];
        [_storeInfosView addSubview:_storeLogo];
        
        // 店铺名称
        _storeName = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_storeLogo.frame)+kEdgeSpace, 10, 180, 30)];
        _storeName.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _storeName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _storeName.backgroundColor = [UIColor clearColor];
        [_storeName setTitle:@"绿林水果专卖店" forState:UIControlStateNormal];
        [_storeName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //    [_storeName setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [_storeName addTarget:self action:@selector(jumpToStoreInfo:) forControlEvents:UIControlEventTouchUpInside];
        [_storeInfosView addSubview:_storeName];
        
        //  星星视图
        _starView = [[StarView alloc]initWithFrame:CGRectMake(kScreenWidth-100, 10, 90, 18)];
        _starView.socre = 7.0;
        [_storeInfosView addSubview:_starView];
        
        // 配送费
        _peisongPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_storeLogo.frame)+kEdgeSpace, CGRectGetMaxY(_storeName.frame), 75, 20)];
        _peisongPrice.font = [UIFont systemFontOfSize:13];
        _peisongPrice.text = [NSString stringWithFormat:@"配送费￥ "];
        _peisongPrice.textColor = [UIColor lightGrayColor];
        [_storeInfosView addSubview:_peisongPrice];
        
        // 分隔线
        UIImageView *fengeLine = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_peisongPrice.frame), CGRectGetMaxY(_storeName.frame), 1, 20)];
        fengeLine.backgroundColor = [UIColor lightGrayColor];
        [_storeInfosView addSubview:fengeLine];
        
        // 起送价
        _qisongPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fengeLine.frame)+5, CGRectGetMaxY(_storeName.frame), 120, 20)];
        _qisongPrice.font = [UIFont systemFontOfSize:13];
        _qisongPrice.text = [NSString stringWithFormat:@"起送价￥ "];
        _qisongPrice.textColor = [UIColor lightGrayColor];
        [_storeInfosView addSubview:_qisongPrice];
        
        // 营业中
        _businessImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-10-(68*20)/34.0, CGRectGetMaxY(_storeName.frame), (68*20)/34.0, 20)];
        _businessImageView.image = [UIImage imageNamed:@"营业中.png"];
        [_storeInfosView addSubview:_businessImageView];
        
        
    }
    return _storeInfosView;
    
    
}
- (void)jumpToStoreInfo:(UIButton *)btn{
    
//    WDNearDetailsViewController *detailVC = [[WDNearDetailsViewController alloc]init];
//    
//    WDStoreInfosModel * nearStore = _storeInfosArr[0];
//    detailVC.storeId = nearStore.storeid;
//    [WDRequestManager saveStrData:nearStore.storeid withStr:@"shopID"];
//    [self.navigationController pushViewController:detailVC animated:YES];
}

/** 创建更多详情*/
- (void)_createMoreInfosView{
    
    _moreInfosTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_storeInfosView.frame)+kEdgeSpace, kScreenWidth, 44) style:UITableViewStylePlain];
    _moreInfosTableView.delegate = self;
    _moreInfosTableView.dataSource = self;
    _moreInfosTableView.scrollEnabled = NO;
    _moreInfosTableView.showsVerticalScrollIndicator = NO;
    [_moreInfosTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_goodsInfoScrolView addSubview:_moreInfosTableView];
}

- (void)createGoodInfoImg:(UITableViewCell *)cell{
    _goodinfoImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2,12, 200, 20)];
    _goodinfoImg.backgroundColor = [UIColor whiteColor];
    _goodinfoImg.image = [UIImage imageNamed:@"商品详情"];
    [cell addSubview:_goodinfoImg];
}
/* 创建H5页面 **/
- (UIWebView *)_createWebView{
    
   
    if (!_webV) {
        _webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1000)];
        _webV.delegate = self;
        _webV.backgroundColor = [UIColor whiteColor];
        _webV.scrollView.scrollEnabled = NO;//禁止滑动
        _webV.scrollView.delegate = self;
        //        _webV.scalesPageToFit = YES;
//        _webV.scrollView.bounces=NO;
        
//        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
        
//        http://admin.ttsxin.com/productsinfo/?pid=970
        NSString *urlStr = [NSString stringWithFormat:@"http://admin.ttsxin.com/productsinfo/?pid=%@",self.goodsID];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webV loadRequest:request];
       
    }
     return _webV;

}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        CGSize size = [_webV sizeThatFits:CGSizeZero];
//        NSLog(@"size height %f",size.height);
//    }
//}

/** 创建评论列表*/
- (void)_createjudgeTableView{
    
    _judgeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _judgeTableView.delegate = self;
    _judgeTableView.dataSource = self;
    _judgeTableView.scrollEnabled = NO;
    [_judgeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_judgeTableView registerNib:[UINib nibWithNibName:@"WDUserJudgeCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    [_goodsInfoScrolView addSubview:_judgeTableView];
}

//  用户评价
- (void)seeMoreCommens:(UIButton *)seeMore{
    
    WDMyJudgementsViewController *webVC = [[WDMyJudgementsViewController alloc]init];
    webVC.navTitle = @"用户评价";
    webVC.cellState = 1;
    webVC.pid = self.goodsID;
    [self.navigationController pushViewController:webVC animated:YES];
}

/** 创建底部购物栏*/
- (void)_createBottomView{
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 49 - 64, kScreenWidth, 49)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    //  购物车图标
    UIImageView *shoppingCar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9.5, 34.5, 30)];
    shoppingCar.image = [UIImage imageNamed:@"购物车2"];
    [_bottomView addSubview:shoppingCar];
    
    //  显示数目
    CGFloat itemW = 17;
    UILabel *count = [[UILabel alloc]initWithFrame:CGRectMake(shoppingCar.width - itemW, 0, itemW, itemW)];
    count.backgroundColor = [UIColor clearColor];
    count.tag = 345;
    count.text = @"0";
    count.textAlignment = NSTextAlignmentCenter;
    count.textColor = [UIColor whiteColor];
    count.font = [UIFont systemFontOfSize:13.0];
    [shoppingCar addSubview:count];
    
    UIButton *shoppingCarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 49)];
    shoppingCarBtn.backgroundColor = [UIColor clearColor];
//    [shoppingCarBtn addTarget:self action:@selector(addToShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:shoppingCarBtn];
    
    //  右边的起送按钮
    qisongBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 0, 80, 49)];
    [qisongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    qisongBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [qisongBtn addTarget:self action:@selector(qisongBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:qisongBtn];
    
    //  前往购物车按钮
    gotoCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 151, 0, 70, 49)];
    gotoCarBtn.backgroundColor = KSYSTEM_COLOR;
    [gotoCarBtn setTitle:@"去购物车" forState:UIControlStateNormal];
    [gotoCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    gotoCarBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [gotoCarBtn addTarget:self action:@selector(gotoCarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:gotoCarBtn];
    
    //  中间的view
    middleView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shoppingCarBtn.frame), 0, kScreenWidth - 151 - shoppingCarBtn.width, 49)];
    
    middleView.backgroundColor = [UIColor whiteColor];
    
    [self _setHaveGoods];
    [self _setNoHaveGoods];
    
    if ([count.text isEqualToString:@"0"])
    {
        [middleView bringSubviewToFront:noPriceView];
        [middleView sendSubviewToBack:priceView];
        qisongBtn.backgroundColor = [UIColor lightGrayColor];
        qisongBtn.enabled = NO;
        [qisongBtn setTitle:@"去结算" forState:UIControlStateNormal];
        
    }else
    {
        [middleView bringSubviewToFront:priceView];
        [middleView sendSubviewToBack:noPriceView];
        NSInteger newJiaGe = _jiaDeJiaGe - [self.goodsInfosModel.shopprice integerValue];
        if (newJiaGe <= 0)
        {
            qisongBtn.enabled = YES;
            [qisongBtn setTitle:@"结算" forState:UIControlStateNormal];
            qisongBtn.backgroundColor = KSYSTEM_COLOR;
        }
        else
        {
            qisongBtn.enabled = NO;
            qisongBtn.backgroundColor = [UIColor lightGrayColor];
            [qisongBtn setTitle:[NSString stringWithFormat:@"差￥%ld起送",(long)newJiaGe] forState:UIControlStateNormal];
        }
        
    }
    
    [_bottomView addSubview:middleView];
    
    //  分隔线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(shoppingCarBtn.width, 0, 1, 49)];
    lineView.backgroundColor = kViewControllerBackgroundColor;
    [_bottomView addSubview:lineView];
    
    [self.view addSubview:_bottomView];
}

-(void)_setHaveGoods
{
    noPriceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, middleView.frame.size.width, middleView.frame.size.height)];
    noPriceView.backgroundColor = [UIColor whiteColor];
    
    noGoods = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, middleView.width - 20, 49)];
    noGoods.numberOfLines = 0;
    noGoods.font = [UIFont systemFontOfSize:15.0];
    noGoods.text = @"购物车是空的";
    noGoods.backgroundColor = [UIColor whiteColor];
    [noPriceView addSubview:noGoods];
    
    [middleView addSubview:noPriceView];
}


-(void)_setNoHaveGoods
{
    priceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, middleView.frame.size.width, middleView.frame.size.height)];
    priceView.backgroundColor = [UIColor whiteColor];
    
    UILabel *heji = [[UILabel alloc]initWithFrame:CGRectMake(5, 4.5, 40, 20)];
    heji.text = @"合计:";
    heji.font = [UIFont systemFontOfSize:13.0];
    [priceView addSubview:heji];
    
    price = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(heji.frame), 4.5, middleView.width - heji.width-5, 20)];
    price.font = [UIFont systemFontOfSize:14.0];
    price.textColor = [UIColor redColor];
    [priceView addSubview:price];
    
    UILabel *peisong = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(heji.frame), middleView.width-10, 20)];
    peisong.text = @"（不含配送费）";
    peisong.font = [UIFont systemFontOfSize:13.0];
    [priceView addSubview:peisong];
    
    [middleView addSubview:priceView];
}

- (void)qisongBtnAction:(UIButton *)qisong
{
    [WDMineManager requestLoginEnabledWithCompletion:^(NSString *resultRet) {
        
        if ([resultRet isEqualToString:@"0"])
        {
            WDAccountViewController * accountVC = [[WDAccountViewController alloc]init];
            
            NSString *str = [NSString stringWithFormat:@"%@,%@",self.goodsID,_goodsCount.text];
            accountVC.orderinfo = str;
            NSMutableArray * dataArray = [WDGoodList getGoodWithGoodID:_goodsID];
            accountVC.dataArray = dataArray;
            [self.navigationController pushViewController:accountVC animated:YES];
        }
        else
        {
            WDLoginViewController *loginVC = [[WDLoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }];
    
}
- (void)gotoCarBtnAction:(UIButton *)btn{
    
    WDTabbarViewController *tabbar = [[WDTabbarViewController alloc]init];
    tabbar.selectedIndex = 2;
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    window.rootViewController = tabbar;
}

#pragma mark - WDLunBoViewDelegate
- (void)cycleScrollView:(WDLunBoView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    NSLog(@"---点击了第%ld张图片", (long)index);
//    WDNearDetailsViewController *nearVC = [[WDNearDetailsViewController alloc]init];
//    [self.navigationController pushViewController:nearVC animated:YES];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return 6;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 1;
    }
    
    
    if (tableView == _moreInfosTableView) {
        
        return 1;
    }if (tableView == _judgeTableView) {
        
        if (_judgeArray.count > 4) {
            
            return 4;
        }else{
            
            return _judgeArray.count;
        }
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
       
        if (indexPath.section == 0) {
            if (!_lunBoCell) {
                _lunBoCell = [[UITableViewCell alloc] init];
                [_lunBoCell.contentView addSubview:[self _createTopLunboView]];
            }
            return _lunBoCell;
            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            for (UIView *subView in cell.contentView.subviews) {
//                [subView removeFromSuperview];
//            }
//
//            return cell;
        }
        if (indexPath.section == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             [self getCarGoodsData];
            [cell.contentView addSubview:[self _createGoodsInfosView]];
           
            return cell;
        }if (indexPath.section == 2) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:[self _createStoreInfosView]];
            return cell;
        }if (indexPath.section == 3) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"查看更多用户评价";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }if (indexPath.section == 4) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self createGoodInfoImg:cell];
            return cell;
        }if (indexPath.section == 5) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:[self _createWebView]];
            return cell;
        }
    }
    
    if (tableView == _moreInfosTableView) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cell.height)];
        textLab.text = @"查看更多用户评价";
        textLab.textAlignment = NSTextAlignmentLeft;
        textLab.font = [UIFont systemFontOfSize:16.0];
        [cell.contentView addSubview:textLab];
        
        return cell;
    }
    if (tableView == _judgeTableView) {
        
        WDUserJudgeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WDCellLayout *layout = _judgeArray[indexPath.row];
        cell.layout = layout;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tableView == tableView) {
        if (indexPath.section == 3) {
            WDWKViewController *webVC = [[WDWKViewController alloc]init];
            webVC.navTitle = @"更多商品评论";
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
            NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/productsinfo.html?access_token=%@&pid=%@",HTML5_URL,token,self.goodsID];
            webVC.urlString = urlStr;
            webVC.goodID = self.goodsID;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _judgeTableView) {
        
        WDCellLayout *layout = _judgeArray[indexPath.row];
        
        return layout.cellHeight;
    }
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            CGFloat lunboH =kScreenHeight -268 -64 - 50;
            return lunboH;
            return kScreenWidth/2+200;
        }
        if (indexPath.section == 1) {
            return 80;
        }if (indexPath.section == 2) {
            return 80;
        }if (indexPath.section == 3) {
            return 44;
        }if(indexPath.section == 4){
            return 44;
        }else{
            NSLog(@"_wev height is %f",_webV.frame.size.height);
            return _webV.frame.size.height;
        }
    }
    return 44;
}

//  ----------------------------- 头视图 -----------------------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == _judgeTableView) {
        
        UIView *heardV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        
        countLabel.text = [NSString stringWithFormat:@"用户评价（%@）",_judgeCount];
        countLabel.font = [UIFont systemFontOfSize:16.0];
        [heardV addSubview:countLabel];
        
        UILabel *judgeLv = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 20)];
        
        judgeLv.text = [NSString stringWithFormat:@"好评率%@",_judgeBili];
        judgeLv.font = [UIFont systemFontOfSize:15.0];
        judgeLv.textColor = [UIColor lightGrayColor];
        [heardV addSubview:judgeLv];
        
        return heardV;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == _judgeTableView) {
        
        return 60;
    }
    if (tableView == self.tableView) {
        if (section == 2 || section==3) {
            return kEdgeSpace;
        }
        return 0;
    }
    
    return 0;
}

//  ----------------------------- 尾视图 -----------------------------
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (tableView == _judgeTableView) {
        
        _seeMoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 20)];
        
        [_seeMoreBtn setTitle:@"点击查看更多评价 >>" forState:UIControlStateNormal];
        _seeMoreBtn.backgroundColor = kViewControllerBackgroundColor;
        [_seeMoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_seeMoreBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        _seeMoreBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        [_seeMoreBtn addTarget:self action:@selector(seeMoreCommens:) forControlEvents:UIControlEventTouchUpInside];
        
        return _seeMoreBtn;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView == _judgeTableView) {
        
        return 40;
    }
    
    return 0;
}

#pragma mark - UIWebViewDelegate
//加载网页动画
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [_activityIndicator startAnimating];  //开始加载数据
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    CGFloat documentWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('loading').offsetWidth"] floatValue];
    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
    NSLog(@"documentSize = {%f, %f}", documentWidth, documentHeight);
    _webV.userInteractionEnabled = NO;
    _webV.frame = CGRectMake(0, 0, kScreenWidth, documentHeight);
    [self.tableView reloadData];
}


@end
