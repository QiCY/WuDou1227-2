//
//  WDCurrentAddressListCell.h
//  WuDou
//
//  Created by huahua on 16/8/26.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDCurrentAddressListCell : UITableViewCell

/** 当前地址*/
@property (copy, nonatomic)NSString *currentAddress;
/** 详细地址*/
@property (copy, nonatomic)NSString *detailsAddress;
/** 推荐*/
@property (strong, nonatomic)UILabel *recommendLabel;


@end
