//
//  WDGoodsInfoViewController.h
//  WuDou
//
//  Created by huahua on 16/8/8.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMainRequestManager.h"
#import "WDMineManager.h"

@interface WDGoodsInfoViewController : UIViewController

/** 商品ID*/
@property(nonatomic, strong)NSString * goodsID;

/** 商品图标*/
@property(nonatomic, copy)NSString *goodsImage;

/** 商品详情模型*/
@property(nonatomic, strong)WDGoodsMsgModel *goodsInfosModel;

/** 店铺信息模型*/
@property(nonatomic, strong)WDStoreMsgModel *storeInfosModel;
@end
