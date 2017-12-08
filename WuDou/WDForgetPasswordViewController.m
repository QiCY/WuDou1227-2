//
//  WDForgetPasswordViewController.m
//  WuDou
//
//  Created by huahua on 16/8/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDForgetPasswordViewController.h"
#import "WDLoginViewController.h"

@interface WDForgetPasswordViewController ()<UITextFieldDelegate>
{
    NSTimer * _timer;
    int _time;
}

@end

@implementation WDForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _time = 60;
    self.title = @"找回密码";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
    
    self.userInfomation.delegate = self;
    self.msgCodeTF.delegate = self;
    self.passwordTF.delegate = self;
    self.sureNewPassworeTF.delegate = self;
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 15, 20);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


/* 确认重置 **/
- (IBAction)nextStep:(UIButton *)sender
{
    
    if ([self.passwordTF.text isEqualToString:self.sureNewPassworeTF.text]) {
        
        [WDAppInitManeger requestFindPasswordWithMobile:self.userInfomation.text verificationCode:self.msgCodeTF.text newPassword:self.passwordTF.text completion:^(NSString *result, WDAppInit *appInit, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return;
            }
            else{
                
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:result preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   
                    [self.view endEditing:YES];
                    
                    WDLoginViewController *loginVC = [[WDLoginViewController alloc] init];
                    [self.navigationController pushViewController:loginVC animated:YES];
                    
                }];
                
                [alertView addAction:sure];
                [self presentViewController:alertView animated:YES completion:nil];  //用模态的方法显示对话框
            }
        }];
        
    }else{
        
        SHOW_ALERT(@"两次输入的密码不一致，请重新输入")
    }
    
//    
//    [WDRequestManager requestToForgetPwdWithPhone:self.userInfomation.text WithMsgCode:self.msgCodeTF.text completion:^(NSString *error)
//    {
//        if (error)
//        {
//            SHOW_ALERT(error);
//            return;
//        }
//        WDFogetPasswordNextViewController *nextStepVC = [[WDFogetPasswordNextViewController alloc] init];
//        [self.navigationController pushViewController:nextStepVC animated:YES];
//        nextStepVC.msgCode = self.msgCodeTF.text;
//        nextStepVC.phone = self.userInfomation.text;
//    }];
//    
}

- (IBAction)getCodeClick:(UIButton *)sender
{
    BOOL isPhone = [WDAppInitManeger validateNumber:self.userInfomation.text];
    if ([self.userInfomation.text isEqualToString:@""])
    {
        SHOW_ALERT(@"用户信息不能为空！");
    }
    else if (isPhone == NO)
    {
        SHOW_ALERT(@"请填入正确的手机号！");
    }
    else
    {
        [WDAppInitManeger requestForgetPasswordVerificationCodeWithMobile:self.userInfomation.text completion:^(NSString *codeModel, NSString *error) {
            
            if (error)
            {
                SHOW_ALERT(error);
                return ;
            }
            self.msgCode = codeModel;
            [self.view endEditing:YES];
            self.getCodes.userInteractionEnabled = NO;
            if (_timer == nil)
            {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goTime) userInfo:nil repeats:YES];
            }
        }];
  
//        [WDRequestManager requestToMsgCodeWithPhone:self.userInfomation.text WithType:@"2" completion:^(NSString *msgCode, NSString *error)
//         {
//             if (error)
//             {
//                 SHOW_ALERT(error);
//                 return ;
//             }
//             self.msgCode = msgCode;
//             [self.view endEditing:YES];
//             self.getCodes.userInteractionEnabled = NO;
//             if (_timer == nil)
//             {
//                 _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goTime) userInfo:nil repeats:YES];
//             }
//         }];
        
    }
}

-(void)goTime
{
    _time--;
    if (_time == 0)
    {
        [_timer invalidate];
        _timer = nil;
        _time = 60;
        self.getCodes.userInteractionEnabled = YES;
        self.getCodeLab.backgroundColor = KSYSTEM_COLOR;
        self.getCodeLab.text = @"获取验证码";
    }
    else
    {
        self.getCodeLab.backgroundColor = [UIColor lightGrayColor];
        self.getCodeLab.text =  [NSString stringWithFormat:@"%d秒后重试",_time];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.userInfomation) {
        
        [textField resignFirstResponder];
        [self.msgCodeTF becomeFirstResponder];
    }
    if (textField == self.msgCodeTF) {
        
        [textField resignFirstResponder];
        [self.passwordTF becomeFirstResponder];
    }
    if (textField == self.passwordTF) {
        
        [textField resignFirstResponder];
        [self.sureNewPassworeTF becomeFirstResponder];
    }
    if (textField == self.sureNewPassworeTF) {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}


@end
