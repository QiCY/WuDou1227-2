//
//  WDMyOrderCell.h
//  WuDou
//
//  Created by huahua on 16/8/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDAppInitManeger.h"

@interface WDMyOrderCell : UITableViewCell

/* 店铺名称 **/
@property (weak, nonatomic) IBOutlet UILabel *storeName;
/* 支付状态 **/
@property (weak, nonatomic) IBOutlet UILabel *zhifuState;
/* 是否已支付 **/
@property (assign, nonatomic) BOOL isZhiFuEnabled;
/** 兑换积分huo应付金额*/
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
/* 应付金额**/
@property (weak, nonatomic) IBOutlet UILabel *shouldPay;
/* 下单时间 **/
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
/* 订单图片 **/
@property (weak, nonatomic) IBOutlet UIScrollView *orderPics;
/* 订单图片名称数组 **/
@property (strong, nonatomic) NSMutableArray *orderPicImages;
/* 根据支付状态显示按钮 **/
@property (weak, nonatomic) IBOutlet UIView *showZhifuStateView;

/** 订单号*/
@property(nonatomic, copy)NSString *orderStr;

@property (nonatomic,strong)UIViewController *myOrderVC;
/** storeId*/
@property(nonatomic, copy)NSString *storeid;
/** 再次购买跳转积分页面*/
//@property(nonatomic, assign)BOOL isJifenPid;
/** 积分pid*/
@property(nonatomic, copy)NSString *pid;
/** oid*/
@property(nonatomic, copy)NSString *oid;
/** isreviews是否已评论*/
@property(nonatomic, copy)NSString *isReview;
/** 评论按钮显示的文字*/
@property(nonatomic, copy)NSString *judgeText;

@end
