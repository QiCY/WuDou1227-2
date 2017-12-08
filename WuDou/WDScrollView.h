//
//  WDScrollView.h
//  WuDou
//
//  Created by huahua on 16/11/24.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickLabelBlock)(NSInteger index,NSString *titleString);

@interface WDScrollView : UIView

/** 文字数组*/
@property (nonatomic,strong) NSArray *titleArray;
/** 拼接后的文字数组*/
@property (nonatomic,strong) NSMutableArray *titleNewArray;
/** block回调*/
@property (nonatomic,copy)void(^clickLabelBlock)(NSInteger index,NSString *titleString);
/** 字体颜色*/
@property (nonatomic,strong) UIColor *titleColor;
/** 背景颜色*/
@property (nonatomic,strong) UIColor *BGColor;
/** 字体大小*/
@property (nonatomic,assign) CGFloat titleFont;
/** 添加定时器*/
- (void)addTimer;
/** 关闭定时器*/
- (void)removeTimer;
/** label的点击事件*/
- (void)clickTitleLabel:(clickLabelBlock) clickLabelBlock;

@end
