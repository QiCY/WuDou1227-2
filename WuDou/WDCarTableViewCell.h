//
//  WDCarTableViewCell.h
//  WuDou
//
//  Created by huahua on 16/8/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDChooseGood.h"

@protocol WDCarCellDelegate
@optional
- (void)selectBtnClicked:(WDChooseGood *)good indexPath:(NSIndexPath *)indexPath;
- (void)addBtnClicked:(WDChooseGood *)good indexPath:(NSIndexPath *)indexPath;
- (void)deleteBtnClicked:(WDChooseGood *)good indexPath:(NSIndexPath *)indexPath;
@end;



@interface WDCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *cellSelectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property(nonatomic,strong)WDChooseGood *good;
@property(nonatomic,weak)id<WDCarCellDelegate>delegate;
@property(nonatomic,strong)NSIndexPath *indexPath;
- (void)setGood:(WDChooseGood *)good indexPath:(NSIndexPath *)indexPath;
@end
