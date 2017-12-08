//
//  WDBusinessMsgViewController.h
//  WuDou
//
//  Created by huahua on 16/10/15.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"
#import "WDGoodChoiceModel.h"

@interface WDBusinessMsgViewController : UIViewController

/** 订单号*/
@property (weak, nonatomic) IBOutlet UILabel *orderBianhao;
/** 订单时间*/
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
/** 支付方式*/
@property (weak, nonatomic) IBOutlet UILabel *orderZhifuState;
/** 订单用户名*/
@property (weak, nonatomic) IBOutlet UILabel *orderUserName;
/** 订单收货电话*/
@property (weak, nonatomic) IBOutlet UILabel *orderAddressNumber;
/** 订单地址*/
@property (weak, nonatomic) IBOutlet UILabel *orderAddress;
/** 订单备注*/
@property (weak, nonatomic) IBOutlet UILabel *orderMark;
/** 配送时间*/
@property (weak, nonatomic) IBOutlet UILabel *sendTime;
/* 订单合计 **/
@property (weak, nonatomic) IBOutlet UILabel *orderCount;
/* 商品金额 **/
@property (weak, nonatomic) IBOutlet UILabel *goodsAllmoney;
/* 配送费 **/
@property (weak, nonatomic) IBOutlet UILabel *peisongMoney;
/** 优惠券金额*/
@property (weak, nonatomic) IBOutlet UILabel *couponCount;
/** 应付金额*/
@property (weak, nonatomic) IBOutlet UILabel *orderPay;
/** 订单状态*/
@property (weak, nonatomic) IBOutlet UILabel *orderState;
/** 订单详情视图*/
@property (weak, nonatomic) IBOutlet UIView *orderMsgView;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

/** 订单id*/
@property(nonatomic, copy)NSString *orderId;


@end
