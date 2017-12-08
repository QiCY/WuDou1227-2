//
//  WDUserJudgeCell.h
//  WuDou
//
//  Created by huahua on 16/10/17.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "WDCellLayout.h"

@interface WDUserJudgeCell : UITableViewCell


@property (weak, nonatomic) IBOutlet StarView *judgeStarView;

@property (weak, nonatomic) IBOutlet UILabel *judgeUserName;

@property (weak, nonatomic) IBOutlet UILabel *judgeAddTime;

@property(nonatomic, strong)WDCellLayout *layout;
@property(nonatomic, strong)UILabel *cellTextLabel; //评论label

@end
