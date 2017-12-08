//
//  WDMySecondMagViewController.h
//  WuDou
//
//  Created by huahua on 16/10/17.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"

@interface WDMySecondMagViewController : UIViewController
{
    BOOL _isShowPrice;
}

@property (nonatomic ,copy)NSString *navTitle;

- (instancetype)initWithTitle:(NSString *)myTitle showPriceLabelEnabled:(BOOL)isShow;

/** 显示价格label*/
@property(nonatomic, strong)UILabel *priceLabel;
/** 二手商品pid*/
@property(nonatomic, copy)NSString *pid;
/** 便民服务商品pid*/
@property(nonatomic, copy)NSString *newsid;

@end
