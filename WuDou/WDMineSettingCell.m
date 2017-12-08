//
//  WDMineSettingCell.m
//  WuDou
//
//  Created by huahua on 16/8/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMineSettingCell.h"

@implementation WDMineSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _btnImageView.hidden = !_showBtnImageViewEnabled;
}

- (void)setShowBtnImageViewEnabled:(BOOL)showBtnImageViewEnabled{
    
    _showBtnImageViewEnabled = showBtnImageViewEnabled;
    
    _btnImageView.hidden = !_showBtnImageViewEnabled;
}

@end
