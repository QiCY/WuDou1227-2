//
//  WDSecondGoodsCell.h
//  WuDou
//
//  Created by huahua on 16/8/24.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDSecondGoodsCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *secondGoodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;

@property (weak, nonatomic) IBOutlet UILabel *goodsLocation;

@property (weak, nonatomic) IBOutlet UILabel *publishTime;

@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
/** 是否审核*/
@property (weak, nonatomic) IBOutlet UILabel *isChecked;

/** 是否审核*/
@property(nonatomic, copy)NSString *isCheck;

@end
