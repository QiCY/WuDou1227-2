//
//  WDEditAdressViewController.h
//  WuDou
//
//  Created by huahua on 16/8/26.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"

@interface WDEditAdressViewController : UIViewController
/** 收货地址*/
@property (weak, nonatomic) IBOutlet UITextField *myAddress;
/** 具体收货地址*/
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;
/** 收货姓名*/
@property (weak, nonatomic) IBOutlet UITextField *consigneeName;
/** 收货电话*/
@property (weak, nonatomic) IBOutlet UITextField *consigneeNum;
/** 设置默认地址*/
@property (weak, nonatomic) IBOutlet UIButton *setNormalBtn;
/** 保存*/
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

/** 添加或者编辑地址的状态变量*/
@property(nonatomic, copy)NSString *uploadType;

/** 是否设置默认地址*/
@property(nonatomic, copy)NSString *isNormal;
/** 配送地址ID*/
@property(nonatomic, copy)NSString *said;

@property(nonatomic, strong)WDLoadAddressModel *model;



@end
