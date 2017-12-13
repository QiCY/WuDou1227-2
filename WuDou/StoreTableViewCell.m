//
//  StoreTableViewCell.m
//  MenuSelect
//
//  Created by admin on 2017/11/20.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "StoreTableViewCell.h"
#import "WDNearbyStoreModel.h"

@implementation StoreTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createHeadView];
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)createHeadView{
    UIView *imgbg = [[UIView alloc] initWithFrame:CGRectMake(8, 8, 84, 64)];
    [self.contentView addSubview:imgbg];
    imgbg.layer.borderColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:240/255.0 alpha:1].CGColor;
    imgbg.layer.borderWidth = 0.5;
    imgbg.layer.cornerRadius = 5;
    [imgbg.layer setMasksToBounds:YES];
    self.storeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 60)];
    
    [self.contentView addSubview:self.storeImgView];
    
    self.storeName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.storeImgView.frame)+10, 5, 200, 30)];
    self.storeName.textColor = [UIColor blackColor];
    self.storeName.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.storeName];
    
    self.disTimeImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 5, 64, 20)];
    self.disTimeImg.hidden = YES;
    self.disTimeImg.image = [UIImage imageNamed:@"两小时必达.png"];
    [self.contentView addSubview:self.disTimeImg];
    
    self.scoreImg = [[XHLevelView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.storeImgView.frame)+10, 40, 60, 20)];
    [self.contentView addSubview:self.scoreImg];
    
    self.salesCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.scoreImg.frame)+10, 35, 100, 20)];
    self.salesCount.textColor = [UIColor blackColor];
    self.salesCount.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.salesCount];
    
    self.distance = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 35, 60, 20)];
    self.distance.textColor = [UIColor redColor];
    self.distance.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.distance];
    
    self.minPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.storeImgView.frame)+10, 55, 100, 20)];
    self.minPrice.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.minPrice];
    
    self.transPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.minPrice.frame)+10, 55, 100, 20)];
    self.transPrice.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.transPrice];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(self.transPrice.frame), kScreenWidth - 100, 10)];
    line.image = [UIImage imageNamed:@"线"];
    [self.contentView addSubview:line];
    
    
    self.discountView = [[DisCountView alloc] init];
    [self.contentView addSubview:self.discountView];
    
   
    self.upDownBtn = [[UIButton alloc] init];
    [self.upDownBtn setBackgroundImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [self.upDownBtn setBackgroundImage:[UIImage imageNamed:@"up_arrow"] forState:UIControlStateSelected];
    [self.upDownBtn addTarget:self action:@selector(upDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.upDownBtn.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.upDownBtn];
    
    self.upView = [[UIButton alloc] init];
    [self.upView addTarget:self action:@selector(upDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.upView];
    
    self.goodsView = [[UIScrollView alloc] init];
    [self.contentView addSubview:self.goodsView];
    
}
- (void)upDownBtnClick{
    self.upDownBtn.selected = !self.upDownBtn.selected;
    self.model.isCloseDis = !self.upDownBtn.selected;
    if (self.delegate) {
        [self.delegate openOrCloseDiscountView:self.model];
    }
}
-(void)setCellData:(id)data{
    WDNearbyStoreModel *model = nil;
    if ([data isKindOfClass:[WDNearbyStoreModel class]]) {
        model = (WDNearbyStoreModel *)data;
        self.model = model;
    }
    NSArray *discountList = [model.discounttitle componentsSeparatedByString:@","];
    if (discountList.count>0) {
        if (model.isCloseDis) {
            self.discountView.frame = CGRectMake(CGRectGetMaxX(self.storeImgView.frame)+10, 85, kScreenWidth -CGRectGetMaxX(self.storeImgView.frame)-10 , 20*2);
        }else{
            self.discountView.frame = CGRectMake(CGRectGetMaxX(self.storeImgView.frame)+10, 85, kScreenWidth -CGRectGetMaxX(self.storeImgView.frame)-10 , 20*discountList.count);
        }
        
        [self.discountView setData:discountList isClose:model.isCloseDis];
        
        self.upDownBtn.frame = CGRectMake(kScreenWidth - 40, 90, 18, 10);
        self.upView.frame = CGRectMake(kScreenWidth - 60, 80, 50, 30);
        self.discountView.hidden = NO;
        self.upDownBtn.hidden = NO;
        self.upView.hidden = NO;
        
    }else{
        self.upDownBtn.hidden = YES;
        self.discountView.hidden = YES;
          self.upView.hidden = YES;
    }

    NSArray *goodsList = model.storesproducts[@"subdata"];
    [self setGoodsViewWithData:goodsList];
    [self.storeImgView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.storeName.text = model.name;
    self.scoreImg.level = model.star;
    
    self.salesCount.text = [NSString stringWithFormat:@"月销%@笔",model.monthlysales];
    self.distance.text = model.distance;
//    self.minPrice.text = model.startfee;
    [self setLabelString:self.minPrice text:[NSString stringWithFormat:@"起送：%@",[NSString stringWithFormat:@"￥%@",model.startvalue]] subtext:[NSString stringWithFormat:@"￥%@",model.startvalue]];
    [self setLabelString:self.transPrice text:[NSString stringWithFormat:@"配送：%@",[NSString stringWithFormat:@"￥%@",model.startfee]] subtext:[NSString stringWithFormat:@"￥%@",model.startfee]];
//    self.transPrice.text = model.startvalue;
    
   
}
-(void)setLabelString:(UILabel *)label text:(NSString *)text subtext:(NSString *)subtext{
    
    
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName
     
                            value:[UIColor redColor]
     
                            range:[text rangeOfString:subtext]];
    label.attributedText = attrDescribeStr;
}
- (void)setGoodsViewWithData:(NSArray *)datalist
{
    for (UIView *subView in self.goodsView.subviews) {
        [subView removeFromSuperview];
    }
    
    self.goodsView.contentSize = CGSizeMake(80*datalist.count, 100);
    if (datalist.count>0) {
        self.goodsView.frame = CGRectMake(CGRectGetMaxX(self.storeImgView.frame)+10,self.discountView.hidden?CGRectGetMaxY(self.storeImgView.frame)+10:CGRectGetMaxY(self.discountView.frame), kScreenWidth -CGRectGetMaxX(self.storeImgView.frame)-10 , 100);
        self.goodsView.hidden = NO;
        for (int i = 0; i<datalist.count; i++) {
            GoodsCardView *card = [[GoodsCardView alloc] initWithFrame:CGRectMake(i*80, 0, 80, 100) data:datalist[i]];
            [card addTarget:self action:@selector(cardClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.goodsView addSubview:card];
            
        }
    }else{
        self.goodsView.hidden = YES;
    }
}
- (void)cardClicked:(GoodsCardView *)sender{
    if (self.delegate) {
        [self.delegate cardDidSelect:sender.data];
    }
}
@end

@implementation DisCountView
-(id)init
{
    if (self = [super init]) {
        self.disCountImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 21, 12)];
        self.disCountImg.image = [UIImage imageNamed:@"优惠"];
        [self addSubview:self.disCountImg];
       
    }
    return self;
}
-(void)setData:(NSArray *)discountList isClose:(BOOL)close{
    if (!_discountView) {
        _discountView = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 200, 20*discountList.count)];
        [self addSubview:_discountView];
    }
    for (UIView *subView in _discountView.subviews) {
        [subView removeFromSuperview];
    }
    NSInteger num = discountList.count;
    if (close) {
        num = 2;
    }
    for (int i = 0; i<num; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i*20, 200, 20)];
        label.textColor = [UIColor blackColor];
        label.text = discountList[i];
        label.font = [UIFont systemFontOfSize:12];
        [_discountView addSubview:label];
    }
}
@end


@implementation GoodsCardView
-(id)initWithFrame:(CGRect)frame data:(id)data{
    if (self = [super initWithFrame:frame]) {
        self.data = data;
        UILabel *imgbg = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 76, 76)];
        imgbg.layer.cornerRadius = 3;
        imgbg.layer.borderWidth = 0.5;
        imgbg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:imgbg];
        
        
        
        self.goodImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        [self.goodImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,data[@"img"]]]];
        [self addSubview:self.goodImg];
        
        self.hotSaleImg = [[UIImageView alloc] initWithFrame:CGRectMake(4, 5, 21, 12)];
        if ([data[@"ishot"] boolValue]) {
            self.hotSaleImg.image = [UIImage imageNamed:@"热销"];
        }else{
            self.hotSaleImg.image = nil;
        }
        
//        self.hotSaleImg.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.hotSaleImg];
        
        self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 80, 20)];
        self.priceLab.textColor = [UIColor redColor];
        self.priceLab.text =[NSString stringWithFormat:@"￥%@",data[@"shopprice"]] ;
        self.priceLab.font = [UIFont systemFontOfSize:14];
        self.priceLab.textAlignment = 1;
        [self addSubview:self.priceLab];
    }
    return self;
}
@end
