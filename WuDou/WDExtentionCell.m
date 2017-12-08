//
//  WDExtentionCell.m
//  WuDou
//
//  Created by huahua on 16/8/4.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDExtentionCell.h"

@implementation WDExtentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(UIImageView *)extentionImageView{
    
    if (!_extentionImageView) {
        
        _extentionImageView.contentMode = UIViewContentModeScaleAspectFit;
        _extentionImageView.layer.cornerRadius = _extentionImageView.bounds.size.width * 0.5;
        _extentionImageView.layer.masksToBounds = YES;
    }
    
    return _extentionImageView;
}

@end
