//
//  WDGoodChoiceCell.h
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDGoodChoiceCell : UICollectionViewCell

/* 商品图片 **/
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
/* 商品信息 **/
@property (weak, nonatomic) IBOutlet UILabel *shopInfo;
/* 商品价格 **/
@property (weak, nonatomic) IBOutlet UILabel *shopPrice;

@end
