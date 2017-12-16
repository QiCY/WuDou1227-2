//
//  WDUsedGoodsViewController.m
//  WuDou
//
//  Created by huahua on 16/8/16.
//  Copyright © 2016年 os1. All rights reserved.
//  首页 -- 二手品专区

#import "WDUsedGoodsViewController.h"
#import "WDLunBoView.h"
#import "WDConvenienceServicesCell.h"
#import "WDServiceDetailViewController.h"
#import "WDOrderListView.h"
//#import "WDPublishMsgViewController.h"
#import "WDSecondPublishViewController.h"
#import "WDNearDetailsViewController.h"
#import "WDGoodsInfoViewController.h"
#import "WDDetailsViewController.h"

#define kLEFTCATE @"leftCate"
#define kMIDDLECATE @"middleCate"
#define kRIGHTCATE @"rightCate"

@interface WDUsedGoodsViewController ()<WDLunBoViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_lunboDatasArr;
    NSMutableArray *_bigArray;
    NSMutableArray *_leftArray;
    NSMutableArray *_leftCodeArray;
    NSMutableArray *_middleArray;
    NSMutableArray *_middleCodeArray;
    NSMutableArray *_rightArray;
    NSMutableArray *_rightCodeArray;
    
    WDLunBoView *_usedGoodsLunboView;
    WDOrderListView *_leftBtn;
    WDOrderListView *_middleBtn;
    WDOrderListView *_rightBtn;
    
    UIControl *_leftControl;
    UIControl *_middleControl;
    UIControl *_rightControl;
    
    UITableView *_leftTV;
    UITableView *_middleTV;
    UITableView *_rightTV;
    
    BOOL _leftSelect;
    BOOL _middleSelect;
    BOOL _rightSelect;
    
    NSInteger _page;
}

/** 轮播图片数组*/
@property(nonatomic,strong)NSMutableArray *lunboArray;
/** 产品数组*/
@property(nonatomic,strong)NSMutableArray *productsArray;
/** noticeView*/
@property(nonatomic,strong)UIView *noticeView;

@end

static NSString *usedGoods = @"usedGoods";

@implementation WDUsedGoodsViewController
/** lazy*/
- (UIView *)noticeView{
    
    if (_noticeView == nil) {
        
        [self _createNodatasIcon];
    }
    return _noticeView;
}

/** 提示暂时数据*/
- (void)_createNodatasIcon{

    _noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
    _noticeView.centerY = self.view.center.y;
    [self.view addSubview:_noticeView];
    
    UIImageView *noticeImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-30)*0.5, 0, 30, 33)];
    noticeImage.image = [UIImage imageNamed:@"noData"];
    [_noticeView addSubview:noticeImage];
    
    UILabel *noticeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 20)];
    noticeText.text = @"暂无搜索记录";
    noticeText.font = [UIFont systemFontOfSize:15.0];
    noticeText.textAlignment = NSTextAlignmentCenter;
    noticeText.textColor = [UIColor lightGrayColor];
    [_noticeView addSubview:noticeText];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    if (_leftSelect) {
        [_leftTV removeFromSuperview];
    }
    if (_middleSelect) {
        [_middleTV removeFromSuperview];
    }
    if (_rightSelect) {
        [_rightTV removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupNavigation];
    
    self.title = @"二手品专区";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.usedGoodsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 显示指示器
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    _page = 1;
    
    [self _loadDatas];
    
    [self _setUIview];
    [self _getMoreDatas];
}

- (NSMutableArray *)lunboArray{
    
    if (!_lunboArray) {
        
        _lunboArray = [NSMutableArray array];
    }
    
    return _lunboArray;
}

- (void)_loadDatas{
    
    [WDMainRequestManager requestLoadSecondStoreMainDatasWithRegion:@"" money:@"" sate:@"" keyValue:@"" currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
       
        [SVProgressHUD dismiss];
        
        if (error) {
            
            SHOW_ALERT(error)
            [SVProgressHUD dismiss];
            return ;
        }
        
        _bigArray = array;
        
        NSMutableArray *leftName = [NSMutableArray array];
        NSMutableArray *leftCode = [NSMutableArray array];
        for (WDCategoryModel *model in _bigArray[0]) {
            
            NSString *name = model.name;
            NSString *code = model.code;
            
            [leftName addObject:name];
            [leftCode addObject:code];
        }
        _leftArray = leftName;
        _leftCodeArray = leftCode;
        [[NSUserDefaults standardUserDefaults] setObject:_leftCodeArray[0] forKey:kLEFTCATE];
        
        [_leftTV reloadData];
        
        NSMutableArray *middleName = [NSMutableArray array];
        NSMutableArray *middleCode = [NSMutableArray array];
        for (WDCategoryModel *model in _bigArray[1]) {
            
            NSString *name = model.name;
            NSString *code = model.code;
            
            [middleName addObject:name];
            [middleCode addObject:code];
        }
        _middleArray = middleName;
        _middleCodeArray = middleCode;
        [[NSUserDefaults standardUserDefaults] setObject:_middleCodeArray[0] forKey:kMIDDLECATE];
        
        [_middleTV reloadData];
        
        NSMutableArray *rightName = [NSMutableArray array];
        NSMutableArray *rightCode = [NSMutableArray array];
        for (WDCategoryModel *model in _bigArray[2]) {
            
            NSString *name = model.name;
            NSString *code = model.code;
            
            [rightName addObject:name];
            [rightCode addObject:code];
        }
        _rightArray = rightName;
        _rightCodeArray = rightCode;
        [[NSUserDefaults standardUserDefaults] setObject:_rightCodeArray[0] forKey:kRIGHTCATE];
        
        [_rightTV reloadData];
        
        self.productsArray = _bigArray[3];
        [self.usedGoodsTableView reloadData];
        
    }];
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
     [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12,45)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
    
    //  右侧发布信息按钮
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
    [rightBtn setTitle:@"发布信息" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(publishNews:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)publishNews:(UIButton *)btn{
    
    NSLog(@"前往 发布信息");
    WDSecondPublishViewController *publishMsgVC = [[WDSecondPublishViewController alloc]init];
    [self.navigationController pushViewController:publishMsgVC animated:YES];
}

/** 上拉加载更多*/
- (void)_getMoreDatas{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    footer.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    //    [header beginRefreshing];
    
    // 设置header
    self.usedGoodsTableView.mj_footer = footer;
}

- (void)loadMore{
    
    _page ++;
    NSLog(@"_page = %ld",_page);
    
    NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kLEFTCATE];
    NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:kMIDDLECATE];
    NSString *str3 = [[NSUserDefaults standardUserDefaults] objectForKey:kRIGHTCATE];
    
    [WDMainRequestManager requestLoadSecondStoreMainDatasWithRegion:str1 money:str2 sate:str3 keyValue:nil currentPage:[NSString stringWithFormat:@"%ld",_page] completion:^(NSMutableArray *array, NSString *error) {
       
        if (error) {
            SHOW_ALERT(error)
            [self.usedGoodsTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        NSMutableArray *moreArr = array;
        NSMutableArray *moreTableViewArr = moreArr[3];
        if (moreTableViewArr.count == 0) {
            
            //  提示没有更多的数据
            [self.usedGoodsTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self.productsArray addObjectsFromArray:moreTableViewArr];
        
        [self.usedGoodsTableView reloadData];
        
        [self.usedGoodsTableView.mj_footer endRefreshing];
        
    }];
}

//  设置界面
- (void)_setUIview{
    
    // 轮播图
//    _usedGoodsLunboView = [WDLunBoView lunBoViewWithFrame:CGRectMake(0, _usedGoodsLunbo.frame.origin.y-44, kScreenWidth, _usedGoodsLunbo.frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"noproduct.png"]];
////    _usedGoodsLunboView.imageURLStringsGroup = _lunboArray;
//    _usedGoodsLunboView.autoScrollTimeInterval = 2.0f;
//    _usedGoodsLunboView.showPageControl = YES;
//    _usedGoodsLunboView.pageControlBottomOffset = -12;
//    _usedGoodsLunboView.pageControlAliment = WDLunBoViewPageContolAlimentCenter;
//    _usedGoodsLunboView.currentPageDotColor = ;
//    _usedGoodsLunboView.pageDotColor = [UIColor lightGrayColor];
//    [_usedGoodsLunbo addSubview:_usedGoodsLunboView];
    
    // 创建下拉列表视图
    [self _createOrderListView];
    
    // 底部tableview
    _usedGoodsTableView.delegate = self;
    _usedGoodsTableView.dataSource = self;
    _usedGoodsTableView.tag = 444;
    [_usedGoodsTableView registerNib:[UINib nibWithNibName:@"WDConvenienceServicesCell" bundle:nil] forCellReuseIdentifier:usedGoods];
    
    _usedGoodsSearchBar.delegate = self;
    
}

// 创建下拉列表视图 /
- (void)_createOrderListView{
    
    CGFloat itemWidth = (kScreenWidth - 2) / 3.0;
    
    _leftBtn = [[WDOrderListView alloc]initWithFrame:CGRectMake(0, 10, itemWidth, 30)];
    _leftBtn.orderListTitle = @"区域";  //默认title
    [_leftBtn setOrderListImageName:@"下拉三角"];
    [_usedGoodsBtnView addSubview:_leftBtn];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftBtn.frame), 15, 1, 20)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [_usedGoodsBtnView addSubview:line1];
    
    _middleBtn = [[WDOrderListView alloc]initWithFrame:CGRectMake(itemWidth, 10, itemWidth, 30)];
    _middleBtn.orderListTitle = @"价格";  //默认title
    _middleBtn.orderListImageName = @"下拉三角";
    [_usedGoodsBtnView addSubview:_middleBtn];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_middleBtn.frame), 15, 1, 20)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [_usedGoodsBtnView addSubview:line2];
    
    _rightBtn = [[WDOrderListView alloc]initWithFrame:CGRectMake(itemWidth*2, 10, itemWidth, 30)];
    _rightBtn.orderListTitle = @"不限";  //默认title
    _rightBtn.orderListImageName = @"下拉三角";
    [_usedGoodsBtnView addSubview:_rightBtn];
    
    
    [self _setLeftMiddleAndRightOrderList];
}

//  设置左中右三个下拉列表按钮
- (void)_setLeftMiddleAndRightOrderList{
    
    _leftControl = [[UIControl alloc]initWithFrame:_leftBtn.frame];
    _leftControl.backgroundColor = [UIColor clearColor];
    [_leftControl addTarget:self action:@selector(leftContrAction:) forControlEvents:UIControlEventTouchUpInside];
    _leftControl.selected = YES;
    [_usedGoodsBtnView addSubview:_leftControl];
    
    _middleControl = [[UIControl alloc]initWithFrame:_middleBtn.frame];
    _middleControl.backgroundColor = [UIColor clearColor];
    [_middleControl addTarget:self action:@selector(middleContrAction:) forControlEvents:UIControlEventTouchUpInside];
    _middleControl.selected = YES;
    [_usedGoodsBtnView addSubview:_middleControl];
    
    _rightControl = [[UIControl alloc]initWithFrame:_rightBtn.frame];
    _rightControl.backgroundColor = [UIColor clearColor];
    [_rightControl addTarget:self action:@selector(rightContrAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightControl.selected = YES;
    [_usedGoodsBtnView addSubview:_rightControl];
    
}

//  左
- (void)leftContrAction:(UIControl *)left{
    
    //  改变按钮的选中状态
    _leftSelect = !_leftSelect;
    
    //  根据按钮的选中状态设置下拉列表的收与合
    if (_leftSelect == YES) {
        
        [UIView animateWithDuration:0.5 animations:^{  // 动画可要可不要
            
            _leftBtn.orderListImageName = @"上拉三角";
            _leftTV = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_leftBtn.frame), CGRectGetMaxY(_usedGoodsBtnView.frame), _leftBtn.bounds.size.width, kScreenHeight - CGRectGetMaxY(_usedGoodsBtnView.frame)-64) style:UITableViewStylePlain];
            _leftTV.layer.borderWidth = 1.5;
            _leftTV.layer.borderColor = kViewControllerBackgroundColor.CGColor;
            _leftTV.tag = 111;  // 这里根据tag值来获取不同的tableview
            _leftTV.delegate = self;
            _leftTV.dataSource = self;
            _leftTV.showsVerticalScrollIndicator = NO;
            [self.view addSubview:_leftTV];
            
        }];
        
        if (_middleTV)
        {
            _middleBtn.orderListImageName = @"下拉三角";
            [_middleTV removeFromSuperview];
            _middleSelect = NO;
        }
        if (_rightTV)
        {
            _rightBtn.orderListImageName = @"下拉三角";
            [_rightTV removeFromSuperview];
            _rightSelect = NO;
        }
    }else{
        
        _leftBtn.orderListImageName = @"下拉三角";
        [_leftTV removeFromSuperview];
    }
    
    //  收回键盘
    [self.view endEditing:YES];
}
//  中
- (void)middleContrAction:(UIControl *)middle{
    
    _middleSelect = !_middleSelect;
    //  根据按钮的选中状态设置下拉列表的收与合
    if (_middleSelect == YES) {
        
        [UIView animateWithDuration:0.5 animations:^{  // 动画可要可不要
            
            _middleBtn.orderListImageName = @"上拉三角";
            _middleTV = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_middleBtn.frame), CGRectGetMaxY(_usedGoodsBtnView.frame), _middleBtn.bounds.size.width, 44*_middleArray.count) style:UITableViewStylePlain];
            _middleTV.layer.borderWidth = 1.5;
            _middleTV.layer.borderColor = kViewControllerBackgroundColor.CGColor;
            _middleTV.tag = 222;  // 这里根据tag值来获取不同的tableview
            _middleTV.delegate = self;
            _middleTV.dataSource = self;
            _middleTV.showsVerticalScrollIndicator = NO;
            [self.view addSubview:_middleTV];
            
        }];
        if (_leftTV)
        {
            _leftBtn.orderListImageName = @"下拉三角";
            [_leftTV removeFromSuperview];
            _leftSelect = NO;
        }
        if (_rightTV)
        {
            _rightBtn.orderListImageName = @"下拉三角";
            [_rightTV removeFromSuperview];
            _rightSelect = NO;
        }
        
    }else{
        
        _middleBtn.orderListImageName = @"下拉三角";
        [_middleTV removeFromSuperview];
    }
    
    //  收回键盘
    [self.view endEditing:YES];
}
//  右
- (void)rightContrAction:(UIControl *)right{
    
    _rightSelect = !_rightSelect;
    //  根据按钮的选中状态设置下拉列表的收与合
    if (_rightSelect == YES) {
        
        [UIView animateWithDuration:0.5 animations:^{  // 动画可要可不要
            
            _rightBtn.orderListImageName = @"上拉三角";
            _rightTV = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_rightBtn.frame), CGRectGetMaxY(_usedGoodsBtnView.frame), _rightBtn.bounds.size.width, 44 * _rightArray.count) style:UITableViewStylePlain];
            _rightTV.layer.borderWidth = 1.5;
            _rightTV.layer.borderColor = kViewControllerBackgroundColor.CGColor;
            _rightTV.tag = 333;  // 这里根据tag值来获取不同的tableview
            _rightTV.delegate = self;
            _rightTV.dataSource = self;
            _rightTV.showsVerticalScrollIndicator = NO;
            [self.view addSubview:_rightTV];
            
        }];
        if (_leftTV)
        {
            _leftBtn.orderListImageName = @"下拉三角";
            [_leftTV removeFromSuperview];
            _leftSelect = NO;
        }
        if (_middleTV)
        {
            _middleBtn.orderListImageName = @"下拉三角";
            [_middleTV removeFromSuperview];
            _middleSelect = NO;
        }
    }else{
        
        _rightBtn.orderListImageName = @"下拉三角";
        [_rightTV removeFromSuperview];
    }
    
    //  收回键盘
    [self.view endEditing:YES];
}

#pragma mark - <WDLunBoViewDelegate>
//- (void)cycleScrollView:(WDLunBoView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    
//    WDAdvertisementModel *model1 = _lunboDatasArr[index];
//    
//    NSString *type1 = model1.urltype;
//    if ([type1 isEqualToString:@"1"]) {
//        
//        WDNearDetailsViewController *nearVC = [[WDNearDetailsViewController alloc]init];
//        NSString *storeId = model1.url;
//        nearVC.storeId = storeId;
//        [WDRequestManager saveStrData:storeId withStr:@"shopID"];
//        [self.navigationController pushViewController:nearVC animated:YES];
//    }else{
//        
//        WDGoodsInfoViewController *infosVC = [[WDGoodsInfoViewController alloc]init];
//        NSString *goodID = model1.url;
//        infosVC.goodsID = goodID;
//        [WDRequestManager saveStrData:goodID withStr:@"goodID"];
//        infosVC.goodsImage = model1.img;
//        [self.navigationController pushViewController:infosVC animated:YES];
//    }
//    
//}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 111) {
        
        return _leftArray.count;
    }
    if (tableView.tag == 222) {
        
        return _middleArray.count;
    }
    if (tableView.tag == 333) {
        
        return _rightArray.count;
    }
    else
        //  这里应该返回 _datasArray的个数
        return self.productsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 444) {
        
        WDConvenienceServicesCell *cell = [tableView dequeueReusableCellWithIdentifier:usedGoods forIndexPath:indexPath];
        
        WDSearchInfosModel *model = self.productsArray[indexPath.row];
        
        [cell.bianmingImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        cell.bianmingGoodsName.text = model.name;
        cell.bianmingInfos.text = [NSString stringWithFormat:@"%@  发布于：%@",model.region,model.time];
        cell.goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.shopprice];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        static NSString *usedID = @"leftorright";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:usedID];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:usedID];
        }
        if (tableView.tag == 111) {
            
            cell.textLabel.text = _leftArray[indexPath.row];
            
        }if (tableView.tag == 222) {
            
            cell.textLabel.text = _middleArray[indexPath.row];
        }if (tableView.tag == 333) {
            
            cell.textLabel.text = _rightArray[indexPath.row];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 444) {
        
        return 80;
    }else
        
        return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 111) {
        
        _leftBtn.orderListTitle = _leftArray[indexPath.row]; // 重新给按钮的title赋值
        _leftBtn.orderListImageName = @"下拉三角";
        [_leftBtn setNeedsLayout];
        _leftSelect = !_leftSelect;  //  注意这里需要改变按钮的选中状态
        [_leftTV removeFromSuperview];
        
        // 这里刷新单元格数据
        // 显示指示器
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:kMIDDLECATE];
        NSString *str3 = [[NSUserDefaults standardUserDefaults] objectForKey:kRIGHTCATE];
        NSString *codeStr = _leftCodeArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:codeStr forKey:kLEFTCATE];
        
        [WDMainRequestManager requestLoadSecondStoreMainDatasWithRegion:codeStr money:str2 sate:str3 keyValue:@"" currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
           
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            _page = 1;
            self.productsArray = array[3];
            [self.usedGoodsTableView reloadData];
        
            [SVProgressHUD dismiss];
        }];
        
    }
    if (tableView.tag == 222) {
        
        _middleBtn.orderListTitle = _middleArray[indexPath.row]; // 重新给按钮的title赋值
        _middleBtn.orderListImageName = @"下拉三角";
        [_middleBtn setNeedsLayout];
        _middleSelect = !_middleSelect;  //  注意这里需要改变按钮的选中状态
        [_middleTV removeFromSuperview];
        
        // 这里刷新单元格数据;
        // 显示指示器
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kLEFTCATE];
        NSString *str3 = [[NSUserDefaults standardUserDefaults] objectForKey:kRIGHTCATE];
        NSString *codeStr = _middleCodeArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:codeStr forKey:kMIDDLECATE];
        
        [WDMainRequestManager requestLoadSecondStoreMainDatasWithRegion:str1 money:codeStr sate:str3 keyValue:@"" currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            _page = 1;
            self.productsArray = array[3];
            [self.usedGoodsTableView reloadData];
            
            [SVProgressHUD dismiss];
        }];
        
    }
    if (tableView.tag == 333) {
        
        _rightBtn.orderListTitle = _rightArray[indexPath.row]; // 重新给按钮的title赋值
        _rightBtn.orderListImageName = @"下拉三角";
        [_rightBtn setNeedsLayout];
        _rightSelect = !_rightSelect;  //  注意这里需要改变按钮的选中状态
        [_rightTV removeFromSuperview];
        
        // 这里刷新单元格数据
        // 显示指示器
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:kMIDDLECATE];
        NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kLEFTCATE];
        NSString *codeStr = _rightCodeArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:codeStr forKey:kRIGHTCATE];
        
        [WDMainRequestManager requestLoadSecondStoreMainDatasWithRegion:str1 money:str2 sate:codeStr keyValue:@"" currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            _page = 1;
            self.productsArray = array[3];
            [self.usedGoodsTableView reloadData];
            
            [SVProgressHUD dismiss];
        }];
        
    }
    
    if (tableView.tag == 444) {
        
        WDServiceDetailViewController *detailVC = [[WDServiceDetailViewController alloc]initWithTitle:@"商品详情" andShowPriceLabelEnabled:YES];
        
        WDSearchInfosModel *model = self.productsArray[indexPath.row];
        detailVC.pid = model.pid;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

#pragma mark - UISearchBarDelegate
//  点击键盘上的 search 按钮时触发
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (![searchBar.text isEqualToString:@""]) {
        
        //将关键字作为searchkey重新调用接口
        [WDMainRequestManager requestLoadSecondStoreMainDatasWithRegion:@"" money:@"" sate:@"" keyValue:searchBar.text currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            _page = 1;
            self.productsArray = array[3];
            if (self.productsArray.count > 0) {
                
                self.usedGoodsTableView.hidden = NO;
                self.noticeView.hidden = YES;
                [self.usedGoodsTableView reloadData];
            }else{
                
                self.usedGoodsTableView.hidden = YES;
                self.noticeView.hidden = NO;
            }
            
        }];

    }
    
    [searchBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

@end
