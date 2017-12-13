//
//  WDStoreInfoView.h
//  WuDou
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDStoreInfosModel.h"
@protocol StoreInfoViewDelegate
@optional
- (void)didClickedDiscountBtn;
@end


@interface WDStoreInfoView : UIView
@property(nonatomic,strong)UIImageView *storeImgView;
@property(nonatomic,strong)UILabel *storeName;
@property(nonatomic,strong)UILabel *allCount;
@property(nonatomic,strong)UILabel *transPrice;
@property(nonatomic,strong)UIButton *discountBtn;
@property(nonatomic,assign)id<StoreInfoViewDelegate>delegate;
- (void)setStoreInfo:(WDStoreInfosModel *)store;
@end
