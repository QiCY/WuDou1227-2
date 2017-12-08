//
//  WDTabbarViewController.m
//  WuDou
//
//  Created by huahua on 16/7/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDTabbarViewController.h"
#import "WDNavigationController.h"

#import "WDMainViewController.h"
#import "WDSpeakViewController.h"
#import "WDShoppingCarViewController.h"
#import "WDMineViewController.h"
#import "WDNearViewController.h"

#import "LBTabBar.h"
#import "UIImage+Image.h"

@interface WDTabbarViewController ()<LBTabBarDelegate>

@end

@implementation WDTabbarViewController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = KSYSTEM_COLOR;
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllChildVc];
    
    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    LBTabBar *tabbar = [[LBTabBar alloc] init];
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    
}


#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc
{
    WDMainViewController * FishVC = [[WDMainViewController alloc] init];
    [self setUpOneChildVcWithVc:FishVC Image:@"main-unselected" selectedImage:@"main-selected" title:@"首页"];
    
    WDSpeakViewController * SpeakVC = [[WDSpeakViewController alloc] init];
    [self setUpOneChildVcWithVc:SpeakVC Image:@"cate-unselected" selectedImage:@"cate-selected" title:@"分类"];
    
    WDShoppingCarViewController * ShoppingCarVC = [[WDShoppingCarViewController alloc] init];
    [self setUpOneChildVcWithVc:ShoppingCarVC Image:@"car-unselected" selectedImage:@"car-selected" title:@"购物车"];
    
    WDMineViewController * MineVC = [[WDMineViewController alloc] init];
    [self setUpOneChildVcWithVc:MineVC Image:@"mine-unselected" selectedImage:@"mine-selected" title:@"我的"];
}
#pragma mark - 初始化设置tabBar上面单个按钮的方法
/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    WDNavigationController *nav = [[WDNavigationController alloc] initWithRootViewController:Vc];
    

    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    Vc.tabBarItem.selectedImage = mySelectedImage;
    
  Vc.tabBarItem =  [[UITabBarItem alloc] initWithTitle:nil image:myImage selectedImage:[mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    Vc.tabBarItem.title = title;
//    CGFloat witdh = kScreenWidth/5;
//    Vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, (witdh - 40)/2, 5, (witdh - 40)/2);
//    Vc.tabBarItem.imageInsets=UIEdgeInsetsMake(7, 0, -4, 0);
    //tabBar图片居中显示，显示文字的坐标
    CGFloat offset = 5.0;
    //tabBar图片居中显示，不显示文字
    Vc.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
    Vc.navigationItem.title = title;
    //  设置导航栏标题颜色
    [Vc.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self addChildViewController:nav];
    
}



#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar
{
    
    WDNearViewController *plusVC = [[WDNearViewController alloc] init];
    plusVC.navTitle = @"商家";
    plusVC.leftCode = @"";
    WDNavigationController * navVc = [[WDNavigationController alloc] initWithRootViewController:plusVC];
    
    [self presentViewController:navVc animated:YES completion:nil];
    
}


- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
}

@end
