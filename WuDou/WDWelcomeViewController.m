//
//  WDWelcomeViewController.m
//  WuDou
//
//  Created by huahua on 16/7/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDWelcomeViewController.h"
#import "WDTabbarViewController.h"
#import "WDLoginViewController.h"

@interface WDWelcomeViewController ()<UIScrollViewDelegate>
{
    UIPageControl *_pages;
}
@end

@implementation WDWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight); // frame中的size指UIScrollView的可视范围
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeight);
    [self.view addSubview:scrollView];

    // 2.创建UIImageView（图片）
    for (int i=0; i<3; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
        imageView.frame = CGRectMake(kScreenWidth *i, 0, kScreenWidth, kScreenHeight);
        [scrollView addSubview:imageView];
    }
    
    UIButton *button = [[UIButton alloc]init];
    [button addTarget:self action:@selector(goTabbar) forControlEvents:UIControlEventTouchUpInside];
//    if (kScreenWidth < 350)
//    {
//        button.frame = CGRectMake(107 + 2*kScreenWidth, 457, 110, 37);
//    }
//     if (kScreenWidth > 350 && kScreenWidth < 400)
//    {
//        button.frame = CGRectMake(126+ 2*kScreenWidth, 538, 133, 44);
//    }
//    if (kScreenWidth > 400)
//    {
//        button.frame = CGRectMake(141+ 2*kScreenWidth, 595, 138, 49);
//    }
    button.frame = CGRectMake(2*kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [scrollView addSubview:button];
    
    // 隐藏水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;

    // 用来记录scrollview滚动的位置
    //    scrollView.contentOffset = ;
    scrollView.pagingEnabled = YES;
    // 去掉弹簧效果
    scrollView.bounces = NO;
    
    // 创建pageControl
//    _pages = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth-40)*0.5, kScreenHeight-80, 40, 20)];
//    _pages.layer.cornerRadius = 10;
//    _pages.backgroundColor = kViewControllerBackgroundColor;
//    _pages.numberOfPages = 3;
//    _pages.pageIndicatorTintColor = [UIColor whiteColor];
//    _pages.currentPageIndicatorTintColor = ;
//    [self.view addSubview:_pages];
    
}

-(void)goTabbar
{
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    WDTabbarViewController * tabbar = [[WDTabbarViewController alloc]init];
    window.rootViewController = tabbar;
    
    
//    WDLoginViewController *loginVC = [[WDLoginViewController alloc]init];
//    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    _pages.currentPage = scrollView.contentOffset.x / kScreenWidth;
//}

@end
