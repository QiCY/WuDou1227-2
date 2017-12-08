//
//  WDGoodsListsCell.h
//  WuDou
//
//  Created by huahua on 16/8/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDGoodsListsCell : UITableViewCell

/* 商品图片 **/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/* 商品详情 **/
@property (weak, nonatomic) IBOutlet UILabel *goodsDetails;
/* 商品单价 **/
@property (weak, nonatomic) IBOutlet UILabel *singlePrice;
/* 商品个数 **/
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;

@end
