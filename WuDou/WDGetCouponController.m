//
//  WDGetCouponController.m
//  WuDou
//
//  Created by huahua on 16/9/7.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDGetCouponController.h"
#import "WDGetCouponCell.h"

@interface WDGetCouponController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
}
// 是否已领取
@property(assign,nonatomic)BOOL isGetEnabled;

@end

static NSString *const getCouponId = @"getCoupon";
@implementation WDGetCouponController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self _loadDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"店铺优惠券";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setupNavigation];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WDGetCouponCell" bundle:nil] forCellReuseIdentifier:getCouponId];
}

- (void)_loadDatas{
    
    [WDNearStoreManager requestStoreInfoCouponsWithStoreId:self.storeId completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            
            SHOW_ALERT(error)
            return ;
        }
        
        _dataArray = array;
        [self.tableView reloadData];
        
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


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDGetCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:getCouponId forIndexPath:indexPath];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WDMyCouponModel *model = _dataArray[indexPath.row];
    
    cell.couponCode.text = [NSString stringWithFormat:@"兑换码：%@",model.couponsn];
    cell.couponPrice.text = model.money;
    cell.couponMaxPrice.text = [NSString stringWithFormat:@"满%@元可使用",model.orderamountlower];
    cell.couponStartDate.text = model.usestarttime;
    cell.couponEndDate.text = model.useendtime;
    cell.isGetCoupon = [model.sate boolValue];
    cell.couponId = model.couponid;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

@end
