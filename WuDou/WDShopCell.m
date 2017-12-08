//
//  WDShopCell.m
//  WuDou
//
//  Created by admin on 2017/12/8.
//  Copyright © 2017年 os1. All rights reserved.
//

#import "WDShopCell.h"
#import "WDChooseGood.h"
#import "UIButton+WebCache.h"
#import "WDGoodsInfoViewController.h"
#import "WDAppInitManeger.h"
@implementation WDShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 80, 30)];
        self.shopName.textColor = [UIColor blackColor];
        self.shopName.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.shopName];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 29.5, kScreenWidth - 40, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self.contentView addSubview:line];
        
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shopName.frame)+20, 0, 30, 30)];
        [self.deleteBtn setImage:[UIImage imageNamed:@"comment_delete"] forState:UIControlStateNormal];
        [self.deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteBtn];
        
        self.goodsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.shopName.frame), kScreenWidth - 100, 60)];
        [self.contentView addSubview:self.goodsScroll];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.goodsScroll.frame)-0.5, kScreenWidth - 40, 0.5)];
        line1.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self.contentView addSubview:line1];
        
        
        self.allCountLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsScroll.frame), CGRectGetMaxY(self.shopName.frame)+10, 60, 20)];
        self.allCountLab.textColor = [UIColor blackColor];
        self.allCountLab.textAlignment = 1;
        self.allCountLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.allCountLab];
        
        self.allWeightLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsScroll.frame), CGRectGetMaxY(self.allCountLab.frame), 60, 20)];
        self.allWeightLab.text = @"1.37kg";
        self.allWeightLab.textAlignment = 1;
        self.allWeightLab.textColor = [UIColor darkGrayColor];
        self.allWeightLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.allWeightLab];
        
        UILabel *goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.goodsScroll.frame), 100, 30)];
        goodsPrice.textColor = [UIColor blackColor];
        goodsPrice.text = @"商品金额";
        goodsPrice.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:goodsPrice];
        
        self.allGoodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 120, CGRectGetMaxY(self.goodsScroll.frame), 100, 30)];
        self.allGoodsPrice.textColor = [UIColor blackColor];
        self.allGoodsPrice.textAlignment = 2;
        self.allGoodsPrice.text = @"商品金额";
        self.allGoodsPrice.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.allGoodsPrice];
        
        
        UILabel *transPrice = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(goodsPrice.frame), 100, 30)];
        transPrice.textColor = [UIColor blackColor];
        transPrice.text = @"运费金额";
        transPrice.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:transPrice];
        
        
        self.transPrice = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 120, CGRectGetMaxY(goodsPrice.frame), 100, 30)];
        self.transPrice.textColor = [UIColor blackColor];
        self.transPrice.textAlignment = 2;
        self.transPrice.text = @"运费金额";
        self.transPrice.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.transPrice];
        
        
        self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.transPrice.frame), kScreenWidth - 140, 30)];
        self.totalPrice.textColor = [UIColor redColor];
        self.totalPrice.textAlignment = 2;
        self.totalPrice.text = @"运费金额";
        self.totalPrice.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.totalPrice];
    
        self.payBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 90, CGRectGetMaxY(self.transPrice.frame)+2, 70, 26)];
//        self.payBtn.layer.cornerRadius = 5;
        self.payBtn.backgroundColor = KSYSTEM_COLOR;
        self.payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.payBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [self.payBtn addTarget:self action:@selector(payBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.payBtn];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.payBtn.frame)+10, kScreenWidth, 10)];
        line2.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self.contentView addSubview:line2];
        self.footer = line2;
        
    }
    return self;
}
- (void)addRedPointToLab:(NSString *)text label:(UILabel *)label
{
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    label.attributedText = attStr;
}

- (void)setShop:(WDCarShop *)shop target:(id)target;
{
    _shop = shop;
    _delegate = target;
    
    WDChooseGood *good = shop.goodsList.firstObject;
    self.shopName.text =[NSString stringWithFormat:@"%@  >",shop.shopName] ;
    self.allGoodsPrice.text =[NSString stringWithFormat:@"￥%.2f",[self getAllGoodPrice]] ;
    
    if ([self getAllGoodPrice]<[good.goodStartFee floatValue]) {
        float total = [self getAllGoodPrice] + [good.goodDistributePrice floatValue];
        self.totalPrice.text = [NSString stringWithFormat:@"合计：￥%.2f",total];
        self.transPrice.text = [NSString stringWithFormat:@"￥%.2f",[good.goodDistributePrice floatValue] ];
    }else{
        float total = [self getAllGoodPrice];
        self.totalPrice.text = [NSString stringWithFormat:@"合计：￥%.2f",total];
        self.transPrice.text = [NSString stringWithFormat:@"￥%.2f",0.0];
    }
    
    [self addRedPointToLab:self.totalPrice.text label:self.totalPrice];
    self.allCountLab.text = [NSString stringWithFormat:@"共计%d件",[self getAllGoodCount]];
    [self setGoodsListScroll:shop.goodsList];
  
}
- (BOOL)checkOrderIsCanSubmit:(WDCarShop *)shop{
    float price = 0;
    float startFee = 0;
    for (WDChooseGood *good in shop.goodsList) {
        
        price = price + [good.goodPrice floatValue] * [good.goodNum intValue];
        
        startFee = [good.goodStartFee floatValue];
    }
    if (price<startFee) {
        return NO;
    }
    return YES;
}
- (void)setGoodsListScroll:(NSMutableArray *)goodsList{
    for (UIView *subView in self.goodsScroll.subviews) {
        [subView removeFromSuperview];
    }
    for (int i = 0; i<goodsList.count; i++) {
        WDChooseGood *good = goodsList[i];
        UIButton *goodBtn = [[UIButton alloc] initWithFrame:CGRectMake(0+(60+5)*i, 5, 60, 60)];
        goodBtn.tag = i;
        [goodBtn addTarget:self action:@selector(goodBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        [goodBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:good.goodImage] forState:UIControlStateNormal];
        [self.goodsScroll addSubview:goodBtn];
    }
    self.goodsScroll.contentSize = CGSizeMake(65*goodsList.count, 60);
}
- (void)deleteBtnClicked{
    if (_delegate) {
        [_delegate didClickedDeleteBtn:_shop];
    }
}
- (void)payBtnClicked{
    if (_delegate) {
        [_delegate didClickedPayBtn:_shop];
    }
}
- (void)goodBtnClicked:(UIButton *)sender{
        WDChooseGood *good = _shop.goodsList[sender.tag];
    if (_delegate) {
        [_delegate didClickedGoodBtn:good];
    }
}
- (int)getAllGoodCount{
    int total = 0;
    for (WDChooseGood *good in self.shop.goodsList) {
        total = total +  [good.goodNum intValue];
    }
    return total;
}
- (float)getAllGoodPrice{
    float total = 0.0;
    for (WDChooseGood *good in self.shop.goodsList) {
        total = total + [good.goodPrice floatValue] * [good.goodNum intValue];
    }
    return total;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
