//
//  WDShopCell.h
//  WuDou
//
//  Created by admin on 2017/12/8.
//  Copyright © 2017年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDCarShop.h"
#import "WDChooseGood.h"
@protocol WDShopCellDelegate
@optional
- (void)didClickedGoodBtn:(WDChooseGood *)good;
-(void)didClickedDeleteBtn:(WDCarShop *)shop;
-(void)didClickedPayBtn:(WDCarShop *)shop;
@end


@interface WDShopCell : UITableViewCell
@property(nonatomic,strong)WDCarShop *shop;
@property(nonatomic,strong)UILabel *shopName;
@property(nonatomic,strong)UIScrollView *goodsScroll;
@property(nonatomic,strong)UILabel *allCountLab;
@property(nonatomic,strong)UILabel *allWeightLab;
@property(nonatomic,strong)UILabel *allGoodsPrice;
@property(nonatomic,strong)UILabel *transPrice;
@property(nonatomic,strong)UILabel *totalPrice;
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)UIButton *payBtn;
@property(nonatomic,strong)UIView *footer;
@property(nonatomic,assign)id<WDShopCellDelegate>delegate;
- (void)setShop:(WDCarShop *)shop target:(id)target ;
@end
