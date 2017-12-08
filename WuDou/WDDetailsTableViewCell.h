//
//  WDDetailsTableViewCell.h
//  WuDou
//
//  Created by huahua on 16/8/8.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSpecialPriceModel.h"

@class WDDetailsTableViewCell;
@protocol WDDetailsTableViewCellDelegate <NSObject>


-(void)WDDetails:(WDDetailsTableViewCell *)cell didClickWDBtnTag:(NSInteger)WDBtnTag currentWDBtn:(UIButton*)sender;
@end

@interface WDDetailsTableViewCell:UITableViewCell
{
    UIImageView * imageView;
    UILabel * nameLab;
    UILabel * moneyLab;
    UIButton * bookBtn;
}

@property (weak, nonatomic) IBOutlet UIImageView *shopLogoImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *maney;

@property(nonatomic,strong)UIScrollView * scroll;
@property(nonatomic,strong)NSArray * classR;
@property(nonatomic,weak)id<WDDetailsTableViewCellDelegate> delegate;
-(void)countOfButtonwithData:(NSMutableArray *)array;

@end
