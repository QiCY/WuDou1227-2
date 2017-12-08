//
//  WDSecondPublishViewController.h
//  WuDou
//
//  Created by huahua on 16/10/20.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMainRequestManager.h"

@interface WDSecondPublishViewController : UIViewController

/** scrollView*/
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
/** contentView*/
@property (weak, nonatomic) IBOutlet UIView *contentView;
/** 标题输入框*/
@property (weak, nonatomic) IBOutlet UITextField *secondTitle;
/** 封面图片*/
@property (weak, nonatomic) IBOutlet UIView *secondPicsView;
/** 价格输入框*/
@property (weak, nonatomic) IBOutlet UITextField *secondPrice;
/** 地区输入框*/
@property (weak, nonatomic) IBOutlet UITextField *secondArea;
/** 地区下拉按钮*/
@property (weak, nonatomic) IBOutlet UIButton *secondAreaBtn;
/** 联系人输入框*/
@property (weak, nonatomic) IBOutlet UITextField *secondContents;
/** 电话输入框*/
@property (weak, nonatomic) IBOutlet UITextField *secondMobile;
/** 企业不打勾小圆框*/
@property (weak, nonatomic) IBOutlet UIImageView *secondCompany;
/** 个人不打勾小圆框*/
@property (weak, nonatomic) IBOutlet UIImageView *secondPonsonal;
/** 详细介绍输入框*/
@property (weak, nonatomic) IBOutlet UITextView *secondMarks;
/** placeholder提示语*/
@property (weak, nonatomic) IBOutlet UILabel *myplaceholder;
/** 发布按钮*/
@property (weak, nonatomic) IBOutlet UIButton *secondPublishBtn;


@end
