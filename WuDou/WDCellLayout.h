//
//  WDCellLayout.h
//  WuDou
//
//  Created by huahua on 16/10/17.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDJudgeModel.h"

#define kHeaderViewHeight 40

@interface WDCellLayout : NSObject

@property(nonatomic, strong)WDJudgeModel *judgeModel;
/** 单元格的高度*/
@property(nonatomic, assign)CGFloat cellHeight;
/** 评论label的frame*/
@property(nonatomic, assign)CGRect textLabelFrame;

@end
