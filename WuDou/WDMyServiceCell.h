//
//  WDMyServiceCell.h
//  WuDou
//
//  Created by huahua on 16/10/20.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDMyServiceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;

@property (weak, nonatomic) IBOutlet UILabel *serviceTitle;

@property (weak, nonatomic) IBOutlet UILabel *serviceRegine;

@property (weak, nonatomic) IBOutlet UILabel *serviceTime;

@property (weak, nonatomic) IBOutlet UILabel *serviceChecked;

/** 是否审核*/
@property(nonatomic, copy)NSString *isCheak;

@end
