//
//  WDFruitsVegetablesViewController.m
//  WuDou
//
//  Created by huahua on 16/11/29.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDFruitsVegetablesViewController.h"
#import "WDNearDetailsViewController.h"
#import "WDListRihtTableViewCell.h"
#import "WDNearDetailsTableViewCell.h"
#import "WDMinShopCarTableViewCell.h"
#import "WDAccountViewController.h"
#import "WDGoodsInfoViewController.h"
#import "WDGetCouponController.h"
#import "WDTabbarViewController.h"
#import "WDLoginViewController.h"
#import "WDWebViewController.h"
#import "WDNewsViewController.h"

#import "WDGoodList.h"
#import "WDFruitVegetableBtn.h"

@interface WDFruitsVegetablesViewController ()<UITableViewDataSource,UITableViewDelegate,NearCellDelegate>
{
    NSMutableArray * _bigClassArr;
    NSMutableArray * _goodsArr;
    NSMutableArray * _goodArray;
    
    NSMutableArray *_bigInfosArray;  //总的信息数组，包含店铺信息和分类信息
    NSMutableArray *_storeInfosArray;  //顶部店铺信息
    NSMutableArray *_storeCatesArray;  //店铺分类信息
    NSMutableArray *_cateGoodsArray;  //分类商品列表
    NSMutableArray *_popTableViewArray;  //底部弹出的购物车列表数组
    NSInteger allCount;
    //选中的数量
    NSMutableArray * _selectArr;
    
    //导航栏
    UIView * _navView;
    UIButton *rightBtn;
    //购物车详情
    UIView * bigView;
    UIView * backView;
    UIImageView * newImage;
    UITableView * carTableView;
    //提交按钮
    UIButton * yesBtn;
    UIButton *gotoCarBtn;
    //是否收藏
    BOOL _isLike;
    UIImageView * _likeImage;
    
    //领取优惠券按钮
    UIButton *_getCouponBtn;
    //此时点击左边对应的cateId
    NSString * _cateID;
    //弹出详情商品的个数
    UILabel * _numLab;
    //所有商品价格
    float _allMoney;
    //商品起送价
    NSString * _startPrice;
    //是否有优惠券
    BOOL _isHavaCoupon;
    //净菜区/配送区
    NSString *_sate;
    
    //绿色指示条
    UIView *_greenIndicator;
}
@property(nonatomic,assign)NSInteger selectIndex;  //当前选中的行
@property(nonatomic,assign)NSInteger allNumber;
@property(nonatomic,assign)BOOL isDidSelect;
//选中多少商品
/** 当前选中的按钮 */
@property(nonatomic,strong)NSString *peisong;
@property (nonatomic, weak) UIButton *selectedButton;
@property(nonatomic,assign)CGFloat beginY,endY;
@property(nonatomic,strong)UILabel *shopLab;
@property(nonatomic,strong)WDStoreInfosModel *storeModel;

@end

@implementation WDFruitsVegetablesViewController

-(void)viewWillAppear:(BOOL)animated
{
    // 显示导航栏
    self.navigationController.navigationBarHidden = NO;
    
    [self setNavTabUI];
    [self _requestDatasWithSate:_sate];
    [self showStoreInfoView:YES];
    _allNumber = 0;
    allCount = 0;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [SVProgressHUD dismiss];
    
    
}


//商铺购物详情
-(NSMutableArray *)getSelectGood
{
    NSString * shopID = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopID"];
    NSMutableArray * shopArr = [WDGoodList getGoodWithStoreID:shopID];
    return shopArr;
}

//计算全部商品价格
-(void)getAllMoney
{
    _allMoney = 0.0;
    NSMutableArray * shopArr = [self getSelectGood];
    for ( WDChooseGood * model in shopArr )
    {
        NSString * goodMoney = model.goodPrice;
        NSString * goodNum = model.goodNum;
        _startPrice = model.goodStartFee;
        _allMoney = [goodNum floatValue] * [goodMoney floatValue] + _allMoney;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",_allMoney];
    if (_allMoney>0)
    {
        yesBtn.userInteractionEnabled = YES;
        yesBtn.backgroundColor = KSYSTEM_COLOR;
        gotoCarBtn.userInteractionEnabled = YES;
        gotoCarBtn.backgroundColor = KSYSTEM_COLOR;
        [yesBtn setTitle:@"选好了" forState:UIControlStateNormal];
    }
    else
    {
        yesBtn.userInteractionEnabled = NO;
        yesBtn.backgroundColor = [UIColor lightGrayColor];
        gotoCarBtn.userInteractionEnabled = NO;
        gotoCarBtn.backgroundColor = [UIColor lightGrayColor];
         [yesBtn setTitle:@"选好了" forState:UIControlStateNormal];
//        NSString * title = [NSString stringWithFormat:@"差¥%.2f",[_startPrice floatValue] - _allMoney];
//         NSString * title = [NSString stringWithFormat:@"¥%.2f",[_peisong floatValue] + _allMoney];
//        [yesBtn setTitle:title forState:UIControlStateNormal];
    }
    
    
    
}


-(void)dealloc{
    
    _allNumber = 0;
    allCount = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HAVEMSG" object:nil];
}



- (void)viewDidLoad
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    _selectArr = [[NSMutableArray alloc]init];
    NSInteger integ = [self.normalBtnClicked integerValue];
    _sate = [NSString stringWithFormat:@"%ld",integ+1];;
    _topView.backgroundColor = KSYSTEM_COLOR;
    self.allMoneyLabel.text = @"0";
    
    [self.rightTableView registerNib:[UINib nibWithNibName:@"WDListRihtTableViewCell" bundle:nil] forCellReuseIdentifier:@"rcell"];
    self.rightTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"WDNearDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"Ncell"];
    self.leftTableView.backgroundColor = kViewControllerBackgroundColor;
    self.leftTableView.tableHeaderView.backgroundColor = [UIColor lightGrayColor];
    self.leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //  创建绿色指示器
    _greenIndicator = [[UIView alloc] init];
    _greenIndicator.backgroundColor = KSYSTEM_COLOR;
    _greenIndicator.height = 2;
    _greenIndicator.y = self.exchangeView.height - _greenIndicator.height;
    
    // 内部的子标签
    NSArray *titles = @[@"蔬菜区", @"净菜区"];
    NSArray *images = @[@"shucaiqu",@"jingcaiqu"];
    CGFloat width = kScreenWidth / titles.count;
    CGFloat height = self.exchangeView.height;
    NSInteger normalClickBtn = [self.normalBtnClicked integerValue];
    
    for (NSInteger i = 0; i<titles.count; i++) {
        WDFruitVegetableBtn *button = [[WDFruitVegetableBtn alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        button.tag = i+101;
        button.text = titles[i];
        button.imageName = images[i];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.exchangeView addSubview:button];
        
        // 默认点击按钮
        if (i == normalClickBtn) {
            button.enabled = NO;
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
//            [button.titleLabel sizeToFit];
            _greenIndicator.width = 80;
            _greenIndicator.centerX = button.centerX;
        }
    }
    
    [self.exchangeView addSubview:_greenIndicator];
    
    // 分隔线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-1)*0.5, 0, 1, self.exchangeView.height)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self.exchangeView addSubview:lineView];
    
    //提交按钮
    yesBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 70, kScreenHeight - 104, 70, 40)];
    [self getAllMoney];
    yesBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [yesBtn addTarget:self action:@selector(yesClick) forControlEvents:UIControlEventTouchUpInside];
    [yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:yesBtn];
    
    //  前往购物车按钮
    gotoCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 141, kScreenHeight - 104, 70, 40)];
    gotoCarBtn.backgroundColor = KSYSTEM_COLOR;
    [gotoCarBtn setTitle:@"去购物车" forState:UIControlStateNormal];
    [gotoCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    gotoCarBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [gotoCarBtn addTarget:self action:@selector(gotoCarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gotoCarBtn];
    
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

//  按钮的点击方法
- (void)buttonClick:(UIButton *)button {
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    [_leftTableView setContentOffset: CGPointMake(0, 0)];
    [_rightTableView setContentOffset:CGPointMake(0, 0)];
    _selectIndex = 0;
    if (_topView.hidden) {
        
        [self showStoreInfoView:YES];
    }
    //  让绿色指示器动态地与按钮贴合
    [UIView animateWithDuration:0.25 animations:^{
        _greenIndicator.width = 80;
        _greenIndicator.centerX = button.centerX;
    }];
    
    // 刷新数据

    _sate = [NSString stringWithFormat:@"%ld",button.tag-100];
    
    [self _requestDatasWithSate:_sate];
}

/** 领取优惠券按钮*/
- (void)_createGetCouponBtn{
    
    if (_isHavaCoupon == 1) {
        
        _getCouponBtn = [[UIButton alloc]initWithFrame:self.getCoupon.frame];
        self.getCoupon.hidden = NO;
        _getCouponBtn.backgroundColor = [UIColor clearColor];
        [_getCouponBtn addTarget:self action:@selector(getCouponAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_getCouponBtn];
    }else{
        _getCoupon.hidden = YES;
    }
}
- (void)getCouponAction:(UIButton *)btn{
    
    WDGetCouponController *getCouponVC = [[WDGetCouponController alloc]init];
    getCouponVC.storeId = self.storeId;
    [self.navigationController pushViewController:getCouponVC animated:YES];
    
}

/** 请求数据*/
- (void)_requestDatasWithSate:(NSString *)sate{
    
    NSString * shopID = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopID"];
    self.storeId = shopID;
    [WDNearStoreManager requestStoreInfosWithStoreId:self.storeId sate:sate completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
//            SHOW_ALERT(error)
            return;
        }
        _bigInfosArray = array;
        
        _storeInfosArray = _bigInfosArray[0];
        
        if (_storeInfosArray.count>0) {
            
            WDStoreInfosModel *model = _storeInfosArray[0];
            //            UIImage *image = [UIImage imageNamed:@"bgImage"];
            //            self.topView.backgroundColor = [UIColor colorWithPatternImage:image];
            
            _storeModel = model;
            [self.storeLogo sd_setImageWithURL:[NSURL URLWithString:model.img]];
            self.storeName.text = model.name;
            self.storePriceMsg.text = [NSString stringWithFormat:@"配送费￥%@ | 起送价￥%@",model.startfee,model.startvalue];
            self.peisong = model.startfee;
            self.storeGoodsMsg.text = [NSString stringWithFormat:@"共%@件商品 | 月售%@单",model.productscount,model.monthlysales];
            
            NSString *state = model.hasfavorite;
            if ([state isEqualToString:@"0"]) {
                
                _likeImage.image = [UIImage imageNamed:@"icon_collection_write"];
            }else{
                
                _likeImage.image = [UIImage imageNamed:@"收藏图标"];
            }
            
            _isHavaCoupon = [model.hascoupons boolValue];
            [self _createGetCouponBtn];
        }
        
        _storeCatesArray = _bigInfosArray[1];
        if (_storeCatesArray.count>0) {
            _selectIndex = 0;
        }
        [self.rightTableView reloadData];
        
        //  默认显示第一个分类 空表示默认
        if (_storeCatesArray.count == 0) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该店铺暂无商品上架" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:cancelBtn];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        }
       
        [self shuaXinTableView];
        /*
        [WDNearStoreManager requestProductInfosWithStoreId:shopID cateId:cateID searchKey:@"" sate:sate completion:^(NSMutableArray *array, NSString *error) {
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 20, 30)];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15.0];
            
            if (error) {
                
//                SHOW_ALERT(error)
                if (_cateGoodsArray.count > 0) {
                    [_cateGoodsArray removeAllObjects];
                }
                label.text = [NSString stringWithFormat:@"%@（0）",catesName];
                [self.leftTableView setTableHeaderView:label];
                [self.leftTableView reloadData];
                return ;
            }
            _cateGoodsArray = array;
            
            NSMutableArray * allShopArr = [WDGoodList getGoodWithStoreID:shopID];
            if (_selectArr.count > 0)
            {
                [_selectArr removeAllObjects];
            }
            if (_cateGoodsArray.count > 0)
            {
                
                for (int i = 0; i < _cateGoodsArray.count; i ++)
                {
                    WDSearchInfosModel * infoModel = _cateGoodsArray[i];
                    if (allShopArr.count > 0)
                    {
                        int selectNum = 0;
                        for (WDChooseGood * model in allShopArr)
                        {
                            if ([infoModel.pid isEqualToString:model.goodID])
                            {
                                selectNum ++;
                                [_selectArr addObject:model.goodNum];
                            }
                        }
                        if (selectNum == 0)
                        {
                            [_selectArr addObject:@"0"];
                        }
                    }
                    else
                    {
                        [_selectArr addObject:@"0"];
                    }
                    
                }
            }
//            NSLog(@"%@",_selectArr);
            _allNumber = allCount;
            
            label.text = [NSString stringWithFormat:@"%@（%ld）",catesName,_cateGoodsArray.count];
            
            [self getAllMoney];
            
//            [self.leftTableView setTableHeaderView:label];
            [self.leftTableView reloadData];
            
        }];
         */
    }];
}

-(void)setNavTabUI
{
    self.contentView.backgroundColor = [UIColor blueColor];
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navView.backgroundColor =KSYSTEM_COLOR;
    [[UIApplication sharedApplication].keyWindow addSubview:_navView];
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 31, 15, 20)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backBtn];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 100, 31, 200, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"店铺详情";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_navView addSubview:titleLabel];
    _shopLab = titleLabel;
    
    _likeImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 30, 20, 20)];
    [_navView addSubview:_likeImage];
    UIButton * likeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 20, 40, 40)];
    _likeImage.image = [UIImage imageNamed:@"icon_collection_write"]; // 默认未收藏
    [likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:likeBtn];
    
    //  右侧聊天信息按钮
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 35, 31, 20, 20)];
    [rightBtn setImage:[UIImage imageNamed:@"消息图标-1"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(chartAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:rightBtn];
    
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 聊天界面*/
- (void)chartAction:(UIButton *)btn{
    
    WDNewsViewController *webVC = [[WDNewsViewController alloc]init];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/message.html?access_token=%@&type=2&sid=%@&pid=0",HTML5_URL,token,self.storeId];
    webVC.requestUrl = urlStr;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)likeClick:(UIButton *)btn
{
    _isLike = ! _isLike;
    btn.enabled = NO;
    
    __block NSString *collectState;
    [WDNearStoreManager requestEditCollectWithStoreorId:self.storeId completion:^(NSString *state, NSString *error) {
        
        if (error) {
//            SHOW_ALERT(error)
            btn.enabled = YES;
        }
        else{
            
            collectState = state;
            if ([collectState isEqualToString:@"1"]) {
                
                _likeImage.image = [UIImage imageNamed:@"收藏图标"];
                [self showAlertWithString:@"已收藏" btnEnabled:btn];
            }
            else{
                
                _likeImage.image = [UIImage imageNamed:@"icon_collection_write"];
                [self showAlertWithString:@"已取消" btnEnabled:btn];
            }
        }
        
    }];
}

//  显示收藏状态
- (void)showAlertWithString:(NSString *)str btnEnabled:(UIButton *)btn{
    
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-80)*0.5, kScreenHeight-145, 80, 40)];
    alertLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
    alertLabel.text = str;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:alertLabel];
    
    //  延时1秒弹框消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertLabel removeFromSuperview];
        btn.enabled = YES;
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_navView removeFromSuperview];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _leftTableView) {
     NSIndexPath* index = [_leftTableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
        _selectIndex = index.section;
        if (_isDidSelect) {
            return;
        }
        [_rightTableView reloadData];
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"the begin start is %f",scrollView.contentOffset.y);
    _beginY = scrollView.contentOffset.y;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _leftTableView) {
        _endY = scrollView.contentOffset.y;
        
        if (_endY - _beginY>80) {
            if (!_topView.hidden) {
                
                [self showStoreInfoView:NO];
                
            }
            
        }else{
            if (_topView.hidden) {
                
                [self showStoreInfoView:YES];
            }
            
        }
    }
   
}
- (void)showStoreInfoView:(BOOL)isShow{
    if (isShow) {
        [self upViewYToHeight:-80 view:_exchangeView addH:NO];
        [self upViewYToHeight:-80 view:_leftTableView addH:YES];
        [self upViewYToHeight:-80 view:_rightTableView addH:YES];
        _topView.hidden = NO;
        if (_isHavaCoupon) {
            _getCoupon.hidden = NO;
            _getCouponBtn.hidden = NO;
        }else{
            _getCoupon.hidden = YES;
            _getCouponBtn.hidden = YES;
        }
       
        
        _shopLab.text = @"店铺详情";
    }else{
        _topView.hidden = YES;
        _getCoupon.hidden = YES;
        _getCouponBtn.hidden = YES;
        [self upViewYToHeight:80 view:_exchangeView addH:NO];
        
        [self upViewYToHeight:80 view:_leftTableView addH:YES];
        [self upViewYToHeight:80 view:_rightTableView addH:YES];
        _shopLab.text = _storeModel.name;;
    }
}
- (void)upViewYToHeight:(CGFloat)h view:(UIView *)view addH:(BOOL)isAdd{
    
    CGFloat height = isAdd ? view.frame.size.height+h:view.frame.size.height;
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - h, view.frame.size.width, height);
}
#pragma mark NearCellDelegate
- (void)addBtnClicked:(WDSearchInfosModel *)model count:(NSString *)count indexPath:(NSIndexPath *)indexPath
{
    WDSearchInfosModel * goods = model;
    WDStoreInfosModel *model1 = _storeInfosArray[0];
    WDChooseGood * good = [[WDChooseGood alloc]init];
    good.goodName = goods.name;
    good.goodNum = count;
    good.goodID = goods.pid;
    good.goodImage = goods.img;
    good.goodStartFee = model1.startvalue;
    good.goodDistributePrice = model1.startfee;
    good.goodPrice = goods.shopprice;
    good.shopID = self.storeId;
    good.shopName = self.storeName.text;
    good.shopImage = model.img;
    if ([count intValue] == 1) {
        [WDGoodList insertGood:good];
    }else{
        [WDGoodList upDateGood:good];
    }
    
    
    [self shuaXinTableView];

}
-(void)deleteBtnClicked:(WDSearchInfosModel *)model count:(NSString *)count indexPath:(NSIndexPath *)indexPath
{
    if ([count intValue] == 0) {
        [WDGoodList deleteGoodWithGoodsId:[model.pid intValue]];  // 当减到0时删除该商品id下的记录
        self.allMoneyLabel.text = @"0";
    }else{
        
        WDSearchInfosModel * goods = model;
        WDStoreInfosModel *model1 = _storeInfosArray[0];
        WDChooseGood * good = [[WDChooseGood alloc]init];
        good.goodName = goods.name;
        good.goodNum = count;
        good.goodID = goods.pid;
        good.goodImage = goods.img;
        good.goodStartFee = model1.startvalue;
        good.goodDistributePrice = model1.startfee;
        good.goodPrice = goods.shopprice;
        good.shopID = self.storeId;
        good.shopName = self.storeName.text;
        good.shopImage = model.img;
        [WDGoodList upDateGood:good];
    }
    [self shuaXinTableView];
}

#pragma mark - tableview协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == carTableView)
    {
        return 60;
    }
    else if (tableView == self.rightTableView)
    {
        return 40;
    }
    else
    {
        return 94;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_leftTableView == tableView) {
        
//        NSLog(@"storeCateArray count is %ld",_storeCatesArray.count);
        return _storeCatesArray.count;
    }
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == carTableView)
    {
        NSMutableArray * shopArray = [self getSelectGood];
        if (shopArray.count > 0)
        {
            return shopArray.count;
        }
        return 0;
    }
    else if (tableView == self.rightTableView)
    {
        return _storeCatesArray.count;
    }
    else
    {
        WDStoreInfoCatesModel *cateModel = _storeCatesArray[section];
//        NSLog(@"cateModel product count %ld",cateModel.productsList.count);
        return cateModel.productsList.count;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == carTableView)
    {
        WDMinShopCarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Mcell"];
        [cell.addBtn addTarget:self action:@selector(minaAddClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.subBtn addTarget:self action:@selector(minSubClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.addBtn.tag = indexPath.row+10;
        cell.subBtn.tag = indexPath.row+10;
        NSMutableArray * shopArray = [self getSelectGood];
        if (shopArray.count > 0)
        {
            WDChooseGood * good = shopArray[indexPath.row];
            cell.goodsName.text = good.goodName;
            cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",good.goodPrice];
            cell.labelCount.text = good.goodNum;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (tableView == self.rightTableView)
    {
        WDListRihtTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rcell"];
        if (_storeCatesArray.count > 0)
        {
            WDStoreInfoCatesModel * details = _storeCatesArray[indexPath.row];
            cell.nameLabel.text = details.name;
            
            if (indexPath.row == _selectIndex) {
                cell.colorView.backgroundColor = [UIColor colorWithRed:80/255.0 green:160/255.0 blue:80/255.0 alpha:1.0];
                cell.nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:160/255.0 blue:80/255.0 alpha:1.0];
                cell.backgroundColor = [UIColor whiteColor];
            }else{
                cell.colorView.backgroundColor = [UIColor clearColor];
                cell.nameLabel.textColor = [UIColor blackColor];
                cell.backgroundColor = [UIColor clearColor];
            }
        }
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else
    {
        WDNearDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Ncell"];
        WDStoreInfoCatesModel *cateModel = _storeCatesArray[indexPath.section];
         WDSearchInfosModel * goods = cateModel.productsList[indexPath.row];
        cell.delegate = self;
        [cell setSearchInfoModel:goods count:_selectArr[indexPath.section][indexPath.row] indexPath:indexPath];
        
      
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        WDStoreInfoCatesModel *cateModel = _storeCatesArray[section];
        return [NSString stringWithFormat:@"%@（%ld）",cateModel.name,cateModel.productsList.count];
    }
    return @"";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (tableView == carTableView)
    {
        WDGoodsInfoViewController * goodsInfoVC = [[WDGoodsInfoViewController alloc]init];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
        NSMutableArray * shopArray = [self getSelectGood];
        WDChooseGood * good = shopArray[indexPath.row];
        NSString * goodID = good.goodID;
        [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
    }
    if (tableView == self.rightTableView)
    {
        
        if (_selectIndex == indexPath.row) {
            return;
        }else{
            _isDidSelect = YES;
            _selectIndex = indexPath.row;
            [_rightTableView reloadData];
             WDStoreInfoCatesModel *model = _storeCatesArray[_selectIndex];
            if (model.productsList.count>0) {
                [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            _isDidSelect = NO;
        }
       
    }
    if (tableView == self.leftTableView)
    {
        WDGoodsInfoViewController * goodsInfoVC = [[WDGoodsInfoViewController alloc]init];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
        WDStoreInfoCatesModel *cateModel = _storeCatesArray[indexPath.section];
        
        WDSearchInfosModel * goods = cateModel.productsList[indexPath.row];
        goodsInfoVC.goodsImage = goods.img;
        NSString * goodID = goods.pid;
        [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
    }
}



//商品列表添加按钮
-(void)addClick:(UIButton *)btn
{
    NSIndexPath *index = [NSIndexPath indexPathForItem:btn.tag inSection:0];
    WDNearDetailsTableViewCell *cell =  [self.leftTableView cellForRowAtIndexPath:index];
    int num = [cell.numberLabel.text intValue];
    if (num == 0)
    {
        //        cell.isShowEnabled = 0;
        return;
    }
    else
    {
        num -- ;
        _allNumber --;
        if (num == 0)
        {
            WDStoreInfoCatesModel *cateModel = _storeCatesArray[index.section];
            WDSearchInfosModel * goods = cateModel.productsList[btn.tag];
            [WDGoodList deleteGoodWithGoodsId:[goods.pid intValue]];  // 当减到0时删除该商品id下的记录
            self.allMoneyLabel.text = @"0";
        }
        else
        {
            WDStoreInfoCatesModel *cateModel = _storeCatesArray[index.section];
            WDSearchInfosModel * goods = cateModel.productsList[btn.tag];
            WDStoreInfosModel *model = _storeInfosArray[0];
            WDChooseGood * good = [[WDChooseGood alloc]init];
            good.goodName = goods.name;
            good.goodNum = [NSString stringWithFormat:@"%d",num];
            good.goodID = goods.pid;
            good.goodImage = goods.img;
            good.goodStartFee = model.startvalue;
            good.goodDistributePrice = model.startfee;
            good.goodPrice = goods.shopprice;
            good.shopID = self.storeId;
            good.shopName = self.storeName.text;
            good.shopImage = model.img;
            [WDGoodList upDateGood:good];
        }
    }
    
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",num];
    [self shuaXinTableView];
}

-(void)subClick:(UIButton *)btn
{
    NSIndexPath * index =  [NSIndexPath indexPathForItem:btn.tag inSection:0];
    WDNearDetailsTableViewCell *cell =  [self.leftTableView cellForRowAtIndexPath:index];
    
    if (cell.numberLabel.hidden == YES) {
        
        cell.isShowEnabled = 1;
        
        WDStoreInfoCatesModel *cateModel = _storeCatesArray[index.section];
        WDSearchInfosModel * goods = cateModel.productsList[btn.tag];
        WDChooseGood * good = [[WDChooseGood alloc]init];
        good.goodName = goods.name;
        good.goodNum = @"1";
        good.goodID = goods.pid;
        good.shopID = self.storeId;
        good.shopName = self.storeName.text;
        good.goodPrice = goods.shopprice;
        WDStoreInfosModel *model = _storeInfosArray[0];
        good.goodImage = goods.img;
        good.shopImage = model.img;
        good.goodStartFee = model.startvalue;
        good.goodDistributePrice = model.startfee;
        [WDGoodList insertGood:good];
        
        cell.numberLabel.text = @"1";
        
    }else
    {
        
        int num = [cell.numberLabel.text intValue];
        if (num == 0)
        {
            //            num++;
            //            WDSearchInfosModel * goods = _cateGoodsArray[btn.tag];
            //            WDChooseGood * good = [[WDChooseGood alloc]init];
            //            good.goodName = goods.name;
            //            good.goodNum = [NSString stringWithFormat:@"%d",num];
            //            good.goodID = goods.pid;
            //            good.shopID = self.storeId;
            //            good.shopName = self.storeName.text;
            //            good.goodPrice = goods.shopprice;
            //            WDStoreInfosModel *model = _storeInfosArray[0];
            //            good.goodImage = goods.img;
            //            good.shopImage = model.img;
            //            good.goodStartFee = model.startvalue;
            //            good.goodDistributePrice = model.startfee;
            //            [WDGoodList insertGood:good];
        }
        else
        {
            num++;
            WDStoreInfoCatesModel *cateModel = _storeCatesArray[index.section];
            WDSearchInfosModel * goods = cateModel.productsList[btn.tag];
//            WDSearchInfosModel * goods = _cateGoodsArray[btn.tag];
            WDChooseGood * good = [[WDChooseGood alloc]init];
            good.goodName = goods.name;
            good.goodNum = [NSString stringWithFormat:@"%d",num];
            good.goodID = goods.pid;
            good.shopID = self.storeId;
            good.shopName = self.storeName.text;
            good.goodPrice = goods.shopprice;
            WDStoreInfosModel * model = _storeInfosArray[0];
            good.goodImage = goods.img;
            good.shopImage = model.img;
            good.goodStartFee = model.startvalue;
            good.goodDistributePrice = model.startfee;
            [WDGoodList upDateGood:good];
        }
        cell.numberLabel.text = [NSString stringWithFormat:@"%d",num];
    }
    _allNumber ++;
//    [self getAllMoney];
    [self shuaXinTableView];
    [self.leftTableView reloadData];
}


//弹出的购物车添加按钮
-(void)minaAddClick:(UIButton *)btn
{
    NSIndexPath *index = [NSIndexPath indexPathForItem:btn.tag - 10 inSection:0];
    WDMinShopCarTableViewCell * cell = [carTableView cellForRowAtIndexPath:index];
    NSMutableArray * shopArray = [self getSelectGood];
    
    int num = [cell.labelCount.text intValue];
    if (num == 0)
    {
        return;
    }
    else
    {
        num -- ;
        _allNumber --;
        if (num == 0)
        {
            WDChooseGood * good = shopArray[btn.tag - 10];
            [WDGoodList deleteGoodWithGoodsId:[good.goodID intValue]];  // 当减到0时删除该商品id下的记录
            NSMutableArray * shopArray = [self getSelectGood];
            if (shopArray.count == 0) {
                
                [self downView];
                self.allMoneyLabel.text = @"0";
            }
            
            [carTableView reloadData];
        }
        else
        {
            WDChooseGood * good1 = shopArray[btn.tag - 10];
            WDStoreInfosModel *model = _storeInfosArray[0];
            WDChooseGood * good = [[WDChooseGood alloc]init];
            good.goodName = good1.goodName;
            good.goodNum = [NSString stringWithFormat:@"%d",num];
            good.goodID = good1.goodID;
            good.goodImage = good1.goodImage;
            good.goodPrice = good1.goodPrice;
            good.shopID = self.storeId;
            good.shopName = self.storeName.text;
            good.shopImage = model.img;
            [WDGoodList upDateGood:good];
        }
    }
    cell.labelCount.text = [NSString stringWithFormat:@"%d",num];
    [self getAllMoney];
    [self shuaXinTableView];
}

-(void)minSubClick:(UIButton *)btn
{
    NSIndexPath *index = [NSIndexPath indexPathForItem:btn.tag - 10 inSection:0];
    WDMinShopCarTableViewCell * cell = [carTableView cellForRowAtIndexPath:index];
    NSMutableArray * shopArray = [self getSelectGood];
    int num = [cell.labelCount.text intValue];
    num++;
    WDChooseGood * good1 = shopArray[btn.tag - 10];
    WDStoreInfosModel *model = _storeInfosArray[0];
    WDChooseGood * good = [[WDChooseGood alloc]init];
    good.goodName = good1.goodName;
    good.goodNum = [NSString stringWithFormat:@"%d",num];
    good.goodID = good1.goodID;
    good.goodImage = good1.goodImage;
    good.goodPrice = good1.goodPrice;
    good.shopID = self.storeId;
    good.shopName = self.storeName.text;
    good.shopImage = model.img;
    [WDGoodList upDateGood:good];
    
    cell.labelCount.text = [NSString stringWithFormat:@"%d",num];
    [self getAllMoney];
    [self shuaXinTableView];
}

-(void)shuaXinTableView
{
    [_selectArr removeAllObjects];
    NSString * shopID = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopID"];
    NSMutableArray * allShopArr = [WDGoodList getGoodWithStoreID:shopID];
    
    for (int i = 0; i<_storeCatesArray.count; i++) {
        NSMutableArray *cateSelectList = [[NSMutableArray alloc] init];
        WDStoreInfoCatesModel *cateModel = _storeCatesArray[i];
        for (int i= 0; i<cateModel.productsList.count; i++)
        {
            WDSearchInfosModel * infoModel = cateModel.productsList[i];
            if (allShopArr.count > 0)
            {
                int selectNum = 0;
                for (WDChooseGood * model in allShopArr)
                {
                    if ([infoModel.pid isEqualToString:model.goodID])
                    {
                        selectNum ++;
                        [cateSelectList addObject:model.goodNum];
                    }
                }
                if (selectNum == 0)
                {
                    [cateSelectList addObject:@"0"];
                }
                
            }
            else
            {
                [cateSelectList addObject:@"0"];
            }
        }
        [_selectArr addObject:cateSelectList];
    }
    _allNumber = allCount;
    _numLab.text = [NSString stringWithFormat:@"%ld",_allNumber];
    [self.leftTableView reloadData];
    [self getAllGood];
    [self getAllMoney];
   
    
    /*
    NSString * shopID = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopID"];
    [WDNearStoreManager requestProductInfosWithStoreId:shopID cateId:_cateID searchKey:nil completion:^(NSMutableArray *array, NSString *error)
     {
         if (error) {
             
             return ;
         }
         
         if (_cateGoodsArray) {
             
             [_cateGoodsArray removeAllObjects];
         }
         _cateGoodsArray = array;
         
         NSMutableArray * allShopArr = [WDGoodList getGoodWithStoreID:shopID];
         
         if (_cateGoodsArray.count > 0)
         {
             [_selectArr removeAllObjects];
             for (int i = 0; i < _cateGoodsArray.count; i ++)
             {
                 WDSearchInfosModel * infoModel = _cateGoodsArray[i];
                 if (allShopArr.count > 0)
                 {
                     int selectNum = 0;
                     for (WDChooseGood * model in allShopArr)
                     {
                         if ([infoModel.pid isEqualToString:model.goodID])
                         {
                             selectNum ++;
                             [_selectArr addObject:model.goodNum];
                         }
                     }
                     if (selectNum == 0)
                     {
                         [_selectArr addObject:@"0"];
                     }
                     
                 }
                 else
                 {
                     [_selectArr addObject:@"0"];
                 }
                 
             }
         }
//         NSLog(@"%@",_selectArr);
         _allNumber = allCount;
         _numLab.text = [NSString stringWithFormat:@"%ld",_allNumber];
         [self.leftTableView reloadData];
         [self getAllGood];
     }];
    */
}

//弹出购物详情
-(void)setBottomUI
{
    // 初始化 popTableViewArray
    _popTableViewArray = [NSMutableArray array];
    
    // 从本地数据库中读取选择的商品存入数组中
    
    //灰色背景
    bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 104)];
    bigView.backgroundColor = [UIColor blackColor];
    bigView.alpha = 0;
    UIButton * downBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 120)];
    [downBtn addTarget:self action:@selector(downView) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:downBtn];
    
    //下面的白色背景
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 104, kScreenWidth, 0)];
    backView.backgroundColor = [UIColor whiteColor];
    
    //第一行
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 10, 60, 20)];
    label1.text = @"删除全部";
    label1.font = [UIFont systemFontOfSize:12.0];
    label1.textColor = KSYSTEM_COLOR;
    
    UIImageView * deleteImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 85, 10, 20, 20)];
    deleteImage.image = [UIImage imageNamed:@"shanchu1"];
    
    UIButton * deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 0, 100, 40)];
    [deleteBtn addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:deleteBtn];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    
    //第三行
    carTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46, kScreenWidth, 170)];
    carTableView.delegate = self;
    carTableView.dataSource = self;
    carTableView.showsVerticalScrollIndicator = NO;
    [carTableView registerNib:[UINib nibWithNibName:@"WDMinShopCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"Mcell"];
    
    [self.view addSubview:bigView];
    [self.view addSubview:backView];
//    [self shuaXinTableView];
    newImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, kScreenHeight - 104, 40, 40)];
    newImage.image = [UIImage imageNamed:@"gouwuquan.jpg"];
    _numLab = [[UILabel alloc]initWithFrame:CGRectMake(23, 0, 18 ,18)];
    _numLab.text = [NSString stringWithFormat:@"%ld",_allNumber];
    _numLab.font = [UIFont systemFontOfSize:12.0];
    _numLab.textAlignment = NSTextAlignmentCenter;
    _numLab.textColor = [UIColor whiteColor];
    [newImage addSubview:_numLab];
    [self.view addSubview:newImage];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.lineView.frame = CGRectMake(0, 0, 1, 40);
        self.hejiView.frame = CGRectMake(0, 0, 150, 40);
        self.shopBtn.userInteractionEnabled = NO;
        bigView.alpha = 0.5;
        backView.frame = CGRectMake(0, kScreenHeight - 354, kScreenWidth, 250);
        newImage.frame = CGRectMake(10, kScreenHeight - 404, 40, 40);
        
    } completion:^(BOOL finished) {
        
        [backView addSubview:label1];
        [backView addSubview:deleteImage];
        [backView addSubview:line1];
        [backView addSubview:carTableView];
    }];
}

- (void)gotoCarBtnAction:(UIButton *)btn{
    
    WDTabbarViewController *tabbar = [[WDTabbarViewController alloc]init];
    tabbar.selectedIndex = 2;
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    window.rootViewController = tabbar;
}

-(void)deleteAll
{
    NSString * shopID = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopID"];
    [WDGoodList deleteGoodWithStoreId:[shopID intValue]];  // 删除所有已选商品
    [self shuaXinTableView];
    [carTableView reloadData];
    
    [UIView animateWithDuration:0.25 animations:^
     {
         self.lineView.frame = CGRectMake(59, 0, 1, 40);
         self.hejiView.frame = CGRectMake(60, 0, 150, 40);
         bigView.alpha = 0;
         backView.frame = CGRectMake(0, kScreenHeight - 104, kScreenWidth, 0);
         newImage.frame = CGRectMake(10, kScreenHeight - 104, 40, 40);
     } completion:^(BOOL finished)
     {
         self.shopBtn.userInteractionEnabled = YES;
         //         [yesBtn removeFromSuperview];
         //         [gotoCarBtn removeFromSuperview];
         [newImage removeFromSuperview];
         [bigView removeFromSuperview];
         [backView removeFromSuperview];
         self.allMoneyLabel.text = @"0";
     }];
    [self getAllMoney];
}

//选好了
-(void)yesClick
{
    [WDMineManager requestLoginEnabledWithCompletion:^(NSString *resultRet) {
        
        if ([resultRet isEqualToString:@"0"])
        {
            WDAccountViewController * accountVC = [[WDAccountViewController alloc]init];
            
            NSMutableArray * zhiFuArray = [self getSelectGood];
            accountVC.dataArray = zhiFuArray;
            
            NSMutableString *orderStr = [NSMutableString string];
            for (int i = 0; i < zhiFuArray.count; i ++) {
                
                WDChooseGood * model = zhiFuArray[i];
                NSString *str = [NSString stringWithFormat:@"%@,%@",model.goodID,model.goodNum];
                [orderStr appendFormat:@"%@$",str];
            }
//            NSLog(@"orderStr = %@",orderStr);
            NSString *orderInfo = [orderStr substringToIndex:orderStr.length - 1];
            accountVC.orderinfo = orderInfo;
            
            [self.navigationController pushViewController:accountVC animated:YES];
        }
        else
        {
            WDLoginViewController *loginVC = [[WDLoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }];
}

-(void)downView
{
    [UIView animateWithDuration:0.25 animations:^
     {
         
         self.shopBtn.userInteractionEnabled = YES;
         //         [yesBtn removeFromSuperview];
         //         [gotoCarBtn removeFromSuperview];
         [newImage removeFromSuperview];
         [bigView removeFromSuperview];
         [backView removeFromSuperview];
         
     } completion:^(BOOL finished)
     {
         self.lineView.frame = CGRectMake(59, 0, 1, 40);
         self.hejiView.frame = CGRectMake(60, 0, 150, 40);
         bigView.alpha = 0;
         backView.frame = CGRectMake(0, kScreenHeight - 104, kScreenWidth, 0);
         newImage.frame = CGRectMake(10, kScreenHeight - 104, 40, 40);
     }];
}

- (IBAction)shopBtn:(UIButton *)sender
{
    [self shuaXinTableView];
    if (_allNumber != 0) {
        
        [self setBottomUI];
    }
}

-(void)getAllGood
{
    NSString * shopID = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopID"];
    NSMutableArray * allShopArr = [WDGoodList getGoodWithStoreID:shopID];
    allCount = 0;
    for (WDChooseGood * model in allShopArr)
    {
        NSInteger count = [model.goodNum integerValue];
        allCount += count;
        self.allMoneyLabel.text = [NSString stringWithFormat:@"%ld",allCount];
    }
}



@end
