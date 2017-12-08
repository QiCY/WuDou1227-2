//
//  WDShoppingCarViewController.h
//  WuDou
//
//  Created by huahua on 16/7/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDCarShop.h"
#import "WDMainRequestManager.h"
#import "WDMineManager.h"

@interface WDShoppingCarViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *allSelectImage;
- (IBAction)allSelectClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *commitClick;
- (IBAction)commitClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *zonPrice;

@property (weak, nonatomic) IBOutlet UILabel *noYunFeiLabel;

@end
