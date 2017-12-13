//
//  WDStoreDetailViewController.h
//  WuDou
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDStoreDetailViewController : UIViewController
@property(nonatomic, copy)NSString *storeId;
@property(nonatomic,assign)NSInteger type;//0是店铺详情，1是附近店铺
@end
