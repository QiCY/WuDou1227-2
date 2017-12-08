//
//  WDRegisterViewController.h
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDAppInitManeger.h"

@interface WDRegisterViewController : UIViewController

/* 输入手机号 **/
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/* 输入密码 **/
@property (weak, nonatomic) IBOutlet UITextField *password;
/* 是否显示密码 **/
@property (weak, nonatomic) IBOutlet UIButton *showPasswordEnabled;
/* 输入短信验证码 **/
@property (weak, nonatomic) IBOutlet UITextField *messageCodes;
/* 获取验证码 **/
@property (weak, nonatomic) IBOutlet UIButton *getCodes;
/* 注册成功 **/
@property (weak, nonatomic) IBOutlet UIButton *successRegister;
/* 物兜注册协议 **/
@property (weak, nonatomic) IBOutlet UIButton *wuDouProtocol;
- (IBAction)getCodesClick:(UIButton *)sender;
- (IBAction)successRegisterClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *getCodeLab;
- (IBAction)showPasswordClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *showPassImage;

@property(nonatomic, copy)NSString * msgCode;


@end
