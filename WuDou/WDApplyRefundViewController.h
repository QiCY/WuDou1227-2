//
//  WDApplyRefundViewController.h
//  WuDou
//
//  Created by huahua on 16/12/29.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"

@interface WDApplyRefundViewController : UIViewController

/** 下拉列表视图*/
@property (weak, nonatomic) IBOutlet UIView *orderListView;
/** 显示原因*/
@property (weak, nonatomic) IBOutlet UILabel *quehuoLabel;
/** 弹出下拉列表按钮*/
@property (weak, nonatomic) IBOutlet UIButton *orderListBtn;
/** 退款原因说明*/
@property (weak, nonatomic) IBOutlet UITextView *tuikuanReason;
/** TextView的提示语*/
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
/** 商家反馈*/
@property (strong, nonatomic) UILabel *fankuiLabel;
/** 提交按钮*/
@property (strong, nonatomic) UIButton *commitBtn;

/** oid*/
@property(nonatomic, copy)NSString *oid;

@end
