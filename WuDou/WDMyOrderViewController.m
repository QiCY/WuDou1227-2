//
//  WDMyOrderViewController.m
//  WuDou
//
//  Created by huahua on 16/8/10.
//  Copyright © 2016年 os1. All rights reserved.
//  我的 -- 我的订单

#import "WDMyOrderViewController.h"
#import "WDMyOrderCell.h"
#import "WDOrderDetailsViewController.h"
#import "WDJifenDetailViewController.h"
#import "WDTabbarViewController.h"

@interface WDMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_myOrderTableView;
    NSMutableArray *_datasArray;
    NSArray *_testArray;
    
    NSInteger _page;
}
//商品图标
@property(nonatomic,strong)NSMutableArray *picImageArray;

@end

static NSString *order = @"WDMyOrderCell";
@implementation WDMyOrderViewController

- (NSMutableArray *)picImageArray{
    
    if (!_picImageArray) {
        
        _picImageArray = [NSMutableArray array];
    }
    return _picImageArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 显示导航栏
    self.navigationController.navigationBarHidden = NO;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [self _loadDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.title = @"我的订单";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
    
    _page = 1;
    
    _myOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 69) style:UITableViewStylePlain];
    _myOrderTableView.backgroundColor = [UIColor whiteColor];
    _myOrderTableView.delegate = self;
    _myOrderTableView.dataSource = self;
    _myOrderTableView.showsVerticalScrollIndicator = NO;
    [_myOrderTableView registerNib:[UINib nibWithNibName:@"WDMyOrderCell" bundle:nil] forCellReuseIdentifier:order];
    
    [self.view addSubview:_myOrderTableView];
    
    [self _setHeaderRefresh];
    [self _getMoreDatas];
    
    // 加入长按手势
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGR.minimumPressDuration = 0.2;
    [_myOrderTableView addGestureRecognizer:longPressGR];
}

// 长按删除的方法
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer

{
    CGPoint point = [gestureRecognizer locationInView:_myOrderTableView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        
    {
        //  弹窗
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"删除该订单？" preferredStyle:UIAlertControllerStyleAlert];
        
        //  取消
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        
        //  确认
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSIndexPath * indexPath = [_myOrderTableView indexPathForRowAtPoint:point];
            
            WDOrderListModel *model = _datasArray[indexPath.section];
            
            [WDMineManager requestDeleteMyOrderWithOid:model.oid completion:^(NSString *result, NSString *error) {
                
                if (error) {
                    
                    SHOW_ALERT(error)
                    return ;
                }
                SHOW_ALERT(result)
                [self _loadDatas];
            }];
            
        }];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];  //用模态的方法显示对话框
    }
    
}

- (void)_loadDatas{
    
    [WDMineManager requestOrderListWithCurrentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            
//            SHOW_ALERT(error)
            [self _createNodatasIcon];
            [SVProgressHUD dismiss];
            return ;
        }
        
        [SVProgressHUD dismiss];
        _datasArray = array;
        
        [_myOrderTableView reloadData];
        
        [_myOrderTableView.mj_header endRefreshing];
    }];
}

/** 提示暂时数据*/
- (void)_createNodatasIcon{
    
    [_myOrderTableView removeFromSuperview];
    
    UIView *noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 60)];
    noticeView.center = self.view.center;
    noticeView.centerY = self.view.centerY - 30;
    [self.view addSubview:noticeView];
    
    UIImageView *noticeImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 33)];
    noticeImage.image = [UIImage imageNamed:@"noData"];
    [noticeView addSubview:noticeImage];
    
    UILabel *noticeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 70, 20)];
    noticeText.text = @"暂无数据";
    noticeText.font = [UIFont systemFontOfSize:15.0];
    noticeText.textAlignment = NSTextAlignmentCenter;
    noticeText.textColor = [UIColor lightGrayColor];
    [noticeView addSubview:noticeText];
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
}

- (void)goBackAction
{
    if (self.istype == 1)
    {
        self.istype = 0;
        UIWindow * window = [[UIApplication sharedApplication].delegate window];
        WDTabbarViewController * tabbar = [[WDTabbarViewController alloc]init];
        tabbar.selectedIndex = 3;
        window.rootViewController = tabbar;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/** 下拉加载*/
- (void)_setHeaderRefresh{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    _myOrderTableView.mj_header = header;
}
- (void)loadNewData{
    
    if (_datasArray.count > 0) {
        
        [_datasArray removeAllObjects];
        [self _loadDatas];
    }
    
//    [_myOrderTableView reloadData];
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
    _myOrderTableView.mj_footer = footer;
}

- (void)loadMore{
    
    _page ++;
    NSLog(@"_page = %ld",_page);
    
    [WDMineManager requestOrderListWithCurrentPage:[NSString stringWithFormat:@"%ld",_page] completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            
            [_myOrderTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        NSMutableArray *moreArr = array;
        [_datasArray addObjectsFromArray:moreArr];
        
        [_myOrderTableView reloadData];
        
        [_myOrderTableView.mj_footer endRefreshing];
        
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_datasArray.count > 0) {
        
        return _datasArray.count;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_datasArray.count > 0) {
        
        WDMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:order forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WDOrderListModel *model = _datasArray[indexPath.section];
        NSString *states = model.paysate;
        NSArray *array = model.productsdata;
        [self.picImageArray removeAllObjects];
        for (NSDictionary *modelDic in array) {
            
            WDProductsDataModel *dataModel = [[WDProductsDataModel alloc]initWithDictionary:modelDic];
//            cell.pid = dataModel.pid;
            [self.picImageArray addObject:dataModel.img];
        }
        cell.orderPicImages = self.picImageArray;
        cell.orderStr = model.osn;
        cell.storeName.text = model.storename;
        
        if ([model.ordertype isEqualToString:@"1"]) {  //显示兑换积分
//            cell.isJifenPid = 1;
            cell.showZhifuStateView.hidden = YES;
            cell.showLabel.text = @"兑换积分:";
            cell.shouldPay.text = [NSString stringWithFormat:@"%@",model.creditsvalue];
        }
        else{  //显示应付金额
            
            cell.showZhifuStateView.hidden = NO;
            cell.showLabel.text = @"应付金额:";
            cell.shouldPay.text = [NSString stringWithFormat:@"￥%@",model.surplusmoney];
        }
        
        cell.orderTime.text = model.addtime;
        cell.myOrderVC = self;
        cell.storeid = model.storeid;
        cell.oid = model.oid;
        cell.isReview = model.isreviews;
        cell.judgeText = model.reviewstext;
        cell.zhifuState.text = model.orderstatusdescription;
        int state = [states intValue];
        cell.isZhiFuEnabled = state;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_datasArray.count > 0) {
        
        WDOrderListModel *model = _datasArray[indexPath.section];
        if ([model.ordertype isEqualToString:@"1"]) {
            
            return 179;
        }
        else{
            
            return 205;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else
        
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDOrderListModel *model = _datasArray[indexPath.section];
    NSString *orderId = model.oid;
    
    if ([model.ordertype isEqualToString:@"1"]) {
        
        WDJifenDetailViewController *jifenVC = [[WDJifenDetailViewController alloc] init];
        jifenVC.orderId = orderId;
        [self.navigationController pushViewController:jifenVC animated:YES];
        
    }
    else{
        
        WDOrderDetailsViewController *orderDetailsVC = [[WDOrderDetailsViewController alloc]init];
        orderDetailsVC.orderId = orderId;
        [self.navigationController pushViewController:orderDetailsVC animated:YES];
    }
    
}

@end
