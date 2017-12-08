//
//  WDJifenMsgViewController.h
//  WuDou
//
//  Created by huahua on 16/10/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMainRequestManager.h"
#import "WDLoadAddressModel.h"

@interface WDJifenMsgViewController : UIViewController

/** 积分商品id*/
@property(nonatomic, copy)NSString *pid;
/** 地址id*/
@property(nonatomic, copy)NSString *addressId;

@property(nonatomic,strong)WDLoadAddressModel *model;

@end
