//
//  WDBusinessOrderCell.m
//  WuDou
//
//  Created by huahua on 16/10/15.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDBusinessOrderCell.h"

@implementation WDBusinessOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrderPicImages:(NSMutableArray *)orderPicImages{
    
    _orderPicImages = orderPicImages;
    
    CGFloat picWidth = 60;
    _orderGoodsImages.contentSize = CGSizeMake((picWidth+10) * _orderPicImages.count,_orderGoodsImages.bounds.size.height);
    
    for (UIView *subV in _orderGoodsImages.subviews) {
        
        [subV removeFromSuperview];
    }
    
    for (int i = 0; i < _orderPicImages.count; i ++) {
        
        UIImageView *goodsPic = [[UIImageView alloc] initWithFrame:CGRectMake((10+picWidth)*i, 0, picWidth, _orderGoodsImages.bounds.size.height)];
        [goodsPic sd_setImageWithURL:[NSURL URLWithString:_orderPicImages[i]]];
        [_orderGoodsImages addSubview:goodsPic];
    }
}

@end
