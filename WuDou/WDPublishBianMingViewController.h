//
//  WDPublishBianMingViewController.h
//  WuDou
//
//  Created by huahua on 16/8/18.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMainRequestManager.h"

@interface WDPublishBianMingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
/** 标题输入框*/
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
- (IBAction)rmoveJianPan:(UIButton *)sender;
/** 封面图片*/
@property (weak, nonatomic) IBOutlet UIView *fengmianImageView;
/** 地区label*/
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
/** 地区view*/
@property (weak, nonatomic) IBOutlet UIView *areaView;
/** 地区输入框*/
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
/** 地区下拉按钮*/
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
/** 分类输入框*/
@property (weak, nonatomic) IBOutlet UITextField *categroyTextField;
/** 分类下拉按钮*/
@property (weak, nonatomic) IBOutlet UIButton *categroybtn;
/** 联系人输入框*/
@property (weak, nonatomic) IBOutlet UITextField *friendsTextField;
/** 电话输入框*/
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
/** 个人不打勾小圆框*/
@property (weak, nonatomic) IBOutlet UIImageView *normalImageView1;
/** 企业不打勾小圆框*/
@property (weak, nonatomic) IBOutlet UIImageView *normalImageView2;
/** 详细介绍输入框*/
@property (weak, nonatomic) IBOutlet UITextView *infosTextView;
/** 发布按钮*/
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UIView *bigView;

@end
