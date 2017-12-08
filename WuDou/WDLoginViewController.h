//
//  WDLoginViewController.h
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WDAppInitManeger.h"

@interface WDLoginViewController : UIViewController

/* 用户名 **/
@property (weak, nonatomic) IBOutlet UITextField *userName;
/* 密码 **/
@property (weak, nonatomic) IBOutlet UITextField *passWord;
/* 忘记密码 **/
@property (weak, nonatomic) IBOutlet UIButton *forgetPassword;
/* 登录 **/
@property (weak, nonatomic) IBOutlet UIButton *login;


@property(nonatomic, strong)WDAppInit *appInit;

/** 点击登录按钮跳转不同页面时的状态变量*/
@property(nonatomic,copy)NSString *popType;

@end
