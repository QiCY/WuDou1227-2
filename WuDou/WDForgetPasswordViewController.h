//
//  WDForgetPasswordViewController.h
//  WuDou
//
//  Created by huahua on 16/8/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDAppInitManeger.h"

@interface WDForgetPasswordViewController : UIViewController

/* 用户信息 **/
@property (weak, nonatomic) IBOutlet UITextField *userInfomation;

- (IBAction)getCodeClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *getCodeLab;
@property (weak, nonatomic) IBOutlet UITextField *msgCodeTF;

@property(nonatomic, copy)NSString * msgCode;
@property (weak, nonatomic) IBOutlet UIButton *getCodes;


@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UITextField *sureNewPassworeTF;


@end
