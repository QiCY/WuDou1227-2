//
//  WDJifenDetailViewController.h
//  WuDou
//
//  Created by huahua on 17/1/14.
//  Copyright © 2017年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"
#import "WDGoodChoiceModel.h"

@interface WDJifenDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *payWay;
@property (weak, nonatomic) IBOutlet UILabel *receiveName;
@property (weak, nonatomic) IBOutlet UILabel *receivePhone;
@property (weak, nonatomic) IBOutlet UILabel *receiveAddress;
@property (weak, nonatomic) IBOutlet UILabel *jifenCount;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;


/** 订单id*/
@property(nonatomic, copy)NSString *orderId;

@end
