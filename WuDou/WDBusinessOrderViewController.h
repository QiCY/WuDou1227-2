//
//  WDBusinessOrderViewController.h
//  WuDou
//
//  Created by huahua on 16/10/15.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"

@interface WDBusinessOrderViewController : UIViewController

/** navTitle*/
@property(nonatomic, copy)NSString *navTitle;

- (void)_loadDatas;

@end
