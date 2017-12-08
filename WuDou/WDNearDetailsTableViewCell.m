//
//  WDNearDetailsTableViewCell.m
//  WuDou
//
//  Created by huahua on 16/8/9.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDNearDetailsTableViewCell.h"

@implementation WDNearDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setIsShowEnabled:(BOOL)isShowEnabled{
    
    _isShowEnabled = isShowEnabled;
    
    self.leftBtn.hidden = _isShowEnabled ? NO : YES;
    self.numberLabel.hidden = _isShowEnabled ? NO : YES;
    self.addBtn.hidden = _isShowEnabled ? NO : YES;
}
- (void)setSearchInfoModel:(WDSearchInfosModel *)goods count:(NSString *)count indexPath:(NSIndexPath *)indexPath{
    _model = goods;
    _count = [count intValue];
    _indexPath = indexPath;
    self.nameLab.text = goods.name;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",goods.shopprice];
    [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:goods.img]];
   
    [self.subBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if ([count isEqualToString:@"0"]) {
        
        self.isShowEnabled = 0;
    }else{
        
        self.isShowEnabled = 1;
        self.numberLabel.text = count;
        [self.addBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
  
}

- (void)addBtnClick{
    _count++;
    self.numberLabel.text = [NSString stringWithFormat:@"%d",_count];
    if (_delegate) {
        [_delegate addBtnClicked:_model count:[NSString stringWithFormat:@"%d",_count] indexPath:_indexPath];
    }
}
- (void)deleteBtnClick
{
    if (_count>0) {
        _count--;
        self.numberLabel.text = [NSString stringWithFormat:@"%d",_count];
        if (_delegate) {
            [_delegate deleteBtnClicked:_model count:[NSString stringWithFormat:@"%d",_count] indexPath:_indexPath];
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
