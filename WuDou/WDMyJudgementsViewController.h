//
//  WDMyJudgementsViewController.h
//  WuDou
//
//  Created by huahua on 16/12/2.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"

@interface WDMyJudgementsViewController : UIViewController

/** 标题*/
@property(nonatomic, copy)NSString *navTitle;

/** 区分我的评价还是商品详情评价*/
@property(nonatomic, copy)NSString *judgeState;

/** 区分我的评价Cell还是商品详情评价Cell*/
@property(nonatomic, assign)BOOL cellState;

/** pid*/
@property(nonatomic, copy)NSString *pid;

/** 返回时跳转的页面*/
@property(nonatomic, copy)NSString *jumpState;

@end
