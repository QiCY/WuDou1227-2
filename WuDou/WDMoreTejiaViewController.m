//
//  WDMoreTejiaViewController.m
//  WuDou
//
//  Created by huahua on 16/10/26.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMoreTejiaViewController.h"
#import "WDMoreTejiaCell.h"
#import "WDGoodsInfoViewController.h"

@interface WDMoreTejiaViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_mainTableView;
    
    NSInteger _page;
    NSMutableArray *_dataArray;
}
@end

static NSString *reuseId = @"WDMoreTejiaCell";
@implementation WDMoreTejiaViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupNavigationBar];
    
    self.title = @"本周特价";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    _page = 1;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [self _loadDatas];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = [UIColor clearColor];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"WDMoreTejiaCell" bundle:nil] forCellReuseIdentifier:reuseId];
    
    [self.view addSubview:_mainTableView];
    
    [self _setFooterRefresh];
}

//  自定义导航栏返回按钮
- (void)_setupNavigationBar{
    
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

/** 请求数据*/
- (void)_loadDatas{

    [WDMainRequestManager requestMoreTejiaWithCurrentPage:@"1" completion:^(NSMutableArray *dataArray, NSString *error) {
       
        if (error) {
            
            [self _createNodatasIcon];
            [SVProgressHUD dismiss];
            return ;
        }
        
        _dataArray = dataArray;
        [_mainTableView reloadData];
        
        [SVProgressHUD dismiss];
    }];
    
}

/** 提示暂时数据*/
- (void)_createNodatasIcon{
    
    [_mainTableView removeFromSuperview];
    
    UIView *noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
    noticeView.center = self.view.center;
    noticeView.centerY = self.view.center.y-30;
    [self.view addSubview:noticeView];
    
    UIImageView *noticeImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-30)*0.5, 0, 30, 33)];
    noticeImage.image = [UIImage imageNamed:@"noData"];
    [noticeView addSubview:noticeImage];
    
    UILabel *noticeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 20)];
    noticeText.text = @"暂无数据";
    noticeText.font = [UIFont systemFontOfSize:15.0];
    noticeText.textAlignment = NSTextAlignmentCenter;
    noticeText.textColor = [UIColor lightGrayColor];
    [noticeView addSubview:noticeText];
}

/** 下拉加载*/
- (void)_setFooterRefresh{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    footer.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    //    [header beginRefreshing];
    
    // 设置header
    _mainTableView.mj_footer = footer;
}
- (void)loadMoreData{
    
    _page ++;
    
    [WDMainRequestManager requestMoreTejiaWithCurrentPage:[NSString stringWithFormat:@"%ld",_page] completion:^(NSMutableArray *dataArray, NSString *error) {
        
        if (error) {
            [_mainTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        if (dataArray.count == 0) {
            
            //  提示没有更多的数据
            [_mainTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [_dataArray addObjectsFromArray:dataArray];
        
        [_mainTableView reloadData];
        [_mainTableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_dataArray.count > 0) {
        
        return _dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_dataArray.count > 0) {
        
        WDMoreTejiaCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
        
        WDGoodChoiceModel *model = _dataArray[indexPath.row];
        [cell.tejiaImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        cell.tejiaTitle.text = model.name;
        cell.tejiaPrice.text = [NSString stringWithFormat:@"￥%@",model.shopprice];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_dataArray.count > 0) {
        
        return 80;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDGoodChoiceModel *model = _dataArray[indexPath.row];
    NSString * goodID = model.pid;
    [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
    WDGoodsInfoViewController *goodsInfoVC = [[WDGoodsInfoViewController alloc]init];
    goodsInfoVC.goodsImage = model.img;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}


@end
