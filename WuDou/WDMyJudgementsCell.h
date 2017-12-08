//
//  WDMyJudgementsCell.h
//  WuDou
//
//  Created by huahua on 16/12/2.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "WDMyJudgementsLayout.h"

@interface WDMyJudgementsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *judgesName;
@property (weak, nonatomic) IBOutlet UILabel *judgesTime;
@property (weak, nonatomic) IBOutlet StarView *judgesStarView;

/** layout*/  
@property(nonatomic, strong)WDMyJudgementsLayout *layout;
@property(nonatomic, strong)UILabel *judgesTextLabel; //评论label
@property (strong, nonatomic) UIScrollView *bottomView;  //底部图片
/** 区分我的评价Cell（0）还是商品详情评价Cell（1）*/
@property(nonatomic, assign)BOOL cellType;

@end
