//
//  WDRegisterViewController.m
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDRegisterViewController.h"
#import "WDLoginViewController.h"
#import "WDWebViewController.h"
#import "WDTabbarViewController.h"

@interface WDRegisterViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    NSTimer * _timer;
    int _time;
    //是否显示密码
    BOOL _isShowPass;
}

@end

@implementation WDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"免费注册";
    _time = 60;
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
    
    self.phoneNumber.delegate = self;
    self.password.delegate = self;
    self.messageCodes.delegate = self;
}


//  自定义导航栏返回按钮
- (void)_setupNavigation
{
    [self.navigationItem setHidesBackButton:YES];
    
    //  左侧返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
    [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12,45)];
   
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
    
}

/* 返回上一级 **/
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCodesClick:(UIButton *)sender
{
    BOOL isPhone = [WDAppInitManeger validateNumber:self.phoneNumber.text];
    if ([self.phoneNumber.text isEqualToString:@""])
    {
        SHOW_ALERT(@"手机号不能为空！");
    }
    else if (isPhone == NO)
    {
        SHOW_ALERT(@"请填入正确的手机号！");
    }
    else if ([self.password.text isEqualToString:@""])
    {
        SHOW_ALERT(@"密码不能为空！");
    }
    else
    {
        [WDAppInitManeger requestRegistVerificationCodeWithMobile:self.phoneNumber.text completion:^(NSString *codeModel, NSString *error) {
           
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

- (IBAction)successRegisterClick:(UIButton *)sender
{
    [WDAppInitManeger requestRegistWithMobile:self.phoneNumber.text passWord:self.password.text verificationCode:self.messageCodes.text completion:^(WDAppInit *appInit, NSString *error) {
       
        if (error)
        {
            SHOW_ALERT(error);
            return ;
        }
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功！是否直接登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
//        [self.navigationController popViewControllerAnimated:YES];
        
        [WDAppInitManeger requestUserMsgWithUserName:self.phoneNumber.text passWord:self.password.text completion:^(WDAppInit *appInit, NSString *error) {
            
            if (error)
            {
                SHOW_ALERT(error);
                return ;
            }
            
            WDTabbarViewController *tabbar = [[WDTabbarViewController alloc]init];
            tabbar.selectedIndex = 0;
            UIWindow * window = [[UIApplication sharedApplication].delegate window];
            window.rootViewController = tabbar;
            
        }];
    }
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)showPasswordClick:(UIButton *)sender
{
    _isShowPass =! _isShowPass;
    if (_isShowPass)
    {
        self.showPassImage.image = [UIImage imageNamed:@"睁眼"];
        self.password.secureTextEntry = NO;
    }
    else
    {
        self.showPassImage.image = [UIImage imageNamed:@"闭眼"];
        self.password.secureTextEntry = YES;
    }
}

/** 《物兜注册协议》*/
- (IBAction)WDRegiestProtocol:(UIButton *)sender {
    
    WDWebViewController *webView = [[WDWebViewController alloc] init];
    webView.navTitle = @"《天天蔬心注册协议》";
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/agreement.html?access_token=%@",HTML5_URL,token];
    webView.urlString = urlStr;
    
    [self.navigationController pushViewController:webView animated:YES];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.phoneNumber) {
        
        [textField resignFirstResponder];
        [self.password becomeFirstResponder];
    }
    if (textField == self.password) {
        
        [textField resignFirstResponder];
        [self.messageCodes becomeFirstResponder];
    }
    if (textField == self.messageCodes) {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
