//
//  AppDelegate.h
//  WuDou
//
//  Created by huahua on 16/7/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"
#import "WDAppInitManeger.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong)dispatch_source_t time;
@end

