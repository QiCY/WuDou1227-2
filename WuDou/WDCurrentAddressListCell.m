//
//  WDCurrentAddressListCell.m
//  WuDou
//
//  Created by huahua on 16/8/26.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDCurrentAddressListCell.h"

@interface WDCurrentAddressListCell ()
{
    UILabel *_currentLabel;
    UILabel *_detailLabel;
    UIImageView *_locationLogo;
}
@end

@implementation WDCurrentAddressListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _locationLogo = [[UIImageView alloc]initWithFrame:CGRectZero];
        _locationLogo.image = [UIImage imageNamed:@"定位0"];
        [self.contentView addSubview:_locationLogo];
        
        _currentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _currentLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_currentLabel];
        
        _recommendLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _recommendLabel.font = [UIFont systemFontOfSize:13.0];
        _recommendLabel.backgroundColor = KSYSTEM_COLOR;
        _recommendLabel.text = @"推荐";
        _recommendLabel.textColor = [UIColor whiteColor];
        _recommendLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_recommendLabel];
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _detailLabel.font = [UIFont systemFontOfSize:15.0];
        _detailLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detailLabel];
    }
    return self;
}

- (void)setCurrentAddress:(NSString *)currentAddress{
    
    _currentAddress = currentAddress;
    
    _currentLabel.text = _currentAddress;
    
}

- (void)setDetailsAddress:(NSString *)detailsAddress{
    
    _detailsAddress = detailsAddress;
    
    _detailLabel.text = _detailsAddress;
}

- (void)layoutSubviews{
    
    //设置label的字体
    UIFont * font = [UIFont systemFontOfSize:16.0];
    //根据字体得到nsstring的尺寸
    CGSize size = [_currentAddress sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    _locationLogo.frame = CGRectMake(10, 13, 13, 15);
    _currentLabel.frame = CGRectMake(33, 10, size.width, 20);
    _recommendLabel.frame = CGRectMake(CGRectGetMaxX(_currentLabel.frame)+10, 13, 40, 17);
    _detailLabel.frame = CGRectMake(33, 40, self.width - 50, 20);
}

@end
