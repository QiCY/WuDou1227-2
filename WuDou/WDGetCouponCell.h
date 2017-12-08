//
//  WDGetCouponCell.h
//  WuDou
//
//  Created by huahua on 16/9/7.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDNearStoreManager.h"

@interface WDGetCouponCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *getCouponBtn;

/** 是否已领取*/
@property(assign,nonatomic) BOOL isGetCoupon;

@property (weak, nonatomic) IBOutlet UILabel *couponCode;

@property (weak, nonatomic) IBOutlet UILabel *couponPrice;

@property (weak, nonatomic) IBOutlet UILabel *couponMaxPrice;

@property (weak, nonatomic) IBOutlet UILabel *couponStartDate;

@property (weak, nonatomic) IBOutlet UILabel *couponEndDate;

/** 优惠券id*/
@property(nonatomic, copy)NSString *couponId;

@end
