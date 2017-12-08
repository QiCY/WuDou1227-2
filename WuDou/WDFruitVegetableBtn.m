//
//  WDFruitVegetableBtn.m
//  WuDou
//
//  Created by DuYang on 2017/7/9.
//  Copyright © 2017年 os1. All rights reserved.
//

#import "WDFruitVegetableBtn.h"

@interface WDFruitVegetableBtn ()
{
    UIImageView *_imagesView;
    UILabel *_textsLabel;
}

@end

@implementation WDFruitVegetableBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imagesView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-80)*0.5, 0, 30, 30)];
        _imagesView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imagesView];
        
        _textsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imagesView.frame)+5, 5, 55, 20)];
        _textsLabel.textColor = [UIColor blackColor];
        _textsLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_textsLabel];
        
    }
    return self;
}

- (void)setImageName:(NSString *)imageName{
    
    _imageName = imageName;
    _imagesView.image = [UIImage imageNamed:_imageName];
}

- (void)setText:(NSString *)text{
    
    _text = text;
    _textsLabel.text = _text;
}


@end
