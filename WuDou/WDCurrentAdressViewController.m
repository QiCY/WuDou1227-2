//
//  WDCurrentAdressViewController.m
//  WuDou
//
//  Created by huahua on 16/8/26.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDCurrentAdressViewController.h"
#import "WDCurrentAddressListCell.h"
#import "Single.h"
#import <CoreLocation/CoreLocation.h>

@interface WDCurrentAdressViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    UITableView *_mainTableView;
    NSArray *_subArray1;
    NSMutableArray *_subArray2;
    
    NSInteger _page;
}

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)CLLocationManager *manager;

@end

//NSString *reuseID = @"WDCurrentAddressListCell";
@implementation WDCurrentAdressViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 开启定位
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    
    // 设置定位精度   kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // 设置过滤器为无
    self.manager.distanceFilter = kCLDistanceFilterNone;
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8))
    {
        // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
        [self.manager requestAlwaysAuthorization];//这句话ios8以上版本使用。
    }
    
    // 开始定位
    [self.manager startUpdatingLocation];
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.title = @"当前地址列表";
    _page = 1;
    
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
    
    [self _loadDatas];
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    [self.view addSubview:_mainTableView];
    
    [self _setFooterRefresh];
}

- (void)_loadDatas{
    
    [WDMineManager requestNearRegionWithCurrentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            
            SHOW_ALERT(error)
            return ;
        }
        
        if (array.count != 0) {
            
            self.dataArray = array;
            _subArray1 = [self.dataArray subarrayWithRange:NSMakeRange(0, 1)];
            NSArray *subArr = [self.dataArray subarrayWithRange:NSMakeRange(1, self.dataArray.count - 1)];
            _subArray2 = [NSMutableArray arrayWithArray:subArr];
            
            [_mainTableView reloadData];
            
        }
    }];
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
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [WDMineManager requestNearRegionWithCurrentPage:[NSString stringWithFormat:@"%ld",(long)_page] completion:^(NSMutableArray *array, NSString *error){
        
        if (error) {
            SHOW_ALERT(error)
            return ;
        }
        
        if (array.count == 0) {
            
            //  提示没有更多的数据
            [_mainTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [_subArray2 addObjectsFromArray:array];
        
        [_mainTableView reloadData];
        [_mainTableView.mj_footer endRefreshing];
        
    }];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    NSString *locationInfo = [NSString stringWithFormat:@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    
    // 更新用户令牌位置信息
    [WDAppInitManeger requestUserLocationMsgWithCoordinate:locationInfo completion:^(WDAppInit *appInit, NSString *error) {
        
        if (error) {
            
            SHOW_ALERT(error)
            return ;
        }
        
    }];
    
    // 停止位置更新
    [manager stopUpdatingLocation];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return _subArray1.count;
        
    }if (section == 1) {
        
        if (self.dataArray.count > 0) {
            
            return _subArray2.count;
        }
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        
        WDCurrentAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell == nil) {
            
            cell = [[WDCurrentAddressListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        
        WDNearLocationModel *model = _subArray1[0];
        cell.currentAddress = model.name;
        cell.detailsAddress = model.addressinfo;
        
        return cell;
    }
    else{
        
        WDCurrentAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell == nil) {
            
            cell = [[WDCurrentAddressListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        
        WDNearLocationModel *model = _subArray2[indexPath.row];
        cell.recommendLabel.hidden = YES;
        cell.currentAddress = model.name;
        cell.detailsAddress = model.addressinfo;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDCurrentAddressListCell *cell = (WDCurrentAddressListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    Single *single = [Single shareSingle];
    single.str = cell.currentAddress;
    single.detailStr = cell.detailsAddress;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
