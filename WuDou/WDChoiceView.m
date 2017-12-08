//
//  WDChoiceView.m
//  WuDou
//
//  Created by huahua on 16/9/7.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDChoiceView.h"

@interface WDChoiceView ()
{
    UIImageView *_choiceImageView1;
    UIImageView *_choiceImageView2;
}

@end

@implementation WDChoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self _createPopView];
    }
    return self;
}

- (void)setIsChoice:(BOOL)isChoice{
    
    _isChoice = isChoice;
    if (_isChoice)
    {
        _choiceImageView1.backgroundColor = KSYSTEM_COLOR;
        _choiceImageView2.backgroundColor = [UIColor clearColor];
    }
    else
    {
        _choiceImageView2.backgroundColor = KSYSTEM_COLOR;
        _choiceImageView1.backgroundColor = [UIColor clearColor];
    }
    _isChoice = !_isChoice;
}

/** 创建弹窗视图*/
- (void)_createPopView{
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.width-10, 20)];
    titleLabel.text = @"修改性别";
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self addSubview:titleLabel];
    
    // 男
    UILabel *man = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+20, self.width-20-50, 20)];
    man.text = @"男";
    [self addSubview:man];
    
    _choiceImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(man.frame)+15, man.y, 20, 20)];
    _choiceImageView1.layer.cornerRadius = 10;
    _choiceImageView1.image = [UIImage imageNamed:@"不打勾"];
//    _choiceImageView1.backgroundColor = ;
    [self addSubview:_choiceImageView1];
    
    UIButton *manBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(man.frame), man.y, 50, 20)];
    manBtn.backgroundColor = [UIColor clearColor];
    [manBtn addTarget:self action:@selector(choiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:manBtn];
    
    // 女
    UILabel *woman = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(man.frame)+20, self.width-20-50, 20)];
    woman.text = @"女";
    [self addSubview:woman];
    
    _choiceImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(woman.frame)+15, woman.y, 20, 20)];
    _choiceImageView2.layer.cornerRadius = 10;
    _choiceImageView2.image = [UIImage imageNamed:@"不打勾"];
    [self addSubview:_choiceImageView2];
    
    UIButton *womanBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(woman.frame), woman.y, 50, 20)];
    womanBtn.backgroundColor = [UIColor clearColor];
    [womanBtn addTarget:self action:@selector(choiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:womanBtn];
    
    // 确定
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(woman.frame)+20, (self.width-30)*0.5, 30)];
    sureBtn.backgroundColor = KSYSTEM_COLOR;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    // 取消
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame)+10, sureBtn.y, sureBtn.width, 30)];
    cancelBtn.backgroundColor = KSYSTEM_COLOR;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
}

//  选择
- (void)choiceBtn:(UIButton *)btn{
   
    if (_isChoice)
    {
        _choiceImageView1.backgroundColor = KSYSTEM_COLOR;
        _choiceImageView2.backgroundColor = [UIColor clearColor];
    }
    else
    {
        _choiceImageView2.backgroundColor = KSYSTEM_COLOR;
        _choiceImageView1.backgroundColor = [UIColor clearColor];
    }
    
    _isChoice = !_isChoice;
}

//  取消按钮
- (void)cancelClick:(UIButton *)btn{
    
    [self removeFromSuperview];
}

//  确定按钮
- (void)sureBtnClick:(UIButton *)btn{
    
    [self removeFromSuperview];
}

@end
