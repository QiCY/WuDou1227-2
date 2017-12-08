//
//  WDCollctTableViewCell.h
//  WuDou
//
//  Created by huahua on 16/8/24.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDCollctTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *exchangeCode;

@property (weak, nonatomic) IBOutlet UILabel *couponPrice;

@property (weak, nonatomic) IBOutlet UILabel *couponMaxMoney;

@property (weak, nonatomic) IBOutlet UILabel *couponStartDate;

@property (weak, nonatomic) IBOutlet UILabel *couponEndDate;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
