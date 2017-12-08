//
//  WDMineSettingCell.h
//  WuDou
//
//  Created by huahua on 16/8/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDMineSettingCell : UITableViewCell

/* 左侧label **/
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
/* 右侧label **/
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
/* 按钮图标 **/
@property (weak, nonatomic) IBOutlet UIImageView *btnImageView;
/* 是否显示按钮图标 **/
@property (assign ,nonatomic) BOOL showBtnImageViewEnabled;

@end
