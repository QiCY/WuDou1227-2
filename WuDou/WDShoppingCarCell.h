//
//  WDShoppingCarCell.h
//  WuDou
//
//  Created by huahua on 16/8/9.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDShoppingCarCell : UITableViewCell


/* 店铺Logo **/
@property (weak, nonatomic) IBOutlet UIImageView *storeimageName;
/* 店铺名称 **/
@property (weak, nonatomic) IBOutlet UILabel *storeName;
/* 商品个数 **/
@property (weak, nonatomic) IBOutlet UILabel *counts;
/* 商品价格 **/
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
/* 所有商品图片 **/
@property (weak, nonatomic) IBOutlet UIScrollView *goodsPicScrollView;
/* 单个商品图片 **/
@property (copy, nonatomic) NSString *goodsImageName;
/* 商品单价 **/
@property (copy, nonatomic) NSString *goodsPrice;


@end
