//
//  WDPayViewController.h
//  WuDou
//
//  Created by huahua on 16/8/11.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "WDNearStoreManager.h"

@interface WDPayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)Product *product;

/** 生成的订单号*/
@property(nonatomic, copy)NSString *orderDic;
/** 总价*/
@property(nonatomic, copy)NSString *price;
/** snType*/
@property(nonatomic, copy)NSString *snType;

@end
