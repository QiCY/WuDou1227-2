//
//  WDFixPasswordViewController.h
//  WuDou
//
//  Created by huahua on 16/8/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"

@interface WDFixPasswordViewController : UIViewController

/* 原密码 **/
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
/* 旧密码 **/
@property (weak, nonatomic) IBOutlet UITextField *presentPassword;
/* 确认密码 **/
@property (weak, nonatomic) IBOutlet UITextField *certainPassword;

@end
