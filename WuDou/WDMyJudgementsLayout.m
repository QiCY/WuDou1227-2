//
//  WDMyJudgementsLayout.m
//  WuDou
//
//  Created by huahua on 16/12/2.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMyJudgementsLayout.h"

@implementation WDMyJudgementsLayout

- (void)setJudgesModel:(WDMyJudgementModel *)judgesModel{
    
    _judgesModel = judgesModel;
    
    //计算lable 的frame
    NSDictionary *dic = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:14.0]
                          };
    CGRect frame = [_judgesModel.message boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 1000)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:dic
                                                    context:nil];
    //设置lable 的frame
    self.judgesLabelFrame = CGRectMake(10, kHeaderViewH, kScreenWidth - 2*10, frame.size.height);
    
    
    //判断是否有图片
    NSArray *pics = _judgesModel.imgs;
    CGFloat bottomViewH;
    if (pics.count == 0) {
        
        bottomViewH = 0;
    }else{
        
        bottomViewH = 60;
    }
    
    //设置底部图片视图的frame
    self.bottomImgsViewFrame = CGRectMake(10, CGRectGetMaxY(self.judgesLabelFrame)+10, kScreenWidth-20, bottomViewH);
    
    //计算cell的高度
    self.cellHeight = kHeaderViewH + self.judgesLabelFrame.size.height + self.bottomImgsViewFrame.size.height + 20;
}

@end
