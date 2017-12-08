//
//  WDNearStoreCell.h
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDNearStoreCell : UITableViewCell

/* 店铺图片 **/
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
/* 店铺名称 **/
@property (weak, nonatomic) IBOutlet UILabel *storeName;
/* 平台专送 **/
@property (weak, nonatomic) IBOutlet UIImageView *pingtaiImageView;
/* 是否显示平台专送 **/
@property (assign, nonatomic) BOOL showPingtaieEnabled;
/* 距店铺的距离 **/
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
/* 月售份额 **/
@property (weak, nonatomic) IBOutlet UILabel *sellCount;
/* 起送价 **/
@property (weak, nonatomic) IBOutlet UILabel *qisongPrice;
/* 配送价 **/
@property (weak, nonatomic) IBOutlet UILabel *peisongPrice;


@end
