//
//  WDCommenBtn.m
//  WuDou
//
//  Created by huahua on 16/7/27.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDCommenBtn.h"

@interface WDCommenBtn ()
{
    UIImageView *_bgImageV;  //显示图片
    UILabel *_titleLab;  //显示文字
}

@end

@implementation WDCommenBtn

// 覆写UIButton初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];

        CALayer *layer = [_bgImageV layer];
        [layer setCornerRadius:_bgImageV.bounds.size.width * 0.5];  //设置图片的圆角，r = 图片宽度*0.5
        [layer setMasksToBounds:YES];  //设置超出部分不显示
        _bgImageV.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_bgImageV];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgImageV.frame), self.bounds.size.width, self.bounds.size.height - self.bounds.size.width)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_titleLab];
        
    }
    return self;
}

- (void)setImageName:(NSString *)imageName{
    
    if (_imageName != imageName) {
        _imageName = imageName;
        
        _bgImageV.image = [UIImage imageNamed:_imageName];
    }
}

- (void)setBtnTitle:(NSString *)btnTitle{
    
    if (_btnTitle != btnTitle) {
        _btnTitle = btnTitle;
        
        _titleLab.text = _btnTitle;
        
    }
}

// 重新布局子控件的frame
//- (void)layoutSubviews{
//    
//    _bgImageV.frame = CGRectMake(0, 5, self.bounds.size.width, self.bounds.size.height-20);
//    
//    _titleLab.frame = CGRectMake(0, CGRectGetMaxY(_bgImageV.frame), self.bounds.size.width, 16);
//}

@end
