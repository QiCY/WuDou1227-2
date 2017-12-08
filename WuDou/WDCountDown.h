//
//  WDCountDown.h
//  WuDou
//
//  Created by huahua on 16/12/27.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDCountDown : UILabel

/** 天*/
@property (nonatomic,assign)NSInteger day;
/** 时*/
@property (nonatomic,assign)NSInteger hour;
/** 分*/
@property (nonatomic,assign)NSInteger minute;
/** 秒*/
@property (nonatomic,assign)NSInteger second;

@end
