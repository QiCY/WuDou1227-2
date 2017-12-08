//
//  WDCarTableViewCell.m
//  WuDou
//
//  Created by huahua on 16/8/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDCarTableViewCell.h"

@implementation WDCarTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
}
- (void)setGood:(WDChooseGood *)good indexPath:(NSIndexPath *)indexPath
{
    _good = good;
    _indexPath = indexPath;
    self.goodName.text = good.goodName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",good.goodPrice];
    self.numberLabel.text = good.goodNum;
    [self.goodImage sd_setImageWithURL:[NSURL URLWithString:good.goodImage]];
//    sb玩意连尼玛btn命名都反着来，我操你妈啊
    [self.addBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.subBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cellSelectBtn addTarget:self action:@selector(cellSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    if (_good.selected) {
        self.cellImage.image = [UIImage imageNamed:@"打钩"];
        
    }
    else
    {
        self.cellImage.image = [UIImage imageNamed:@"不打勾"];
    }
}

- (void)addClick:(UIButton *)sender{
    if (_delegate) {
        [_delegate addBtnClicked:_good indexPath:_indexPath];
    }
}
-(void)deleteClick:(UIButton*)sender{
    if (_delegate) {
        [_delegate deleteBtnClicked:_good indexPath:_indexPath];
    }
}
- (void)cellSelectClick:(UIButton *)sender{
    if (_delegate) {
        _good.selected = !_good.selected;
        [_delegate selectBtnClicked:_good indexPath:_indexPath];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
