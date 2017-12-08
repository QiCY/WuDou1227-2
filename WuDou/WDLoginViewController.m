//
//  WDLoginViewController.m
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDLoginViewController.h"
#import "WDRegisterViewController.h"
#import "WDForgetPasswordViewController.h"
#import "WDTabbarViewController.h"
#import "WDMineViewController.h"
#import "JPUSHService.h"

@interface WDLoginViewController ()<UITextFieldDelegate>

@end

@implementation WDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"登录";
    
    self.userName.delegate = self;
    self.passWord.delegate = self;
    self.login.backgroundColor = KSYSTEM_COLOR;
    [self.forgetPassword setTitleColor:KSYSTEM_COLOR forState:UIControlStateNormal];
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    //  左侧返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 15, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
    
    //  右侧注册按钮
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 30, 18);
    [right setTitle:@"注册" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [right addTarget:self action:@selector(registerNumber) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBtn;

}

/* 返回上一级 **/
- (void)goBackAction{
    
    WDTabbarViewController *tabbar = [[WDTabbarViewController alloc]init];
    tabbar.selectedIndex = 0;
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    window.rootViewController = tabbar;
}

/* 注册账号 **/
- (void)registerNumber{
    
    WDRegisterViewController *registerVC = [[WDRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

/* 忘记密码 **/
- (IBAction)forgetPassword:(UIButton *)sender {
    
    WDForgetPasswordViewController *forgetPasswordVC = [[WDForgetPasswordViewController alloc] init];
    
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
}

/* 登录按钮 **/
- (IBAction)log_in:(id)sender
{
    [WDAppInitManeger requestUserMsgWithUserName:self.userName.text passWord:self.passWord.text completion:^(WDAppInit *appInit, NSString *error)
     {

         if (error)
         {
             SHOW_ALERT(error);
             return ;
         }
         self.appInit = appInit;
         
         NSString * minUserName = [self.appInit.push_alias lowercaseString];
         [JPUSHService setAlias:minUserName callbackSelector:@selector(getPush) object:nil];
         
         if ([self.popType isEqualToString:@"返回我的地址界面"]) {
             
             [self.navigationController popViewControllerAnimated:YES];
         }else{
             
             WDTabbarViewController *tabbar = [[WDTabbarViewController alloc]init];
             tabbar.selectedIndex = 0;
             UIWindow * window = [[UIApplication sharedApplication].delegate window];
             window.rootViewController = tabbar;
         }
         
     }];

}

-(void)getPush
{
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.userName) {
        
        [textField resignFirstResponder];
        [self.passWord becomeFirstResponder];
    }
    if (textField == self.passWord) {
        
        [textField resignFirstResponder];
    }

    return YES;
}

@end
