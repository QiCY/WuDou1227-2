//
//  WDMainCell.h
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDMainCell : UITableViewCell

/* 列表图标 **/
@property (weak, nonatomic) IBOutlet UIImageView *listImageView;
/* 列表名称 **/
@property (weak, nonatomic) IBOutlet UILabel *listLabel;
/* 前往按钮 **/
@property (weak, nonatomic) IBOutlet UIImageView *gotoBtn;
/* 是否显示 前往按钮 **/
@property (assign, nonatomic) BOOL showGotoBtnEnabled;

@end
