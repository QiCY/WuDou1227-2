//
//  WDOrderListView.m
//  WuDou
//
//  Created by huahua on 16/8/17.
//  Copyright © 2016年 os1. All rights reserved.
//  下拉列表

#import "WDOrderListView.h"

@interface WDOrderListView ()
{
    UILabel *_listLabel;
    UIImageView *_listImageView;
}
@end

@implementation WDOrderListView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _listLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self addSubview:_listLabel];
        
        _listImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_listImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _listLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self addSubview:_listLabel];
        
        _listImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_listImageView];
    }
    return self;
}

- (void)setOrderListTitle:(NSString *)orderListTitle{
    
    _orderListTitle = orderListTitle;
    
    _listLabel.text = _orderListTitle;
    _listLabel.textAlignment = NSTextAlignmentCenter;
    _listLabel.font = [UIFont systemFontOfSize:15.0];
}

- (void)setOrderListImageName:(NSString *)orderListImageName{
    
    _orderListImageName = orderListImageName;
    _listImageView.image = [UIImage imageNamed:_orderListImageName];
    
}

- (void)layoutSubviews{
    
    //设置label的字体  HelveticaNeue  Courier
    UIFont * font = [UIFont systemFontOfSize:16.0];
    //根据字体得到nsstring的尺寸
    CGSize size = [_orderListTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    //名字的宽
    CGFloat nameW = size.width;
    CGFloat imageW = 10;
    _listLabel.frame = CGRectMake((self.width - (nameW+10+imageW))*0.5, (self.height-20)*0.5, nameW, 20);
    
    _listImageView.frame = CGRectMake(CGRectGetMaxX(_listLabel.frame)+10, (self.height-8)*0.5, 10, 6);
    
}

@end
