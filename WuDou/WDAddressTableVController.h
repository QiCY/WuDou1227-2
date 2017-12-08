//
//  WDAddressTableVController.h
//  WuDou
//
//  Created by huahua on 16/8/24.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"

@interface WDAddressTableVController : UITableViewController

/** 用于区分选择还是编辑地址*/
@property(nonatomic,copy)NSString *sourceType;

@end
