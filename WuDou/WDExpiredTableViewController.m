//
//  WDExpiredTableViewController.m
//  WuDou
//
//  Created by huahua on 16/9/23.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDExpiredTableViewController.h"
#import "WDCollctTableViewCell.h"
#import "WDMineManager.h"

@interface WDExpiredTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_datasArray;
}

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation WDExpiredTableViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self _requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 104)];
    [self.tableView registerNib:[UINib nibWithNibName:@"WDCollctTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    // 加入长按手势
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGR.minimumPressDuration = 0.2;
    [self.tableView addGestureRecognizer:longPressGR];
    
}

/** 请求数据*/
- (void)_requestData{
    
    [WDMineManager requestMyCouponWithSate:@"2" completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            
            [self _createNodatasIcon];
            return ;
        }
        
        _datasArray = array;
        [self.tableView reloadData];
    }];
}

/** 提示暂时数据*/
- (void)_createNodatasIcon{
    
    [self.tableView removeFromSuperview];
    
    UIView *noticeView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 0, 70, 60)];
    noticeView.centerX = kScreenWidth * 0.5;
    noticeView.centerY = self.view.center.y-30;
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _datasArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WDCollctTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WDMyCouponModel *model = _datasArray[indexPath.row];
    cell.exchangeCode.text = [NSString stringWithFormat:@"兑换码：%@",model.couponsn];
    cell.couponPrice.text = model.money;
    cell.couponMaxMoney.text = [NSString stringWithFormat:@"满%@元可以使用",model.orderamountlower];
    cell.couponStartDate.text = model.usestarttime;
    cell.couponEndDate.text = model.useendtime;
    cell.typeLabel.text = @"已过期";
    
    return cell;
}

// 长按删除的方法
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer

{
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        
    {
        //  弹窗
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"删除该优惠券？" preferredStyle:UIAlertControllerStyleAlert];
        
        //  取消
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        
        //  确认
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
            
            WDMyCouponModel *model = _datasArray[indexPath.row];
            [WDMineManager requestDeletCouponWithCouponId:model.couponid completion:^(NSString *result, NSString *error) {
                
                if (error) {
                    
                    SHOW_ALERT(error)
                    return ;
                }
                
                [self _requestData];
            }];
            
        }];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];  //用模态的方法显示对话框
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

@end
