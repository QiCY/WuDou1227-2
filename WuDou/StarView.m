//
//  StarView.m
//  WuDou
//
//  Created by huahua on 16/8/9.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "StarView.h"

@interface StarView (){
    
    UIView *_view1;
    UIView *_view2;
}

@end

@implementation StarView

//  使用xib文件的初始化方法
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        float width = self.bounds.size.width/5;
        _view1 = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:_view1];
        for (int index = 0; index < 5; index ++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index * width, 0, width, self.bounds.size.height)];
            imageView.image = [UIImage imageNamed:@"pingjiahui.png"];
            [_view1 addSubview:imageView];
            
        }
        
        _view2 = [[UIView alloc]initWithFrame:self.bounds];
        _view2.clipsToBounds = YES;
        [self addSubview:_view2];
        for (int index = 0; index < 5; index ++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index * width, 0, width, self.bounds.size.height)];
            imageView.image = [UIImage imageNamed:@"pingjia.png"];
            [_view2 addSubview:imageView];
            
        }
    }
    return self;
}

//  使用代码创建的初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        float width = self.bounds.size.width/5;
        
        _view1 = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:_view1];
        
        for (int index = 0; index < 5; index ++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index * width, 0, width, self.bounds.size.height)];
            imageView.image = [UIImage imageNamed:@"pingjiahui.png"];
            [_view1 addSubview:imageView];
            
        }
        
        _view2 = [[UIView alloc]initWithFrame:self.bounds];
        _view2.clipsToBounds = YES;  //超出部分不显示
        [self addSubview:_view2];
        
        for (int index = 0; index < 5; index ++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index * width, 0, width, self.bounds.size.height)];
            imageView.image = [UIImage imageNamed:@"pingjia.png"];
            [_view2 addSubview:imageView];
            
        }
    }
    
    return self;
}

-(void)setSocre:(float)socre{
    
    _socre = socre;
    
    float width = _socre/10 * self.bounds.size.width;
    
    CGRect frame = _view2.frame;
    frame.size.width = width;
    _view2.frame = frame;
    
    
}

- (void)setStarCount:(NSInteger)starCount{
    
    _starCount = starCount;
    
    float itemW = self.bounds.size.width / 5;
    
    CGRect frame = _view2.frame;
    frame.size.width = itemW * _starCount;
    _view2.frame = frame;
    
    
}

@end
