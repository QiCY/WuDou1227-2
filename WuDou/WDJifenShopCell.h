//
//  WDJifenShopCell.h
//  WuDou
//
//  Created by huahua on 16/8/22.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDJifenShopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopInfos;

@property (weak, nonatomic) IBOutlet UILabel *totalCount;

@property (weak, nonatomic) IBOutlet UILabel *lastCount;

@property (weak, nonatomic) IBOutlet UILabel *shopCoins;


@end
