//
//  WDMainCell.m
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMainCell.h"

@implementation WDMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _gotoBtn.hidden = !_showGotoBtnEnabled;
    
}

- (void)setShowGotoBtnEnabled:(BOOL)showGotoBtnEnabled{
    
    _showGotoBtnEnabled = showGotoBtnEnabled;
    
    _gotoBtn.hidden = !_showGotoBtnEnabled;
}

@end
