//
//  WDSecondGoodsTableVController.m
//  WuDou
//
//  Created by huahua on 16/8/24.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDSecondGoodsTableVController.h"
#import "WDTabbarViewController.h"
#import "WDSecondPublishViewController.h"
#import "WDSecondGoodsCell.h"
#import "WDMySecondMagViewController.h"

@interface WDSecondGoodsTableVController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSInteger _page;
}
@property(nonatomic,strong)UITableView *tableView;

@end

static NSString *reuseid = @"WDSecondGoodsCell";
@implementation WDSecondGoodsTableVController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self _loadModelData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _dataArray = [NSMutableArray array];
    
    self.title = self.navTitle;
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setupNavigation];
    
    _page = 1;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WDSecondGoodsCell" bundle:nil] forCellReuseIdentifier:reuseid];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteButtonClick:) name:@"BUTTONCLICK" object:nil];
    
    [self _getMoreDatas];
}

/** 加载模型数据*/
- (void)_loadModelData{
    
    [WDMineManager requestLoadMySecondGoodsWithCurrentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
       
        if (error) {
            
            [self _createNodatasIconWithMsg:error];
            return ;
        }
        
        _dataArray = array;
        [self.tableView reloadData];
    }];
}

/** 提示暂时数据*/
- (void)_createNodatasIconWithMsg:(NSString *)string{
    
    [self.tableView removeFromSuperview];
    
    UIView *noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    noticeView.centerY = self.view.center.y;
    [self.view addSubview:noticeView];
    
    UIImageView *noticeImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-30)*0.5, 0, 30, 33)];
    noticeImage.image = [UIImage imageNamed:@"noData"];
    [noticeView addSubview:noticeImage];
    
    UILabel *noticeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 20)];
    noticeText.text = string;
    noticeText.font = [UIFont systemFontOfSize:15.0];
    noticeText.textAlignment = NSTextAlignmentCenter;
    noticeText.textColor = [UIColor lightGrayColor];
    [noticeView addSubview:noticeText];
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
    self.tableView.mj_footer = footer;
}

- (void)loadMore{
    
    _page ++;
    NSLog(@"_page = %ld",_page);
    
    [WDMineManager requestLoadMySecondGoodsWithCurrentPage:[NSString stringWithFormat:@"%ld",_page] completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            
            return ;
        }
        
        NSMutableArray *moreArr = array;
        [_dataArray addObjectsFromArray:moreArr];
    
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
     [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12,45)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
    
    //  右侧发布信息按钮
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
    [rightBtn setTitle:@"发布信息" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(publishNews:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)goBackAction{
    
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    WDTabbarViewController * tabbar = [[WDTabbarViewController alloc]init];
    tabbar.selectedIndex = 3;
    window.rootViewController = tabbar;
}

- (void)publishNews:(UIButton *)btn{
    
    NSLog(@"前往 发布信息");
    WDSecondPublishViewController *publishMsgVC = [[WDSecondPublishViewController alloc]init];
    [self.navigationController pushViewController:publishMsgVC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDSecondGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid forIndexPath:indexPath];
    WDSearchInfosModel *model = _dataArray[indexPath.row];
    
    [cell.secondGoodsImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    cell.goodsTitle.text = model.name;
    cell.goodsLocation.text = model.region;
    cell.publishTime.text = [NSString stringWithFormat:@"发布于：%@",model.time];
    cell.goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.shopprice];
    cell.isCheck = model.reviewedsate;
    
//    cell.index = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDMySecondMagViewController *serviceDetailVC = [[WDMySecondMagViewController alloc]initWithTitle:@"商品详情" showPriceLabelEnabled:1];
    
    WDSearchInfosModel *model = _dataArray[indexPath.row];
    serviceDetailVC.pid = model.pid;
    
    [self.navigationController pushViewController:serviceDetailVC animated:YES];
}

//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:self.tableView]) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}

//设置是否显示一个可编辑视图的视图控制器。
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

//请求数据源提交的插入或删除指定行接收者。
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[_dataArray count]) {
            
            WDSearchInfosModel *model = _dataArray[indexPath.row];
            [WDMineManager requestDeleteMySecondGoodsWithPid:model.pid completion:^(NSString *result, NSString *error) {
                
                if (error) {
                    
                    SHOW_ALERT(error)
                }
                else{
                    
                    [_dataArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
                    [self.tableView reloadData];
                }
            }];
            
            
        }
    }
}


@end
