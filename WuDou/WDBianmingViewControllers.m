//
//  WDBianmingViewControllers.m
//  WuDou
//
//  Created by huahua on 16/11/4.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDBianmingViewControllers.h"
#import "WDBianmingCell.h"
#import "WDLunBoView.h"
#import "WDServiceDetailViewController.h"
#import "WDServicePublishViewController.h"
#import "WDAppInitManeger.h"
#import "WDNearDetailsViewController.h"
#import "WDGoodsInfoViewController.h"
#import "WDDetailsViewController.h"
#import "WDOrderListView.h"
#import "WDStoreDetailViewController.h"

#define kLEFTCATES @"leftcates"
#define kMIDDLECATES @"middlecates"
#define kRIGHTCATES @"rightcates"
#define kTableViewH [UIScreen mainScreen].bounds.size.height - 64 - 85

@interface WDBianmingViewControllers ()<UITableViewDelegate,UITableViewDataSource,WDLunBoViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *_lunboDatasArr;
    NSMutableArray *_bigArray;
    NSMutableArray *_leftArray;
    NSMutableArray *_leftCodeArray;
    NSMutableArray *_rightArray;
    NSMutableArray *_rightCodeArray;
    NSMutableArray *_middleArray;
    NSMutableArray *_middleCodeArray;
    
    UIScrollView *_mainScrollView;
    UITableView *_mainTableView;
    UIView *_tableHeaderView;
    WDLunBoView *_bianmingLunbo;
    WDOrderListView *_leftView;
    WDOrderListView *_middleView;
    WDOrderListView *_rightView;
    UIView *_orderListView; // 下拉列表视图
    UIControl *_leftControl;
    UIControl *_middleControl;
    UIControl *_rightControl;  // 覆盖在OrderListView上的UIControl
    UITableView *_leftTV;
    UITableView *_middleTV;
    UITableView *_rightTV;  //  下拉列表
    
    BOOL _leftSelect;
    BOOL _middleSelect;
    BOOL _rightSelect;
    
    NSInteger _page;
    CGFloat _contentY;
}
/** 轮播图片数组*/
@property(nonatomic,strong)NSMutableArray *lunboArray;
/** 产品数组*/
@property(nonatomic,strong)NSMutableArray *productsArray;
/** noticeView*/
@property(nonatomic,strong)UIView *noticeView;

@end

static NSString *string = @"WDBianmingCell";
@implementation WDBianmingViewControllers

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

- (NSMutableArray *)lunboArray{
    
    if (!_lunboArray) {
        
        _lunboArray = [NSMutableArray array];
    }
    
    return _lunboArray;
}

//- (void)viewWillLayoutSubviews{
//    
//    [super viewWillLayoutSubviews];
//    
//    _mainScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_mainTableView.frame));
//    NSLog(@"contentSize = %@",NSStringFromCGSize(_mainScrollView.contentSize));
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupNavigation];
    
    // 显示指示器
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [self _loadDatas];
    
    self.title = @"便民服务";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    _page = 1;
    _contentY = 185;
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _mainScrollView.delegate = self;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+145);
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    
    [self _setHeaderView];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableHeaderView.frame), kScreenWidth, kTableViewH) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tag = 300;
    _mainTableView.scrollEnabled = NO;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"WDBianmingCell" bundle:nil] forCellReuseIdentifier:string];
    
    [_mainScrollView addSubview:_mainTableView];
    
    [self _getMoreDatas];
    
    //  设置默认值
    _leftView.orderListTitle = @"区域";
    _leftView.orderListImageName = @"下拉三角";
    
    _middleView.orderListTitle = @"类别";
    _middleView.orderListImageName = @"下拉三角";
    
    _rightView.orderListTitle = @"不限";
    _rightView.orderListImageName = @"下拉三角";
    
    [SVProgressHUD dismiss];
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
     [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12,45)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
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
    
//    NSLog(@"前往 发布信息");
    WDServicePublishViewController *publishMsgVC = [[WDServicePublishViewController alloc]init];
    [self.navigationController pushViewController:publishMsgVC animated:YES];
}

- (void)_loadDatas{
    
    [WDMainRequestManager requestLoadConvenientAdsWithCompletion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            SHOW_ALERT(error)
            return ;
        }
        
        _lunboDatasArr = array;
        
        for (WDAdvertisementModel *model in array) {
            
            NSString *image = model.img;
            [self.lunboArray addObject:image];
        }
        
        if (self.lunboArray.count == 0) {
            
            _bianmingLunbo.imageURLStringsGroup = [NSMutableArray arrayWithObject:@"http://pic.baa.bitautotech.com/img/V2img4.baa.bitautotech.com/space/2011/03/04/b1c2da5e-52a6-4d9c-a67c-682a17fb8cb0_735_0_max_jpg.jpg"];
        }else{
            
            _bianmingLunbo.imageURLStringsGroup = self.lunboArray;
        }
    }];
    
    [WDMainRequestManager requestLoadConvenientMainDatasWithRegion:@"" sate:@"" cateId:@"" keyValue:@"" currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            
            SHOW_ALERT(error)
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
        [[NSUserDefaults standardUserDefaults] setObject:_leftCodeArray[0] forKey:kLEFTCATES];
        
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
        [[NSUserDefaults standardUserDefaults] setObject:_middleCodeArray[0] forKey:kMIDDLECATES];
        
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
        [[NSUserDefaults standardUserDefaults] setObject:_rightCodeArray[0] forKey:kRIGHTCATES];
        
//        [_rightTV reloadData];
        
//        //  设置默认值
//        _leftView.orderListTitle = _leftArray[0];
//        _leftView.orderListImageName = @"下拉三角";
//        
//        _rightView.orderListTitle = _rightArray[0];
//        _rightView.orderListImageName = @"下拉三角";
        
        self.productsArray = _bigArray[3];
        [_mainTableView reloadData];
        
    }];
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
    _mainTableView.mj_footer = footer;
}

- (void)loadMore{
    
    _page ++;
    NSLog(@"_page = %ld",_page);
    
    NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kLEFTCATES];
    NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:kMIDDLECATES];
    NSString *str3 = [[NSUserDefaults standardUserDefaults] objectForKey:kRIGHTCATES];
    
    [WDMainRequestManager requestLoadConvenientMainDatasWithRegion:str1 sate:str3 cateId:str2 keyValue:@"" currentPage:[NSString stringWithFormat:@"%ld",(long)_page] completion:^(NSMutableArray *array, NSString *error){
        
        if (error) {
            SHOW_ALERT(error)
            return ;
        }
        
        NSMutableArray *moreArr = array;
        NSMutableArray *moreTableViewArr = moreArr[3];
        
        if (moreTableViewArr.count == 0) {
            
            _page = 1;
            [_mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            
            [self.productsArray addObjectsFromArray:moreTableViewArr];
            [_mainTableView reloadData];
            [_mainTableView.mj_footer endRefreshing];
        }
    
    }];
}

- (void)_setHeaderView{
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
    
    // 搜索框
    UISearchBar *searchbbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    searchbbar.searchBarStyle = UISearchBarStyleMinimal;
    searchbbar.placeholder = @"请输入类别或关键字";
    searchbbar.delegate = self;
    [_tableHeaderView addSubview:searchbbar];
    
    // 轮播图
//    CGFloat lunboH = kScreenWidth / 3.4;
//    _bianmingLunbo = [WDLunBoView lunBoViewWithFrame:CGRectMake(0, 44, kScreenWidth, lunboH) delegate:self placeholderImage:[UIImage imageNamed:@"noproduct.png"]];
//    _bianmingLunbo.autoScrollTimeInterval = 2.0f;
//    _bianmingLunbo.showPageControl = YES;
//    _bianmingLunbo.pageControlBottomOffset = -12;
//    _bianmingLunbo.pageControlAliment = WDLunBoViewPageContolAlimentCenter;
//    _bianmingLunbo.currentPageDotColor = ;
//    _bianmingLunbo.pageDotColor = [UIColor lightGrayColor];
//    [_tableHeaderView addSubview:_bianmingLunbo];
    
    // 下拉列表视图
    _orderListView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 40)];
    _orderListView.backgroundColor = [UIColor whiteColor];
    
    CGFloat itemWidth = (kScreenWidth - 2) / 3.0;
    
    //左侧
    _leftView = [[WDOrderListView alloc] initWithFrame:CGRectMake(0, 5, itemWidth, 30)];
    [_orderListView addSubview:_leftView];
    
    //竖向分隔线
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame), 10, 1, 20)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [_orderListView addSubview:line1];
    
    //中间
    _middleView = [[WDOrderListView alloc]initWithFrame:CGRectMake(itemWidth, 5, itemWidth, 30)];
    [_orderListView addSubview:_middleView];
    
    //竖向分隔线
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_middleView.frame), 10, 1, 20)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [_orderListView addSubview:line2];

    //右侧
    _rightView = [[WDOrderListView alloc] initWithFrame:CGRectMake(itemWidth*2, 5, itemWidth, 30)];
    [_orderListView addSubview:_rightView];
    
    [_tableHeaderView addSubview:_orderListView];
    
    //  设置下拉列表按钮
    [self _setLeftAndRightOrderList];
    
    [_mainScrollView addSubview:_tableHeaderView];
}

//  设置下拉列表按钮
- (void)_setLeftAndRightOrderList{
    
    _leftControl = [[UIControl alloc]initWithFrame:_leftView.frame];
    _leftControl.backgroundColor = [UIColor clearColor];
    [_leftControl addTarget:self action:@selector(leftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    _leftControl.selected = YES;
    [_orderListView addSubview:_leftControl];
    
    _middleControl = [[UIControl alloc]initWithFrame:_middleView.frame];
    _middleControl.backgroundColor = [UIColor clearColor];
    [_middleControl addTarget:self action:@selector(middleContrAction:) forControlEvents:UIControlEventTouchUpInside];
    _middleControl.selected = YES;
    [_orderListView addSubview:_middleControl];
    
    _rightControl = [[UIControl alloc]initWithFrame:_rightView.frame];
    _rightControl.backgroundColor = [UIColor clearColor];
    [_rightControl addTarget:self action:@selector(rightControlAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightControl.selected = YES;
    [_orderListView addSubview:_rightControl];
    
}

//  左侧下拉列表
- (void)leftControlAction:(UIControl *)sender {
    //  改变按钮的选中状态
    _leftSelect = !_leftSelect;
    
    //  根据按钮的选中状态设置下拉列表的收与合
    if (_leftSelect == YES) {
        
        [UIView animateWithDuration:0.5 animations:^{  // 动画可要可不要
            
            _leftView.orderListImageName = @"上拉三角";
            _leftTV = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_leftView.frame), _contentY, _leftView.bounds.size.width, kScreenHeight*0.5) style:UITableViewStylePlain];
            _leftTV.layer.borderWidth = 1.5;
            _leftTV.layer.borderColor = kViewControllerBackgroundColor.CGColor;
            _leftTV.tag = 100;  // 这里根据tag值来获取不同的tableview
            _leftTV.delegate = self;
            _leftTV.dataSource = self;
            _leftTV.showsVerticalScrollIndicator = NO;
            [self.view addSubview:_leftTV];
            
        }];
        if (_rightTV)
        {
            _rightView.orderListImageName = @"下拉三角";
            [_rightTV removeFromSuperview];
            _rightSelect = NO;
        }
        if (_middleTV) {
            
            _middleView.orderListImageName = @"下拉三角";
            [_middleTV removeFromSuperview];
            _middleSelect = NO;
        }
    }else{
        _leftView.orderListImageName = @"下拉三角";
        [_leftTV removeFromSuperview];
    }
    
    //  收回键盘
    [self.view endEditing:YES];
}
//  中间下拉列表
- (void)middleContrAction:(UIControl *)middle{
    
    _middleSelect = !_middleSelect;
    //  根据按钮的选中状态设置下拉列表的收与合
    if (_middleSelect == YES) {
        
        [UIView animateWithDuration:0.5 animations:^{  // 动画可要可不要
            
            _middleView.orderListImageName = @"上拉三角";
            _middleTV = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_middleView.frame), _contentY, _middleView.bounds.size.width, kScreenHeight*0.5) style:UITableViewStylePlain];
            _middleTV.layer.borderWidth = 1.5;
            _middleTV.layer.borderColor = kViewControllerBackgroundColor.CGColor;
            _middleTV.tag = 150;  // 这里根据tag值来获取不同的tableview
            _middleTV.delegate = self;
            _middleTV.dataSource = self;
            _middleTV.showsVerticalScrollIndicator = NO;
            [self.view addSubview:_middleTV];
            
        }];
        if (_leftTV)
        {
            _leftView.orderListImageName = @"下拉三角";
            [_leftTV removeFromSuperview];
            _leftSelect = NO;
        }
        if (_rightTV)
        {
            _rightView.orderListImageName = @"下拉三角";
            [_rightTV removeFromSuperview];
            _rightSelect = NO;
        }
        
    }else{
        
        _middleView.orderListImageName = @"下拉三角";
        [_middleTV removeFromSuperview];
    }
    
    //  收回键盘
    [self.view endEditing:YES];
}

//  右侧下拉列表
- (void)rightControlAction:(UIControl *)sender {
    
    _rightSelect = !_rightSelect;
    
    if (_rightSelect == YES) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _rightView.orderListImageName = @"上拉三角";
            _rightTV = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_rightView.frame), _contentY, _rightView.bounds.size.width, _rightArray.count*44) style:UITableViewStylePlain];
            
            _rightTV.layer.borderWidth = 1.5;
            _rightTV.layer.borderColor = kViewControllerBackgroundColor.CGColor;
            _rightTV.tag = 200;
            _rightTV.delegate = self;
            _rightTV.dataSource = self;
            _rightTV.showsVerticalScrollIndicator = NO;
            [self.view addSubview:_rightTV];
            
        }];
        if (_leftTV)
        {
            _leftView.orderListImageName = @"下拉三角";
            [_leftTV removeFromSuperview];
            _leftSelect = NO;
        }
        if (_middleTV) {
            
            _middleView.orderListImageName = @"下拉三角";
            [_middleTV removeFromSuperview];
            _middleSelect = NO;
        }
    }else{
        
        _rightView.orderListImageName = @"下拉三角";
        [_rightTV removeFromSuperview];
    }
    
    //  收回键盘
    [self.view endEditing:YES];
}

#pragma mark - <WDLunBoViewDelegate>
- (void)cycleScrollView:(WDLunBoView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    WDAdvertisementModel *model1 = _lunboDatasArr[index];
    
    NSString *type1 = model1.urltype;
    if ([type1 isEqualToString:@"1"]) {
        
//        WDNearDetailsViewController *nearVC = [[WDNearDetailsViewController alloc]init];
        WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
        nearVC.type = 1;
        NSString *storeId = model1.url;
        nearVC.storeId = storeId;
        [WDAppInitManeger saveStrData:storeId withStr:@"shopID"];
        [self.navigationController pushViewController:nearVC animated:YES];
    }else{
        
        WDGoodsInfoViewController *infosVC = [[WDGoodsInfoViewController alloc]init];
        NSString *goodID = model1.url;
        infosVC.goodsID = goodID;
        [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
        infosVC.goodsImage = model1.img;
        [self.navigationController pushViewController:infosVC animated:YES];
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 100) {
        
        return _leftArray.count;
    }
    if (tableView.tag == 150) {
        
        return _middleArray.count;
    }
    if (tableView.tag == 200) {
        
        return _rightArray.count;
    }else
        
        //  这里应该返回 _datasArray的个数
        return self.productsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 300) {
        
        WDBianmingCell *cell = [tableView dequeueReusableCellWithIdentifier:string forIndexPath:indexPath];
        
        WDSearchInfosModel *model = self.productsArray[indexPath.row];
        [cell.bmImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        cell.bianmingTitle.text = model.name;
        cell.bianmingInfos.text = [NSString stringWithFormat:@"%@  发布于：%@",model.region,model.time];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        
        static NSString *menu = @"leftorright";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menu];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menu];
        }
        if (tableView.tag == 100) {
            
            cell.textLabel.text = _leftArray[indexPath.row];
        }
        if (tableView.tag == 150) {
            
            cell.textLabel.text = _middleArray[indexPath.row];
        }
        if (tableView.tag == 200) {
            
            cell.textLabel.text = _rightArray[indexPath.row];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 300) {
        
        return 80;
    }else
        
        return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 100) {
        
        _leftView.orderListTitle = _leftArray[indexPath.row]; // 重新给按钮的title赋值
        _leftView.orderListImageName = @"下拉三角";
        [_leftView setNeedsLayout];
        _leftSelect = !_leftSelect;  //  注意这里需要改变按钮的选中状态
        [_leftTV removeFromSuperview];
        
        // 这里刷新单元格数据
        // 显示指示器
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:kMIDDLECATES];
        NSString *str3 = [[NSUserDefaults standardUserDefaults] objectForKey:kRIGHTCATES];
        NSString *codeStr = _leftCodeArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:codeStr forKey:kLEFTCATES];
        
        [WDMainRequestManager requestLoadConvenientMainDatasWithRegion:codeStr sate:str3  cateId:str2 keyValue:@"" currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            _page = 1;
            self.productsArray = array[3];
            [_mainTableView reloadData];
            
            [SVProgressHUD dismiss];
        }];
        
    }
    if (tableView.tag == 150) {
        
        _middleView.orderListTitle = _middleArray[indexPath.row]; // 重新给按钮的title赋值
        _middleView.orderListImageName = @"下拉三角";
        [_middleView setNeedsLayout];
        _middleSelect = !_middleSelect;  //  注意这里需要改变按钮的选中状态
        [_middleTV removeFromSuperview];
        
        // 这里刷新单元格数据;
        // 显示指示器
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kLEFTCATES];
        NSString *str3 = [[NSUserDefaults standardUserDefaults] objectForKey:kRIGHTCATES];
        NSString *codeStr = _middleCodeArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:codeStr forKey:kMIDDLECATES];
        
        [WDMainRequestManager requestLoadConvenientMainDatasWithRegion:str1 sate:str3  cateId:codeStr keyValue:@"" currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            _page = 1;
            self.productsArray = array[3];
            [_mainTableView reloadData];
            
            [SVProgressHUD dismiss];
        }];
        
    }
    if (tableView.tag == 200) {
        
        _rightView.orderListTitle = _rightArray[indexPath.row];
        _rightView.orderListImageName = @"下拉三角";
        [_rightView setNeedsLayout];
        _rightSelect = !_rightSelect;
        [_rightTV removeFromSuperview];
        
        // 显示指示器
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kLEFTCATES];
        NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:kMIDDLECATES];
        NSString *codeStr = _rightCodeArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:codeStr forKey:kRIGHTCATES];
        
        [WDMainRequestManager requestLoadConvenientMainDatasWithRegion:str1 sate:codeStr  cateId:str2 keyValue:@"" currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            _page = 1;
            self.productsArray = array[3];
            [_mainTableView reloadData];
            
            [SVProgressHUD dismiss];
        }];
    }
    
    if (tableView.tag == 300) {
        
        WDServiceDetailViewController *detailVC = [[WDServiceDetailViewController alloc]initWithTitle:@"服务详情" andShowPriceLabelEnabled:NO];
        
        WDSearchInfosModel *model = self.productsArray[indexPath.row];
        detailVC.newsid = model.newsid;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _mainScrollView) {
        
        CGFloat contentY = scrollView.contentOffset.y;
        
        if (contentY > 144) {
            _mainTableView.height = kScreenHeight - 40 - 64;
            _mainTableView.scrollEnabled = YES;
            _orderListView.y = 0;
            _contentY = 40;
            [self.view addSubview:_orderListView];
        }else
        {
            _mainTableView.scrollEnabled = NO;
            if (contentY >= 0) {
            
                _mainTableView.height = kTableViewH + contentY;
                _contentY = 185 - contentY;
            }
            _orderListView.frame = CGRectMake(0, 144, kScreenWidth, 40);
            [_tableHeaderView addSubview:_orderListView];
        }
    }
}

#pragma mark - UISearchBarDelegate
//  点击键盘上的 search 按钮时触发
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (![searchBar.text isEqualToString:@""]) {
        
        //将关键字作为searchkey重新调用接口
        [WDMainRequestManager requestLoadConvenientMainDatasWithRegion:@"" sate:@"" cateId:@"" keyValue:searchBar.text currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            _page = 1;
            self.productsArray = array[2];
            if (self.productsArray.count > 0) {
                
                _mainTableView.hidden = NO;
                self.noticeView.hidden = YES;
                [_mainTableView reloadData];
            }else{
                
                _mainTableView.hidden = YES;
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
