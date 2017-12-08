//
//  WDAccountViewController.h
//  WuDou
//
//  Created by huahua on 16/8/11.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDLoadAddressModel.h"
#import "WDGoodList.h"
#import "WDNearStoreManager.h"

@interface WDAccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)commitClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *allcount;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property(weak,nonatomic)IBOutlet UIButton *payButton;

@property(nonatomic,strong)WDLoadAddressModel *model;

@property(nonatomic,copy)NSString *youhuiPrice;

@property(nonatomic,strong)NSMutableArray * dataArray;

/** 订单号*/
@property(nonatomic, copy)NSString *orderCount;

/** order_info*/
@property(nonatomic, copy)NSString *orderinfo;

/** 地址id*/
@property(nonatomic, copy)NSString *addressId;


@end
