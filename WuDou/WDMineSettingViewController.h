//
//  WDMineSettingViewController.h
//  WuDou
//
//  Created by huahua on 16/8/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"

@interface WDMineSettingViewController : UIViewController

/* 设置 **/ 
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@end
