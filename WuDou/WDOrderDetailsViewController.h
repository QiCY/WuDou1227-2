//
//  WDOrderDetailsViewController.h
//  WuDou
//
//  Created by huahua on 16/8/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"
#import "WDGoodChoiceModel.h"

@interface WDOrderDetailsViewController : UIViewController

/* 订单编号 **/
@property (weak, nonatomic) IBOutlet UILabel *orderBianhao;
/* 订单时间 **/
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
/* 支付方式 **/
@property (weak, nonatomic) IBOutlet UILabel *zhifuWay;
/* 收货姓名 **/
@property (weak, nonatomic) IBOutlet UILabel *shouhuoName;
/* 收货电话 **/
@property (weak, nonatomic) IBOutlet UILabel *shouhuoTel;
/* 收货地址 **/
@property (weak, nonatomic) IBOutlet UILabel *shouhuoAddress;
/** 显示应付还是已付*/
@property (weak, nonatomic) IBOutlet UILabel *yingfuLabel;
/* 订单备注 **/
@property (weak, nonatomic) IBOutlet UILabel *orderNotes;
/* 配送时间 **/
@property (weak, nonatomic) IBOutlet UILabel *sendTime;
/* 订单合计 **/
@property (weak, nonatomic) IBOutlet UILabel *orderCount;
/* 商品金额 **/
@property (weak, nonatomic) IBOutlet UILabel *goodsAllmoney;
/* 配送费 **/
@property (weak, nonatomic) IBOutlet UILabel *peisongMoney;
/* 优惠券金额 **/
@property (weak, nonatomic) IBOutlet UILabel *couponCount;
/* 应付金额 **/
@property (weak, nonatomic) IBOutlet UILabel *payForMoney;
/* 订单状态 **/
@property (weak, nonatomic) IBOutlet UILabel *orderStates;
/* 立即支付按钮 **/
@property (weak, nonatomic) IBOutlet UIButton *payImmediately;
/* 取消订单按钮 **/
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;

@property (weak, nonatomic) IBOutlet UIView *orderListsView;

/** 订单id*/
@property(nonatomic, copy)NSString *orderId;

@property (weak, nonatomic) IBOutlet UIScrollView *orderDetailsSV;



@end
