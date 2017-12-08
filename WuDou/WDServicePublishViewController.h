//
//  WDServicePublishViewController.h
//  WuDou
//
//  Created by huahua on 16/10/21.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMainRequestManager.h"

@interface WDServicePublishViewController : UIViewController

/** scrollView*/
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
/** 标题输入框*/
@property (weak, nonatomic) IBOutlet UITextField *serviceTitle;
/** 封面图片*/
@property (weak, nonatomic) IBOutlet UIView *servicePicsView;
/** 地区输入框*/
@property (weak, nonatomic) IBOutlet UITextField *serviceRegion;
/** 地区下拉按钮*/
@property (weak, nonatomic) IBOutlet UIButton *serviceAreaBtn;
/** 分类输入框*/
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
/** 分类下拉按钮*/
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
/** 联系人输入框*/
@property (weak, nonatomic) IBOutlet UITextField *serviceContents;
/** 电话输入框*/
@property (weak, nonatomic) IBOutlet UITextField *serviceMobile;
/** 企业不打勾小圆框*/
@property (weak, nonatomic) IBOutlet UIImageView *serviceCompany;
/** 个人不打勾小圆框*/
@property (weak, nonatomic) IBOutlet UIImageView *servicePersonal;
/** 详细介绍输入框*/
@property (weak, nonatomic) IBOutlet UITextView *serviceMarks;
/** placeholder提示语*/
@property (weak, nonatomic) IBOutlet UILabel *servicePlaceholder;
/** 发布按钮*/
@property (weak, nonatomic) IBOutlet UIButton *servicePublishBtn;


@end
