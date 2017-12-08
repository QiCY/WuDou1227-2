//
//  WDCellLayout.m
//  WuDou
//
//  Created by huahua on 16/10/17.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDCellLayout.h"

@implementation WDCellLayout

- (void)setJudgeModel:(WDJudgeModel *)judgeModel{
    
    _judgeModel = judgeModel;
    
    //计算lable 的frame
        NSDictionary *dic = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:14.0]
                              };
        CGRect frame = [judgeModel.message boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 1000)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:dic
                                                     context:nil];
    //设置lable 的frame
    self.textLabelFrame = CGRectMake(10, kHeaderViewHeight, kScreenWidth - 2 * 10, frame.size.height);
    
    //计算cell的高度
    self.cellHeight = kHeaderViewHeight + self.textLabelFrame.size.height + 10;
}


@end
