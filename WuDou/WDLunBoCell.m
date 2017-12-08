//
//  WDLunBoCell.m
//  WuDou
//
//  Created by huahua on 16/8/4.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDLunBoCell.h"

@implementation WDLunBoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self setupImageView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupImageView];
    }
    
    return self;
}
- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageV = imageView;
    [self.contentView addSubview:imageView];
}

-(void)layoutSubviews{
    
    _imageV.frame = self.bounds;
}

@end
