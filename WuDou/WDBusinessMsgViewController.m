//
//  WDBusinessMsgViewController.m
//  WuDou
//
//  Created by huahua on 16/10/15.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDBusinessMsgViewController.h"
#import "WDGoodsListsCell.h"

@interface WDBusinessMsgViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_goodsListsTableView;
    NSMutableArray *_datasArray;
    
}

@property(nonatomic,strong)WDOrderMsgModel *msgModel;

@end

static NSString *listsId = @"WDGoodsLists";
@implementation WDBusinessMsgViewController

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    CGFloat maxY = CGRectGetMaxY(_goodsListsTableView.frame);
    if (maxY <= kScreenHeight) {
        
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    }
    else{
        
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth, maxY);
    }
    _mainScrollView.backgroundColor = kViewControllerBackgroundColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.title = @"订单详情";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
    
    _goodsListsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_orderMsgView.frame)+15, kScreenWidth, 0) style:UITableViewStylePlain];
    
    _goodsListsTableView.scrollEnabled = NO;
    _goodsListsTableView.dataSource = self;
    _goodsListsTableView.delegate = self;
    _goodsListsTableView.showsVerticalScrollIndicator = NO;
    [_goodsListsTableView registerNib:[UINib nibWithNibName:@"WDGoodsListsCell" bundle:nil] forCellReuseIdentifier:listsId];
    
    [self _loadOrderDatas];
    
    [self _setHeaderRefresh];
}


- (void)viewWillLayoutSubviews{
    
    _goodsListsTableView.height =  _datasArray.count*100 + 40 + 10;
    [_mainScrollView addSubview:_goodsListsTableView];
}

- (void)_loadOrderDatas{
    
    [WDMineManager requestStoreOrderMsgWithOid:self.orderId completion:^(WDOrderMsgModel *model, NSString *error) {
        
        if (error) {
            
            SHOW_ALERT(error)
            return ;
        }
        
        self.msgModel = model;
        
        self.orderBianhao.text = model.osn;
        self.orderTime.text = model.addtime;
        self.orderZhifuState.text = model.paysystemtype;
        self.orderState.text = model.orderstatusdescription;
        self.orderUserName.text = model.consignee;
        self.orderAddressNumber.text = model.mobile;
        self.orderAddress.text = model.address;
        self.orderMark.text = model.buyerremark;
        self.sendTime.text = model.distributionDesn;
        self.orderCount.text = [NSString stringWithFormat:@"￥%@",model.orderamount];
        self.goodsAllmoney.text = [NSString stringWithFormat:@"￥%@",model.productamount];
        self.peisongMoney.text = [NSString stringWithFormat:@"￥%@",model.shipfee];
        self.couponCount.text = [NSString stringWithFormat:@"￥%@",model.couponmoney];
        self.orderPay.text = [NSString stringWithFormat:@"￥%@",model.orderamount];
        
        NSArray *tabArr = model.data;
        _datasArray = [NSMutableArray array];
        for (NSDictionary *dic in tabArr) {
            
            WDGoodChoiceModel *goodModel = [[WDGoodChoiceModel alloc]initWithDictionary:dic];
            [_datasArray addObject:goodModel];
        }
        
        [_goodsListsTableView reloadData];
    }];
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

/** 下拉加载*/
- (void)_setHeaderRefresh{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    _mainScrollView.mj_header = header;
}
- (void)loadNewData{
    
    if (_datasArray.count > 0) {
        
        [_datasArray removeAllObjects];
        [self _loadOrderDatas];
    }
    
//    [_goodsListsTableView reloadData];
    [_mainScrollView.mj_header endRefreshing];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDGoodsListsCell *cell = [tableView dequeueReusableCellWithIdentifier:listsId forIndexPath:indexPath];
    WDGoodChoiceModel *model = _datasArray[indexPath.row];
    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    cell.goodsCount.text = [NSString stringWithFormat:@"x %@",model.buycount];
    cell.goodsDetails.text = model.name;
    cell.singlePrice.text = [NSString stringWithFormat:@"￥%@",model.shopprice];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

//  -----------------------  头视图 ---------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerV.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 20)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"商品清单";
    [headerV addSubview:label];
    
    UIImageView *fengeLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    fengeLine.image = [UIImage imageNamed:@"下划线2.png"];
    [headerV addSubview:fengeLine];
    
    return headerV;
}


@end
