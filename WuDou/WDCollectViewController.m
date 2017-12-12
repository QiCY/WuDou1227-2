
//
//  WDCollectViewController.m
//  WuDou
//
//  Created by huahua on 16/9/23.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDCollectViewController.h"
#import "WDUnusedTableViewController.h"
#import "WDDidusedTableViewController.h"
#import "WDExpiredTableViewController.h"
#import "WDWebViewController.h"

@interface WDCollectViewController ()<UIScrollViewDelegate>
{
    UIView *_greenIndicator;
}
/** 使用状态View*/
@property (strong, nonatomic)UIView *usedView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 底部滑动视图*/
@property (strong, nonatomic)UIScrollView *bottomScrollView;

@end

@implementation WDCollectViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的优惠券";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setupNavigation];
    
    [self _setUI];
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 15, 20);
    [btn setImageEdgeInsets:UIEdgeInsetsMake(4, 3, 4,3)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
    
    //  右侧使用规则按钮
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
    [rightBtn setTitle:@"使用规则" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(useRegular) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)useRegular{
    
    WDWebViewController *webVC = [[WDWebViewController alloc] init];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/coupons.html?access_token=%@",HTML5_URL,token];
    webVC.urlString = urlStr;
    webVC.navTitle = @"使用规则";
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**  创建UI界面*/
- (void)_setUI{
    
    // 初始化子控制器
    [self _setupChildVCs];
    
    // 创建三个按钮
    [self _createButtonView];
    
    // 创建底部的滑动视图
    [self _createBottomScrollView];
}

/** 初始化子控制器*/
- (void)_setupChildVCs
{
    WDUnusedTableViewController *unusedTVC = [[WDUnusedTableViewController alloc] init];
    [self addChildViewController:unusedTVC];
    
    WDDidusedTableViewController *didusedTVC = [[WDDidusedTableViewController alloc] init];
    [self addChildViewController:didusedTVC];
    
    WDExpiredTableViewController *expiredTVC = [[WDExpiredTableViewController alloc] init];
    [self addChildViewController:expiredTVC];
    
}

/** 创建三个按钮*/
- (void)_createButtonView{
    
    _usedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _usedView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_usedView];
    
    //  创建绿色指示器
    _greenIndicator = [[UIView alloc] init];
    _greenIndicator.backgroundColor = KSYSTEM_COLOR;
    _greenIndicator.height = 2;
    _greenIndicator.tag = -1;
    _greenIndicator.y = _usedView.height - _greenIndicator.height;
    
    // 内部的子标签
    NSArray *titles = @[ @"未使用",@"已使用", @"已过期"];
    CGFloat width = _usedView.width / titles.count;
    CGFloat height = _usedView.height;
    for (NSInteger i = 0; i<titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * width;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        //        [button layoutIfNeeded]; // 强制布局(强制更新子控件的frame)
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:KSYSTEM_COLOR forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_usedView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            _greenIndicator.width = button.titleLabel.width;
            _greenIndicator.centerX = button.centerX;
        }
    }
    
    [_usedView addSubview:_greenIndicator];
}

//  按钮的点击方法
- (void)buttonClick:(UIButton *)button {
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    //  让绿色指示器动态地与按钮贴合
    [UIView animateWithDuration:0.25 animations:^{
        _greenIndicator.width = button.titleLabel.width;
        _greenIndicator.centerX = button.centerX;
    }];
    
    // 滚动
    CGPoint offset = self.bottomScrollView.contentOffset;
    offset.x = button.tag * self.bottomScrollView.width;
    [self.bottomScrollView setContentOffset:offset animated:YES];
    
}

/** 创建底部的滑动视图*/
- (void)_createBottomScrollView{
    
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 内容尺寸
    _bottomScrollView = [[UIScrollView alloc] init];
    _bottomScrollView.frame = CGRectMake(0, CGRectGetMaxY(_usedView.frame)+1, kScreenWidth, kScreenHeight - CGRectGetMaxY(_usedView.frame)-10-49);
    _bottomScrollView.delegate = self;
    _bottomScrollView.pagingEnabled = YES;
    _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.width * self.childViewControllers.count, 0);
    [self.view insertSubview:_bottomScrollView atIndex:0];
    
    
//    NSLog(@"_bottomScrollView.frame = %@",NSStringFromCGRect(_bottomScrollView.frame));
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:_bottomScrollView];
    
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self buttonClick:self.usedView.subviews[index]];
}


@end
