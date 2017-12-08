//
//  WDEditAdressViewController.m
//  WuDou
//
//  Created by huahua on 16/8/26.
//  Copyright © 2016年 os1. All rights reserved.
//  我的 -- 我的收货地址 -- 编辑地址

#import "WDEditAdressViewController.h"
#import "WDCurrentAdressViewController.h"
#import "Single.h"
#import "WDAddressTableVController.h"

@interface WDEditAdressViewController ()<UITextFieldDelegate>

@end

@implementation WDEditAdressViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
    if (self.myAddress.text != nil) {
        
        Single *single = [Single shareSingle];
        if (single.str != nil) {
            
            self.myAddress.text = single.str;
            self.detailAddress.text = single.detailStr;
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.title = @"编辑收货地址";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
    
    self.isNormal = @"0";
    
    self.myAddress.delegate = self;
    self.detailAddress.delegate = self;
    self.consigneeName.delegate = self;
    self.consigneeNum.delegate = self;
    
    if (self.model != nil)
    {
        self.myAddress.text = self.model.address;
        self.consigneeName.text = self.model.consignee;
        self.consigneeNum.text = self.model.mobile;
        self.detailAddress.text = self.model.addressmark;
    }
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

/** 定位按钮*/
- (IBAction)locationAction:(UIButton *)sender {
    
    WDCurrentAdressViewController *currentVC = [[WDCurrentAdressViewController alloc]init];
    [self.navigationController pushViewController:currentVC animated:YES];

}

/** 保存修改*/
- (IBAction)saveEdit:(UIButton *)sender {
    if ([self.uploadType isEqualToString:@"添加新地址"]) {
        if ([self.myAddress.text isEqualToString:@""] || [self.consigneeName.text isEqualToString:@""] || [self.consigneeNum.text isEqualToString:@""]) {
            
            SHOW_ALERT(@"请将信息填写完整!")
        }else{
            
            if ([self isPureInt:self.consigneeNum.text]) {
                
                NSLog(@"添加 -- %@",self.isNormal);
                [WDMineManager requestAddAddressWithIsdefault:self.isNormal consignee:self.consigneeName.text mobile:self.consigneeNum.text address:self.myAddress.text addressMark:self.detailAddress.text completion:^(NSString *result, NSString *error) {
                    
                    if (error) {
                        
                        SHOW_ALERT(error)
                    }
                    
                    //        SHOW_ALERT(result)
                }];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                SHOW_ALERT(@"收货电话应为纯数字，请重新输入!")
            }
        }
        
    }
    
    if ([self.uploadType isEqualToString:@"编辑地址"]) {
        
        if ([self.myAddress.text isEqualToString:@""] || [self.consigneeName.text isEqualToString:@""] || [self.consigneeNum.text isEqualToString:@""]) {
            
            SHOW_ALERT(@"请将信息填写完整!")
        }else{
            
            if ([self isPureInt:self.consigneeNum.text]) {
                
                NSLog(@"编辑 -- %@",self.isNormal);
                [WDMineManager requestEditAddressWithSaid:self.said isdefault:self.isNormal consignee:self.consigneeName.text mobile:self.consigneeNum.text address:self.myAddress.text addressMark:self.detailAddress.text completion:^(NSString *result, NSString *error) {
                    
                    if (error) {
                        
                        SHOW_ALERT(error)
                    }
                    
                }];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
                SHOW_ALERT(@"收货电话应为纯数字，请重新输入!")
            }
        }
    }
}

/** 判断输入的为纯数字*/
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/** 是否设置为默认地址*/
- (IBAction)setNormalAddressEnabled:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        self.isNormal = @"1";
    }else if(!sender.selected){
        
        self.isNormal = @"0";
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];

    if (self.myAddress.text != nil) {
        
        Single *single = [Single shareSingle];
        if (single.str != nil) {
            
            single.str = nil;
            single.detailStr = nil;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
