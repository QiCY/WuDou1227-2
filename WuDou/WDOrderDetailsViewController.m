//
//  WDOrderDetailsViewController.m
//  WuDou
//
//  Created by huahua on 16/8/10.
//  Copyright © 2016年 os1. All rights reserved.
//  我的 -- 全部订单 -- 订单详情

#import "WDOrderDetailsViewController.h"
#import "WDGoodsListsCell.h"
#import "WDPayViewController.h"
#import "WDApplyRefundViewController.h"

@interface WDOrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_goodsListsTableView;
    NSMutableArray *_datasArray;
    
}

@property(nonatomic,strong)WDOrderMsgModel *msgModel;

@end

static NSString *lists = @"WDGoodsListsCell";
@implementation WDOrderDetailsViewController

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    CGFloat maxY = CGRectGetMaxY(_goodsListsTableView.frame);
    if (maxY <= kScreenHeight) {
        
        _orderDetailsSV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    }
    else{
        
        _orderDetailsSV.contentSize = CGSizeMake(kScreenWidth, maxY);
    }
    _orderDetailsSV.backgroundColor = kViewControllerBackgroundColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.title = @"订单详情";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
    
    _goodsListsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_orderListsView.frame)+15, kScreenWidth, 0) style:UITableViewStylePlain];
    
    _goodsListsTableView.scrollEnabled = NO;
    _goodsListsTableView.dataSource = self;
    _goodsListsTableView.delegate = self;
    _goodsListsTableView.showsVerticalScrollIndicator = NO;
    [_goodsListsTableView registerNib:[UINib nibWithNibName:@"WDGoodsListsCell" bundle:nil] forCellReuseIdentifier:lists];
    
    [self _loadOrderDatas];
    
    [self _setHeaderRefresh];
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
    _orderDetailsSV.mj_header = header;
}
- (void)loadNewData{
    
    if (_datasArray.count > 0) {
        
        [_datasArray removeAllObjects];
        [self _loadOrderDatas];
    }
    
//    [_goodsListsTableView reloadData];
    [_orderDetailsSV.mj_header endRefreshing];
}

- (void)viewWillLayoutSubviews{
    
    CGFloat tableViewHeight = _datasArray.count*100 + 40;
    
    _goodsListsTableView.height = tableViewHeight;
    [_orderDetailsSV addSubview:_goodsListsTableView];
}

- (void)_loadOrderDatas{
    
    [WDMineManager requestOrderMsgWithOid:self.orderId completion:^(WDOrderMsgModel *model, NSString *error) {
       
        if (error) {
            
            SHOW_ALERT(error)
            return ;
        }
        
        self.msgModel = model;
        
        self.orderBianhao.text = model.osn;
        self.orderTime.text = model.addtime;
        if ([model.paysate isEqualToString:@"0"]) {
            
            self.yingfuLabel.text = @"应付金额 :";
            [self.payImmediately setTitle:@"立即支付" forState:UIControlStateNormal];
            self.payImmediately.backgroundColor = KSYSTEM_COLOR;
            self.cancelOrderBtn.hidden = NO;
            [self.cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            self.cancelOrderBtn.backgroundColor = KSYSTEM_COLOR;
            self.payImmediately.tag = 231;
            
        }else if ([model.paysate isEqualToString:@"1"]){
            
            self.yingfuLabel.text = @"已付金额 :";
            [self.payImmediately setTitle:@"申请退款" forState:UIControlStateNormal];
            self.payImmediately.backgroundColor = KSYSTEM_COLOR;
            self.payImmediately.tag = 232;
//            if ([model.orderstatusdescription isEqualToString:@"退款申请"]) {
//                
//                self.payImmediately.backgroundColor = [UIColor lightGrayColor];
//                self.payImmediately.enabled = NO;
//            }
        }
        self.zhifuWay.text = model.paysystemtype;
        self.orderStates.text = model.orderstatusdescription;
        self.shouhuoName.text = model.consignee;
        self.shouhuoTel.text = model.mobile;
        self.shouhuoAddress.text = model.address;
        if (model.buyerremark == nil || [model.buyerremark isEqualToString:@"(null)"]) {
            
            self.orderNotes.text = @"";
        }
        else{
            
            self.orderNotes.text = model.buyerremark;
        }
        self.payForMoney.text = [NSString stringWithFormat:@"￥%@",model.surplusmoney];
        self.sendTime.text = model.distributionDesn;
        self.orderCount.text = [NSString stringWithFormat:@"￥%@",model.orderamount];
        self.goodsAllmoney.text = [NSString stringWithFormat:@"￥%@",model.productamount];
        self.peisongMoney.text = [NSString stringWithFormat:@"￥%@",model.shipfee];
        self.couponCount.text = [NSString stringWithFormat:@"￥%@",model.couponmoney];
        
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
    
    btn.frame = CGRectMake(0, 0, 60, 40);
     [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12,45)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//  立即支付
- (IBAction)payFastly:(UIButton *)sender {
    
    if (sender.tag == 231) {
        
        WDPayViewController * accountVC = [[WDPayViewController alloc]init];
        accountVC.orderDic = self.msgModel.osn;
        accountVC.snType = @"1";
        [self.navigationController pushViewController:accountVC animated:YES];
    }
    else if (sender.tag == 232){  //申请退款
        
        WDApplyRefundViewController *applyVC = [[WDApplyRefundViewController alloc] init];
        applyVC.oid = self.orderId;
        [self.navigationController pushViewController:applyVC animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDGoodsListsCell *cell = [tableView dequeueReusableCellWithIdentifier:lists forIndexPath:indexPath];
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

//  取消订单
- (IBAction)cancelOrder:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"取消该订单？" preferredStyle:UIAlertControllerStyleAlert];
    
    //  取消
    UIAlertAction *canceled = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:canceled];
    
    //  确定
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [WDMineManager requestCancelMyOrderwithOid:self.orderId completion:^(NSString *result, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];  //用模态的方法显示对话框

}


/** 申请退款*/
//- (void)applyForMoney:(UIButton *)btn{
//    
//    
//}

@end
