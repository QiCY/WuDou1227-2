//
//  WDStoreDetailViewController.m
//  WuDou
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 os1. All rights reserved.
//

#import "WDStoreDetailViewController.h"
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
#import "SYHeadScrollView.h"
#import "WDStoreInfoView.h"
#import "WDStoreInfoGoodsView.h"
#import "WDChooseGood.h"
#import "WDDetailsViewController.h"

@interface WDStoreDetailViewController ()<UITableViewDataSource,UITableViewDelegate,WDStoreInfoGoodsViewDelegate,StoreInfoViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong)UITableView *tableView,*carTableView;
@property(nonatomic,strong)NSMutableArray *cateList;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UIView *navView;
@property(nonatomic,strong)UIButton *favoriteBtn,*messageBtn;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *allMoneyLab;
@property(nonatomic,strong)UILabel *allCountLab;
@property(nonatomic,strong)UIButton *goCarBtn;
@property(nonatomic,strong)UIButton *goOrderBtn;
@property(nonatomic,strong)UIButton *allNumberBtn;
@property(nonatomic,strong)NSMutableArray *selectArray,*menuList;
@property(nonatomic,strong)SYHeadScrollView *headScroll;
@property(nonatomic,strong)WDStoreInfosModel *storeModel;
@property(nonatomic,strong)NSMutableArray *popTableViewArray;
@property(nonatomic,strong)UIImageView *carImageView;
@property(nonatomic,strong)UILabel *numLab;
@property(nonatomic,strong)UIView *bigView,*backView;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UITableViewCell *goodsCell;
@property(nonatomic,strong)WDStoreInfoGoodsView *goodsView;
@property(nonatomic,assign)NSInteger allCount;
@property(nonatomic,strong)NSString* state;
@property(nonatomic,assign)float allMoney;
@property(nonatomic,assign)float startPrice;
@property(nonatomic,assign)float trancePrice;
@property(nonatomic,strong)UIView *allMoneyLine;
@property(nonatomic,strong)UIButton* rightBtn;
@property(nonatomic,assign)BOOL isScrollTop;

@end

@implementation WDStoreDetailViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_navView removeFromSuperview];
   self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
     _state = @"1";
     [self createNavView];
     [self _requestDatasWithSate:_state];
    
   
    if (self.navigationController.navigationBar.hidden) {
        NSLog(@"navBar Hidden");
    }else{
        NSLog(@"navBar Show");
        self.navigationController.navigationBar.hidden = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectArray = [[NSMutableArray alloc] init];
    self.cateList = [[NSMutableArray alloc] init];
    _isScrollTop = NO;
    self.view.backgroundColor = [UIColor whiteColor];
   self.automaticallyAdjustsScrollViewInsets=NO;
    [self createTableView];
    [self createFooterView];

    // 添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(haveReceiveMsg:) name:@"HAVEMSG" object:nil];
}
/** 监听通知的方法：改变图标状态*/
- (void)haveReceiveMsg:(NSNotification *)noti{
    
    NSString *result = noti.userInfo[@"RESULT"];
    if ([result isEqualToString:@"1"]) {
        
        //        AudioServicesPlaySystemSound(1003);
        [_rightBtn setImage:[UIImage imageNamed:@"xiaoxi11"] forState:UIControlStateNormal];
        
    }else{
        
        [_rightBtn setImage:[UIImage imageNamed:@"消息图标-1"] forState:UIControlStateNormal];
        
    }
}
- (void)dealloc
{
         [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HAVEMSG" object:nil];
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView{
    
    CGFloat h = CGRectGetMaxY(_navView.frame);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight -64 - 40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)createFooterView{
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40)];
    [self.view addSubview:self.footerView];
    
    self.allNumberBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 3, 34, 30)];
    [self.allNumberBtn addTarget:self action:@selector(openCarTableView) forControlEvents:UIControlEventTouchUpInside];
    [self.allNumberBtn setBackgroundImage:[UIImage imageNamed:@"购物车2.png"] forState:UIControlStateNormal];
    [self.footerView addSubview:self.allNumberBtn];
    self.allMoneyLine =[self createVerLine:CGRectMake(50, 0, 1, 40) color:[UIColor lightGrayColor]];
    [self.footerView addSubview:self.allMoneyLine];
    self.allCountLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 20, 15)];
    self.allCountLab.font = [UIFont systemFontOfSize:10];
    self.allCountLab.textAlignment = 1;
    self.allCountLab.text = @"11";
    self.allCountLab.textColor = [UIColor whiteColor];
    [self.allNumberBtn addSubview:self.allCountLab];
    
    self.allMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 130, 40)];
    self.allMoneyLab.font = [UIFont systemFontOfSize:16];
    self.allMoneyLab.textColor = [UIColor redColor];
    [self.footerView addSubview:self.allMoneyLab];
    
    self.goCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 140, 0, 70, 40)];
    [self.goCarBtn setTitle:@"去购物车" forState:UIControlStateNormal];
    self.goCarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.goCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.goCarBtn.backgroundColor = [UIColor lightGrayColor];
    [self.goCarBtn addTarget:self action:@selector(gotoCarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.goCarBtn];
    
    
    [self.footerView addSubview:[self createVerLine:CGRectMake(kScreenWidth - 71, 0, 1, 40) color:[UIColor whiteColor]]];
    
    self.goOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 70, 0, 70, 40)];
    self.goOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
     [self.goOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.goOrderBtn setTitle:@"选好了" forState:UIControlStateNormal];
    [self.goOrderBtn addTarget:self action:@selector(gotoOrder) forControlEvents:UIControlEventTouchUpInside];
    self.goOrderBtn.backgroundColor = [UIColor lightGrayColor];
    [self.footerView addSubview:self.goOrderBtn];

}
- (void)addRedPointToLab:(NSString *)text label:(UILabel *)label
{
    NSString *keyString = @"合计：";
    NSString *nameString = [NSString stringWithFormat:@"%@%@",keyString,text];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:nameString];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    label.attributedText = attStr;
}

- (void)openCarTableView{
    if (_allCount>0) {
        [self setBottomUI];
    }
    
}


- (void)createNavView{
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navView.backgroundColor =KSYSTEM_COLOR;
    [[UIApplication sharedApplication].keyWindow addSubview:_navView];
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 31, 10, 20)];
//     [backBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 3, 4,3)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backBtn];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 100, 31, 200, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"店铺详情";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_navView addSubview:titleLabel];
    _titleLab = titleLabel;
    

    self.favoriteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 20, 40, 40)];
    [_favoriteBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [_favoriteBtn setImage:[UIImage imageNamed:@"icon_collection_write"] forState:UIControlStateNormal];
    _favoriteBtn.selected = NO;
    [_favoriteBtn setImage:[UIImage imageNamed:@"收藏图标"] forState:UIControlStateSelected];
    [_favoriteBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_favoriteBtn];
    
//    [_favoriteBtn setImage:[UIImage imageNamed:@"收藏图标"] forState:UIControlStateS]
    
    
    //  右侧聊天信息按钮
   UIButton* rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 35, 31, 20, 20)];
    [rightBtn setImage:[UIImage imageNamed:@"消息图标-1"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(chartAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    [_navView addSubview:rightBtn];
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
- (UIView *)createVerLine:(CGRect)frame color:(UIColor *)color{
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = color;
    return lineView;
}
#pragma mark carTableView
//弹出购物详情
-(void)setBottomUI
{
    // 初始化 popTableViewArray
    _popTableViewArray = [NSMutableArray array];
    
    // 从本地数据库中读取选择的商品存入数组中
    
    //灰色背景
    _bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 104)];
    _bigView.backgroundColor = [UIColor blackColor];
    _bigView.alpha = 0;
    UIButton * downBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 120)];
    [downBtn addTarget:self action:@selector(downView) forControlEvents:UIControlEventTouchUpInside];
    [_bigView addSubview:downBtn];
    
    //下面的白色背景
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 104, kScreenWidth, 0)];
    _backView.backgroundColor = [UIColor whiteColor];
    
    //第一行
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 10, 60, 20)];
    label1.text = @"删除全部";
    label1.font = [UIFont systemFontOfSize:12.0];
    label1.textColor = KSYSTEM_COLOR;
    
    UIImageView * deleteImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 85, 10, 20, 20)];
    deleteImage.image = [UIImage imageNamed:@"shanchu1"];
    
    UIButton * deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 0, 100, 40)];
    [deleteBtn addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:deleteBtn];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    
    //第三行
    _carTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46, kScreenWidth, 170)];
    _carTableView.delegate = self;
    _carTableView.dataSource = self;
    _carTableView.showsVerticalScrollIndicator = NO;
    [_carTableView registerNib:[UINib nibWithNibName:@"WDMinShopCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"Mcell"];
    
    [self.view addSubview:_bigView];
    [self.view addSubview:_backView];
    //    [self shuaXinTableView];
    _carImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, kScreenHeight - 104, 40, 40)];
    _carImageView.image = [UIImage imageNamed:@"gouwuquan.jpg"];
    _numLab = [[UILabel alloc]initWithFrame:CGRectMake(23, 0, 18 ,18)];
    _numLab.text = [NSString stringWithFormat:@"%ld",_allCount];
    _numLab.font = [UIFont systemFontOfSize:12.0];
    _numLab.textAlignment = NSTextAlignmentCenter;
    _numLab.textColor = [UIColor whiteColor];
    [_carImageView addSubview:_numLab];
    [self.view addSubview:_carImageView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
       
        _bigView.alpha = 0.5;
        _backView.frame = CGRectMake(0, kScreenHeight - 290, kScreenWidth, 250);
        _carImageView.frame = CGRectMake(10, kScreenHeight - 340, 40, 40);
        _allNumberBtn.hidden = YES;
        _allCountLab.hidden = YES;
        _allMoneyLab.frame = CGRectMake(10, 0, _allMoneyLab.frame.size.width, 40);
        _allMoneyLine.hidden = YES;
        
    } completion:^(BOOL finished) {
        
        [_backView addSubview:label1];
        [_backView addSubview:deleteImage];
        [_backView addSubview:line1];
        [_backView addSubview:_carTableView];
    }];
}

#pragma mark ===============GoodsTableViewDelegate============

- (void)didClickedDiscountBtn
{
    WDGetCouponController *getCouponVC = [[WDGetCouponController alloc]init];
    getCouponVC.storeId = self.storeId;
    [self.navigationController pushViewController:getCouponVC animated:YES];
}
- (void)didScrollToUp
{
    
    [UIView animateWithDuration:0.25 animations:^{
         self.tableView.contentOffset = CGPointMake(0, 80);
        self.titleLab.text = _storeModel.name;
        _isScrollTop = YES;
    }];
    
}
- (void)didScrollToDown
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.contentOffset = CGPointMake(0, 0);
        self.titleLab.text =@"店铺详情";
        _isScrollTop = NO;
    }];
    
}
- (void)didClickedGood:(WDSearchInfosModel *)good
{
    [self.view endEditing:YES];
    WDGoodsInfoViewController * goodsInfoVC = [[WDGoodsInfoViewController alloc]init];
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
    NSString * goodID = good.pid;
    goodsInfoVC.goodsImage = good.img;
    [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
}
-(void)addBtnClicked:(WDSearchInfosModel *)good count:(NSString *)count indexPath:(NSIndexPath *)indexPath
{
    WDSearchInfosModel * goods = good;
    WDStoreInfosModel *model1 = _storeModel;
    WDChooseGood * good1 = [[WDChooseGood alloc]init];
    good1.goodName = goods.name;
    good1.goodNum = count;
    good1.goodID = goods.pid;
    good1.goodImage = goods.img;
    good1.goodStartFee = model1.startvalue;
    good1.goodDistributePrice = model1.startfee;
    good1.goodPrice = goods.shopprice;
    good1.shopID = self.storeId;
    good1.shopName = model1.name;
    good1.shopImage = model1.img;
    if ([count intValue] == 1) {
        [WDGoodList insertGood:good1];
    }else{
        [WDGoodList upDateGood:good1];
    }
    [self getAllMoney];
    [self.goodsView setDataArray:_cateList selectList:_selectArray indexPath:indexPath];
    
}

- (void)deleteBtnClicked:(WDSearchInfosModel *)good count:(NSString *)count indexPath:(NSIndexPath *)indexPath
{
    if ([count intValue] == 0) {
        [WDGoodList deleteGoodWithGoodsId:[good.pid intValue]];  // 当减到0时删除该商品id下的记录
        [self getAllMoney];
    }else{
        
        WDSearchInfosModel * goods = good;
        WDStoreInfosModel *model1 =_storeModel;
        WDChooseGood * good = [[WDChooseGood alloc]init];
        good.goodName = goods.name;
        good.goodNum = count;
        good.goodID = goods.pid;
        good.goodImage = goods.img;
        good.goodStartFee = model1.startvalue;
        good.goodDistributePrice = model1.startfee;
        good.goodPrice = goods.shopprice;
        good.shopID = self.storeId;
        good.shopName = _storeModel.name;
        good.shopImage = _storeModel.img;
        [WDGoodList upDateGood:good];
        [self getAllMoney];
    }
    
     [self.goodsView setDataArray:_cateList selectList:_selectArray indexPath:indexPath];
}
#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (![searchBar.text isEqualToString:@""]) {
        
        WDDetailsViewController *searchVC = [[WDDetailsViewController alloc] init];
        searchVC.searchMsg = searchBar.text;
        searchVC.navtitle = @"搜索列表";
        searchVC.isCategories = 1;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    
    [searchBar resignFirstResponder];
}

#pragma mark ================UITableView Delegate================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _carTableView) {
        NSMutableArray * shopArray = [self getSelectGood];
        if (shopArray.count > 0)
        {
            return shopArray.count;
        }
        return 0;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _carTableView) {
        return 1;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _carTableView) {
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
    }else{
        if (indexPath.section == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            for (UIView *subView in cell.contentView.subviews) {
                [subView removeFromSuperview];
            }
            WDStoreInfoView *storeInfoView = [[WDStoreInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
            [cell.contentView addSubview:storeInfoView];
            if (_storeModel) {
                [storeInfoView setStoreInfo:_storeModel];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            
            if (!_goodsCell) {
                _goodsCell = [[UITableViewCell alloc] init];
                WDStoreInfoGoodsView *goodsView = [[WDStoreInfoGoodsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64-40-30)];
                goodsView.delegate = self;
                
                [_goodsCell.contentView addSubview:goodsView];
                self.goodsView = goodsView;
            }
            
            [_goodsView setDataArray:_cateList selectList:_selectArray];
            return _goodsCell;
        }
    }
   
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if (_type == 0) {
            return self.headScroll;
        }else{
            return self.searchBar;
        }
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _carTableView)
    {
        return 60;
    }
    if (indexPath.section == 0) {
        return 80;
    }else{
        if (_type ==1) {
            return kScreenHeight - 64-40-40;
        }
        return kScreenHeight - 64-40-31;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    if (_type ==1) {
        return 40;
    }
    return 31;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 1) {
        if ([_searchBar resignFirstResponder]) {
             [self.view endEditing:YES];
        }
        
    }
    if (tableView == _carTableView)
    {
        WDGoodsInfoViewController * goodsInfoVC = [[WDGoodsInfoViewController alloc]init];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
        NSMutableArray * shopArray = [self getSelectGood];
        WDChooseGood * good = shopArray[indexPath.row];
        NSString * goodID = good.goodID;
        goodsInfoVC.goodsImage = good.goodImage;
        [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
    }
}
- (UIScrollView *)headScroll{
    if (!_headScroll) {
        _menuList = [NSMutableArray arrayWithObjects:@"生鲜区",@"净菜区", nil];
        _headScroll = [[SYHeadScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 31) withDataList:_menuList didClick:^(NSInteger index) {
            //           点击头部按钮根据index来做出相应处理
            _state = [NSString stringWithFormat:@"%ld",index+1];
            [self _requestDatasWithSate:_state];
            
        }];
        _headScroll.backgroundColor = [UIColor whiteColor];
    }
    return _headScroll;
}
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索店内商品";
    
    }
    return _searchBar;
}
#pragma mark========GETDATA=========
/** 请求数据*/
- (void)_requestDatasWithSate:(NSString *)sate{
    
    NSString * shopID = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopID"];
    self.storeId = shopID;
    [WDNearStoreManager requestStoreInfosWithStoreId:self.storeId sate:sate completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            return;
        }
        
        
     NSArray*   _storeInfosArray = array[0];
        
        if (_storeInfosArray.count>0) {
            WDStoreInfosModel *model = _storeInfosArray[0];
            _storeModel = model;
            NSString *state = model.hasfavorite;
            _favoriteBtn.selected = [state boolValue];
        }
        
        _cateList = array[1];
        [self getAllMoney];
        [self.tableView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新完成
            if (_isScrollTop) {
                self.tableView.contentOffset = CGPointMake(0, 80);
                self.titleLab.text = _storeModel.name;
            }else{
                self.tableView.contentOffset = CGPointMake(0, 0);
                self.titleLab.text =@"店铺详情";
            }
        });
        //  默认显示第一个分类 空表示默认
        if (_cateList.count == 0) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该店铺暂无商品上架" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:cancelBtn];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        }
    }];
}
- (void)getSelectArray{
    [_selectArray removeAllObjects];
    NSString * shopID = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopID"];
    NSMutableArray * allShopArr = [WDGoodList getGoodWithStoreID:shopID];
    
    for (int i = 0; i<_cateList.count; i++) {
        NSMutableArray *cateSelectList = [[NSMutableArray alloc] init];
        WDStoreInfoCatesModel *cateModel = _cateList[i];
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
        [_selectArray addObject:cateSelectList];
    }
}
#pragma mark ================BUTTON ACTION================

- (void)gotoCarBtnAction:(UIButton *)btn{
    
    WDTabbarViewController *tabbar = [[WDTabbarViewController alloc]init];
    tabbar.selectedIndex = 2;
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    window.rootViewController = tabbar;
}
- (void)gotoOrder{
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
-(void)deleteAll
{
    NSString * shopID = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopID"];
    [WDGoodList deleteGoodWithStoreId:[shopID intValue]];  // 删除所有已选商品
    [self getAllMoney];
    [_carTableView reloadData];
    
    [self downView];
    [self.goodsView setDataArray:_cateList selectList:_selectArray];
}

-(void)minSubClick:(UIButton *)btn
{
    NSIndexPath *index = [NSIndexPath indexPathForItem:btn.tag - 10 inSection:0];
    WDMinShopCarTableViewCell * cell = [_carTableView cellForRowAtIndexPath:index];
    NSMutableArray * shopArray = [self getSelectGood];
    int num = [cell.labelCount.text intValue];
    num++;
    WDChooseGood * good1 = shopArray[btn.tag - 10];
    WDStoreInfosModel *model = self.storeModel;
    WDChooseGood * good = [[WDChooseGood alloc]init];
    good.goodName = good1.goodName;
    good.goodNum = [NSString stringWithFormat:@"%d",num];
    good.goodID = good1.goodID;
    good.goodImage = good1.goodImage;
    good.goodPrice = good1.goodPrice;
    good.shopID = self.storeId;
    good.shopName = self.storeModel.name;
    good.shopImage = model.img;
    [WDGoodList upDateGood:good];
    
    cell.labelCount.text = [NSString stringWithFormat:@"%d",num];
    [self getAllMoney];
    [self.goodsView setDataArray:_cateList selectList:_selectArray];
}

//弹出的购物车添加按钮
-(void)minaAddClick:(UIButton *)btn
{
    NSIndexPath *index = [NSIndexPath indexPathForItem:btn.tag - 10 inSection:0];
    WDMinShopCarTableViewCell * cell = [_carTableView cellForRowAtIndexPath:index];
    NSMutableArray * shopArray = [self getSelectGood];
    
    int num = [cell.labelCount.text intValue];
    if (num == 0)
    {
        return;
    }
    else
    {
        num -- ;
        _allCount --;
        if (num == 0)
        {
            WDChooseGood * good = shopArray[btn.tag - 10];
            [WDGoodList deleteGoodWithGoodsId:[good.goodID intValue]];  // 当减到0时删除该商品id下的记录
            NSMutableArray * shopArray = [self getSelectGood];
            if (shopArray.count == 0) {
                
                [self downView];
            
            }
            
            [_carTableView reloadData];
        }
        else
        {
            WDChooseGood * good1 = shopArray[btn.tag - 10];
            WDStoreInfosModel *model = self.storeModel;
            WDChooseGood * good = [[WDChooseGood alloc]init];
            good.goodName = good1.goodName;
            good.goodNum = [NSString stringWithFormat:@"%d",num];
            good.goodID = good1.goodID;
            good.goodImage = good1.goodImage;
            good.goodPrice = good1.goodPrice;
            good.shopID = self.storeId;
            good.shopName = self.storeModel.name;
            good.shopImage = model.img;
            [WDGoodList upDateGood:good];
        }
    }
    cell.labelCount.text = [NSString stringWithFormat:@"%d",num];
    [self getAllMoney];
    [self.goodsView setDataArray:_cateList selectList:_selectArray];
}
-(void)downView
{
    [UIView animateWithDuration:0.25 animations:^
     {
         [_carImageView removeFromSuperview];
         [_bigView removeFromSuperview];
         [_backView removeFromSuperview];
         
     } completion:^(BOOL finished)
     {
         _allNumberBtn.hidden = NO;
         _allCountLab.hidden = NO;
         _allMoneyLine.hidden = NO;
         _bigView.alpha = 0;
         _backView.frame = CGRectMake(0, kScreenHeight - 104, kScreenWidth, 0);
         _carImageView.frame = CGRectMake(10, kScreenHeight - 104, 40, 40);
          _allMoneyLab.frame = CGRectMake(60, 0, _allMoneyLab.frame.size.width, 40);
     }];
}


-(void)likeClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
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
                [self showAlertWithString:@"已收藏" btnEnabled:btn];
            }
            else{
                [self showAlertWithString:@"已取消" btnEnabled:btn];
            }
        }
        
    }];
}
//计算全部商品价格
-(void)getAllMoney
{
     [self getSelectArray];
    _allMoney = 0.0;
    _allCount = 0;
    NSMutableArray * shopArr = [self getSelectGood];
    for ( WDChooseGood * model in shopArr )
    {
        
        NSString * goodMoney = model.goodPrice;
        NSString * goodNum = model.goodNum;
        _startPrice = [model.goodStartFee floatValue];
        _trancePrice = [model.goodDistributePrice floatValue];
        _allMoney = [goodNum floatValue] * [goodMoney floatValue] + _allMoney;
        _allCount+=[goodNum integerValue];
    }
    self.allMoneyLab.text = [NSString stringWithFormat:@"¥%.2f",_allMoney];
    [self addRedPointToLab:self.allMoneyLab.text label:self.allMoneyLab];
    self.allCountLab.text = [NSString stringWithFormat:@"%ld",_allCount];
    [self setFooterBtnState];
}

//设置底部按钮状态
- (void)setFooterBtnState{
    if (_allMoney>0)
    {
        _goOrderBtn.enabled = YES;
        _goOrderBtn.backgroundColor = KSYSTEM_COLOR;
        _goCarBtn.userInteractionEnabled = YES;
        _goCarBtn.backgroundColor = KSYSTEM_COLOR;
    }
    else
    {
        _goOrderBtn.enabled = NO;
        _goOrderBtn.backgroundColor = [UIColor lightGrayColor];
        _goCarBtn.userInteractionEnabled = NO;
        _goCarBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

/** 聊天界面*/
- (void)chartAction:(UIButton *)btn{
    
    WDNewsViewController *webVC = [[WDNewsViewController alloc]init];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/message.html?access_token=%@&type=2&sid=%@&pid=0",HTML5_URL,token,self.storeId];
    webVC.requestUrl = urlStr;
    [self.navigationController pushViewController:webVC animated:YES];
}

//商铺购物详情
-(NSMutableArray *)getSelectGood
{
    NSString * shopID = [[NSUserDefaults standardUserDefaults]objectForKey:@"shopID"];
    NSMutableArray * shopArr = [WDGoodList getGoodWithStoreID:shopID];
    return shopArr;
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
