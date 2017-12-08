//
//  WDNearStoreCell.m
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDNearStoreCell.h"

@implementation WDNearStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _pingtaiImageView.hidden = !_showPingtaieEnabled;
}

-(void)setShowPingtaieEnabled:(BOOL)showPingtaieEnabled{
    
    
    _showPingtaieEnabled = showPingtaieEnabled;
    
    _pingtaiImageView.hidden = !_showPingtaieEnabled;
    
}


@end
