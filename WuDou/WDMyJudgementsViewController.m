//
//  WDMyJudgementsViewController.m
//  WuDou
//
//  Created by huahua on 16/12/2.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMyJudgementsViewController.h"
#import "WDMyJudgementsCell.h"
#import "WDMyJudgementsLayout.h"
#import "WDTabbarViewController.h"
#import "WDGoodsInfoViewController.h"
#import "WDAppInitManeger.h"

@interface WDMyJudgementsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_judgeTableView;
    
    NSMutableArray *_modelDatas;
    NSInteger _page;
}
@end

static NSString *judgesId = @"WDMyJudgementsCell";
@implementation WDMyJudgementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.title = self.navTitle;
    
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
    
    _page = 1;
    [self _loadData];
    
    _judgeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _judgeTableView.delegate = self;
    _judgeTableView.dataSource = self;
    _judgeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_judgeTableView registerNib:[UINib nibWithNibName:@"WDMyJudgementsCell" bundle:nil] forCellReuseIdentifier:judgesId];
    
    [self.view addSubview:_judgeTableView];
    
    [self _getMoreDatas];
}

- (void)_loadData{
    
    if ([self.judgeState isEqualToString:@"MyJudgements"]) {  //我的评价
        
        [WDMineManager requestMyJudgementsWithCurrentPage:@"" completion:^(NSMutableArray *array, NSString *error) {
           
            if (error) {
                
                [self _createNodatasIcon];
                return ;
            }
            
            _modelDatas = array;
            [_judgeTableView reloadData];
        }];
    }
    else{  //商品详情评价
        
        [WDMineManager requestGoodsInfoMoreJudgementsWithPid:self.pid currentPage:@"" completion:^(NSMutableArray *array, NSString *error) {
           
            if (error) {
                
                [self _createNodatasIcon];
                return ;
            }
            
            _modelDatas = array;
            [_judgeTableView reloadData];
            
        }];
    }
}
/** 提示暂时数据*/
- (void)_createNodatasIcon{
    
    [_judgeTableView removeFromSuperview];
    
    UIView *noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 60)];
    noticeView.center = self.view.center;
    noticeView.centerY = self.view.centerY - 30;
    [self.view addSubview:noticeView];
    
    UIImageView *noticeImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 33)];
    noticeImage.image = [UIImage imageNamed:@"noData"];
    [noticeView addSubview:noticeImage];
    
    UILabel *noticeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 70, 20)];
    noticeText.text = @"暂无数据";
    noticeText.font = [UIFont systemFontOfSize:15.0];
    noticeText.textAlignment = NSTextAlignmentCenter;
    noticeText.textColor = [UIColor lightGrayColor];
    [noticeView addSubview:noticeText];
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
    
    if ([self.jumpState isEqualToString:@"jumpToMine"])
    {
        UIWindow * window = [[UIApplication sharedApplication].delegate window];
        WDTabbarViewController * tabbar = [[WDTabbarViewController alloc]init];
        tabbar.selectedIndex = 3;
        window.rootViewController = tabbar;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** 上拉加载更多*/
- (void)_getMoreDatas{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    footer.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    //    [header beginRefreshing];
    
    // 设置header
    _judgeTableView.mj_footer = footer;
}

- (void)loadMore{
    
    _page ++;
    NSLog(@"_page = %ld",_page);
    
    if ([self.judgeState isEqualToString:@"MyJudgements"]) {  //我的评价
        
        [WDMineManager requestMyJudgementsWithCurrentPage:[NSString stringWithFormat:@"%ld",_page] completion:^(NSMutableArray *array, NSString *error) {
            if (error) {
                [_judgeTableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            
            NSMutableArray *moreArr = array;
            [_modelDatas addObjectsFromArray:moreArr];
            
            [_judgeTableView reloadData];
            
            [_judgeTableView.mj_footer endRefreshing];
        }];
    }
    else{  //商品详情评价
        
        [WDMineManager requestGoodsInfoMoreJudgementsWithPid:self.pid currentPage:[NSString stringWithFormat:@"%ld",_page] completion:^(NSMutableArray *array, NSString *error) {
            
            if (error) {
                
                [_judgeTableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            
            NSMutableArray *moreArr = array;
            [_modelDatas addObjectsFromArray:moreArr];
            
            [_judgeTableView reloadData];
            
            [_judgeTableView.mj_footer endRefreshing];
            
        }];
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_modelDatas.count == 0) {
        
        return 0;
    }
    else{
        
        return _modelDatas.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_modelDatas.count != 0) {
        
        WDMyJudgementsCell *cell = [tableView dequeueReusableCellWithIdentifier:judgesId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WDMyJudgementsLayout *layout = _modelDatas[indexPath.row];
        cell.cellType = self.cellState;
        cell.layout = layout;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDMyJudgementsLayout *layout = _modelDatas[indexPath.row];
    
    return layout.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.judgeState isEqualToString:@"MyJudgements"]) {
        
        WDMyJudgementsLayout *layout = _modelDatas[indexPath.row];
        
        WDGoodsInfoViewController *infosVC = [[WDGoodsInfoViewController alloc]init];
        NSString *goodID = layout.judgesModel.pid;
        infosVC.goodsID = goodID;
        [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
        [self.navigationController pushViewController:infosVC animated:YES];
    }
}

@end
