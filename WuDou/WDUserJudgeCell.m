//
//  WDUserJudgeCell.m
//  WuDou
//
//  Created by huahua on 16/10/17.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDUserJudgeCell.h"

@implementation WDUserJudgeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 创建子视图
    _cellTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    _cellTextLabel.numberOfLines = 0;
    _cellTextLabel.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_cellTextLabel];
}

- (void)setLayout:(WDCellLayout *)layout{
    
    _layout = layout;
    
    _cellTextLabel.text = _layout.judgeModel.message;
    _cellTextLabel.frame = _layout.textLabelFrame;
    
    NSString *socre = _layout.judgeModel.star;
    CGFloat value = [socre floatValue]/5*10;
    self.judgeStarView.starCount = value;
    
    self.judgeUserName.text = _layout.judgeModel.username;
    self.judgeAddTime.text = _layout.judgeModel.time;
}

@end
