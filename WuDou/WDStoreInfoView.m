//
//  WDStoreInfoView.m
//  WuDou
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 os1. All rights reserved.
//

#import "WDStoreInfoView.h"
#import "WDStoreInfosModel.h"
@implementation WDStoreInfoView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KSYSTEM_COLOR;
        [self createHeadView];
    }
    return self;
}
-(void)createHeadView{
    
    self.storeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    self.storeImgView.layer.cornerRadius = 30;
    [self.storeImgView.layer setMasksToBounds:YES];
    [self addSubview:self.storeImgView];
    
    self.storeName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.storeImgView.frame)+10, 10, 200, 20)];
    self.storeName.textColor = [UIColor whiteColor];
    self.storeName.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.storeName];
    
    self.transPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.storeImgView.frame)+10, 30, kScreenWidth - 110, 20)];
    self.transPrice.textColor = [UIColor whiteColor];
    self.transPrice.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.transPrice];

    
    self.allCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.storeImgView.frame)+10, 50, kScreenWidth - 110, 20)];
    self.allCount.textColor = [UIColor whiteColor];
    self.allCount.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.allCount];
    
    self.discountBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 30, 30, 40)];
    [self.discountBtn setBackgroundImage:[UIImage imageNamed:@"优惠券(4)"] forState:UIControlStateNormal];
    self.discountBtn.hidden = YES;
    [self.discountBtn addTarget:self action:@selector(discountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.discountBtn];
}
- (void)setStoreInfo:(WDStoreInfosModel *)store
{
    self.transPrice.text = [NSString stringWithFormat:@"配送费￥%@ | 起送价￥%@",store.startfee,store.startvalue];
    self.allCount.text = [NSString stringWithFormat:@"共%@件商品 | 月售%@单",store.productscount,store.monthlysales];
    [self.storeImgView sd_setImageWithURL:[NSURL URLWithString:store.img]];
    self.storeName.text = store.name;
    if ([store.hascoupons boolValue]) {
        self.discountBtn.hidden = NO;
    }else{
        self.discountBtn.hidden = YES;
    }
}

-(CGFloat)getTextWidthWithFontSize:(CGFloat)size string:(NSString *)text height:(CGFloat)height{
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    
    return titleSize.width;
}
- (void)discountBtnClick{
    if (_delegate) {
        [_delegate didClickedDiscountBtn];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
