//
//  WDSearchViewController.h
//  WuDou
//
//  Created by huahua on 16/8/8.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMainRequestManager.h"

@interface WDSearchViewController : UIViewController

/* 搜索框 **/
@property (weak, nonatomic) IBOutlet UITextField *searchShops;
/* 取消按钮 **/
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/* 搜索历史 **/
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@end
