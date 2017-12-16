//
//  WDFixPasswordViewController.m
//  WuDou
//
//  Created by huahua on 16/8/6.
//  Copyright © 2016年 os1. All rights reserved.
//  我的账户 -- 设置 -- 修改密码

#import "WDFixPasswordViewController.h"
#import "WDLoginViewController.h"

@interface WDFixPasswordViewController ()<UIAlertViewDelegate,UITextFieldDelegate>

@end

@implementation WDFixPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self _setupNavigation];
    
    self.oldPassword.delegate = self;
    self.presentPassword.delegate = self;
    self.certainPassword.delegate = self;
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 60, 40);
     [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12,45)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


/* 确定修改按钮 **/
- (IBAction)fixPassword:(UIButton *)sender
{
    UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改后需重新登录！是否确定修改？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alerView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
    }
    if (buttonIndex == 1)
    {
        if ([self.presentPassword.text isEqualToString:self.certainPassword.text]) {
            
            [WDMineManager requestFixPasswordWithOldPassword:self.oldPassword.text newPassword:self.presentPassword.text completion:^(NSString *result, NSString *error) {
                
                if (error)
                {
                    SHOW_ALERT(error);
                    return ;
                }
                
                //清除token，重新登录
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:ACCESS_TOKEN_KEY];
                
                WDLoginViewController * loginVC = [[WDLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }];
            
        }else{
            
            SHOW_ALERT(@"两次密码输入不一致，请重新输入")
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.oldPassword) {
        
        [textField resignFirstResponder];
        [self.presentPassword becomeFirstResponder];
    }
    if (textField == self.presentPassword) {
        
        [textField resignFirstResponder];
        [self.certainPassword becomeFirstResponder];
    }
    if (textField == self.certainPassword) {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}



@end
