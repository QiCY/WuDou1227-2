//
//  WDTejiaCell.h
//  WuDou
//
//  Created by huahua on 16/8/9.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSpecialPriceModel.h"

@interface WDTejiaCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property(weak,nonatomic) IBOutlet UIImageView *shopHotImgView;
@property (weak, nonatomic) IBOutlet UILabel *shopsName;
@property (weak,nonatomic)IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *shopsPrice;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;


@end
