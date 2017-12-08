//
//  WDMyJudgementsLayout.h
//  WuDou
//
//  Created by huahua on 16/12/2.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDMyJudgementModel.h"

#define kHeaderViewH 65

@interface WDMyJudgementsLayout : NSObject

/** model*/
@property(nonatomic, strong)WDMyJudgementModel *judgesModel;

/** 评论label的frame*/
@property(nonatomic, assign)CGRect judgesLabelFrame;

/** 底部图片视图的frame*/
@property(nonatomic, assign)CGRect bottomImgsViewFrame;

/** 单元格高度*/
@property(nonatomic, assign)CGFloat cellHeight;

@end
