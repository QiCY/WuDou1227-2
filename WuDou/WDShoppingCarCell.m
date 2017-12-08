//
//  WDShoppingCarCell.m
//  WuDou
//
//  Created by huahua on 16/8/9.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDShoppingCarCell.h"

@interface WDShoppingCarCell ()
{
    UIView *_goodPicsView;
}
@end

@implementation WDShoppingCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _goodPicsView = [[UIView alloc]initWithFrame:CGRectZero];
        _goodPicsView.backgroundColor = [UIColor clearColor];
        
        
        [_goodsPicScrollView addSubview:_goodPicsView];
    }
    return self;
}

- (void)setGoodsImageName:(NSString *)goodsImageName{
    
    _goodsImageName = goodsImageName;
    
    UIImageView *goodsPic = [[UIImageView alloc]initWithFrame:CGRectZero];
    goodsPic.layer.cornerRadius = 5;
    goodsPic.layer.borderWidth = 1;
    goodsPic.layer.borderColor = kViewControllerBackgroundColor.CGColor;
    goodsPic.image = [UIImage imageNamed:_goodsImageName];
    [_goodPicsView addSubview:goodsPic];
    
}

- (void)setGoodsPrice:(NSString *)goodsPrice{
    
    _goodsPrice = goodsPrice;
    
    UILabel *goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    goodsPriceLabel.font = [UIFont systemFontOfSize:14];
    goodsPriceLabel.textAlignment = NSTextAlignmentCenter;
    goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@",_goodsPrice];
    [_goodPicsView addSubview:goodsPriceLabel];
}

- (void)layoutSubviews{
    
    
}


@end
