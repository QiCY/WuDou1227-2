//
//  WDNavigationController.m
//  WuDou
//
//  Created by huahua on 16/7/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDNavigationController.h"
#import "WDTabbarViewController.h"
#import "UIImage+Image.h"

@interface WDNavigationController ()

@end

@implementation WDNavigationController

+ (void)load
{
    UIBarButtonItem *item=[UIBarButtonItem appearanceWhenContainedIn:self, nil ];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    dic[NSForegroundColorAttributeName]=[UIColor blackColor];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    [bar setBackgroundImage:[UIImage imageWithColor:KSYSTEM_COLOR] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dicBar=[NSMutableDictionary dictionary];
    
    dicBar[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    [bar setTitleTextAttributes:dic];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
//    dic[NSFontAttributeName]=[UIFont systemFontOfSize:15];
//    dic[NSForegroundColorAttributeName]=[UIColor blackColor];
//    
//    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:] forBarMetrics:UIBarMetricsDefault];
//    NSMutableDictionary *dicBar=[NSMutableDictionary dictionary];
//    
//    dicBar[NSFontAttributeName]=[UIFont systemFontOfSize:15];
//    [self.navigationBar setTitleTextAttributes:dic];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    return [super pushViewController:viewController animated:animated];
}


@end
