//
//  WDDetailsTableViewCell.m
//  WuDou
//
//  Created by huahua on 16/8/8.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDDetailsTableViewCell.h"

#define KScreeenWidth [UIScreen mainScreen].bounds.size.width
#define  KScreeenHeight [UIScreen mainScreen].bounds.size.height
#define  RANDOMCOLOR  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];

@implementation WDDetailsTableViewCell

-(void)countOfButtonwithData:(NSMutableArray *)array
{
    [_scroll removeFromSuperview];
    [self UIConfigure];
    if (array.count>0)
    {
        for (int i=0; i< array.count; i++)
        {
            WDSpecialPriceModel * infosModel = array[i];
            
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*90, 0, 80, 80)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:infosModel.img]];
            [_scroll addSubview:imageView];
            
            nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10+i*90, 80, 80, 40)];
            nameLab.numberOfLines = 0;
            nameLab.textColor = [UIColor blackColor];
            nameLab.font = [UIFont systemFontOfSize:10.0];
            nameLab.text = infosModel.name;
            nameLab.textAlignment = NSTextAlignmentCenter;
            [_scroll addSubview:nameLab];
            
            moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(10+i*90, 115, 80, 20)];
            moneyLab.text = [NSString stringWithFormat:@"￥%@",infosModel.shopprice];
            moneyLab.font = [UIFont systemFontOfSize:10.0];
            moneyLab.textColor = [UIColor redColor];;
            [_scroll addSubview:moneyLab];
            
            bookBtn = [[UIButton alloc]init];
            bookBtn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:0];
            bookBtn.frame = CGRectMake(10+i*90, 0, 80, 140);
            _scroll.contentSize = CGSizeMake(array.count*90, 140);
            
            bookBtn.tag = i+10;
            [bookBtn addTarget:self action:@selector(btnCli:) forControlEvents:1<<6];
            [_scroll addSubview: bookBtn];
        }
    }
}

-(void)UIConfigure
{
    UIScrollView * scv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, KScreeenWidth, 140)];
    scv.showsHorizontalScrollIndicator = NO;
    scv.showsVerticalScrollIndicator = NO;
    _scroll = scv;
    [self.contentView addSubview: scv];
}
-(void)setClassR:(NSArray *)classR
{
    _classR = classR;
}
-(void)btnCli:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(WDDetails:didClickWDBtnTag:currentWDBtn:)])
    {
        [self.delegate WDDetails:self didClickWDBtnTag:sender.tag currentWDBtn:sender];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self UIConfigure];
}



@end
