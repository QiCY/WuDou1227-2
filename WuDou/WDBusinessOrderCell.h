//
//  WDBusinessOrderCell.h
//  WuDou
//
//  Created by huahua on 16/10/15.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDBusinessOrderCell : UITableViewCell

/** 店铺名称*/
@property (weak, nonatomic) IBOutlet UILabel *orderStoreName;
/** 支付状态*/
@property (weak, nonatomic) IBOutlet UILabel *orderZhifuState;
/** 兑换积分huo应付金额*/
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
/** 应付金额*/
@property (weak, nonatomic) IBOutlet UILabel *shouldPay;
/** 订单时间*/
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
/** 商品图片*/
@property (weak, nonatomic) IBOutlet UIScrollView *orderGoodsImages;
/** 订单状态按钮*/
@property (weak, nonatomic) IBOutlet UIButton *orderStateBtn;

/* 订单图片名称数组 **/
@property (strong, nonatomic) NSMutableArray *orderPicImages;

@end
