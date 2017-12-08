//
//  WDMineViewController.h
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDLoginViewController.h"
#import "WDMainRequestManager.h"

#import "WDAppInitManeger.h"

@interface WDMineViewController : UIViewController

@property(nonatomic, strong)WDLoginViewController *loginVC;

/** 显示商户、配送员、普通用户订单的状态*/
@property(nonatomic,copy)NSString *showOrderState;

@end
