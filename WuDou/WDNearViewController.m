//
//  WDNearViewController.m
//  WuDou
//
//  Created by huahua on 16/7/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDNearViewController.h"
#import "WDNearStoreCell.h"
#import "WDNearDetailsViewController.h"
#import "WDStoreDetailViewController.h"

#define kSEGMENTKEY @"segmentKey"
#define kLEFTCATEGORYKEY @"leftKey"
#define kRIGHTCATEGORYKEY @"rightKey"

@interface WDNearViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_allModelsArray;
    NSMutableArray *_segmentCodeArr;
    NSMutableArray *_segmentArray;
    NSMutableArray *_leftArray;
    NSMutableArray *_leftNameArray;
    NSMutableArray *_leftCodeArray;
    NSMutableArray *_rightArray;
    NSMutableArray *_rightNameArray;
    NSMutableArray *_rightCodeArray;
    
    UIControl *_leftControl;
    UIControl *_rightControl;  // 覆盖在左右两个OrderListView上的UIControl
    UITableView *_leftTV;
    UITableView *_rightTV;  //  左右两个下拉列表
    BOOL _leftSelect;
    BOOL _rightSelect;
    NSInteger _page;
}
@end

@implementation WDNearViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    if (_leftSelect) {
        [_leftTV removeFromSuperview];
    }
    if (_rightSelect) {
        [_rightTV removeFromSuperview];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.tabBarController.tabBar.hidden = NO;
    
    
    self.title = _navTitle;
  
    self.segmented.tintColor = KSYSTEM_COLOR;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WDNearStoreCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _page = 1;
    
    [self _setupNavigation];
    
    [self _setupData];
    
    [self _setLeftAndRightOrderList];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [self.segmented addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    //  设置默认值
    // 保存左边分类的状态
    [[NSUserDefaults standardUserDefaults] setObject:self.leftCode forKey:kLEFTCATEGORYKEY];
    if (![_navTitle isEqualToString:@"商家"]) {
        
        _lefBtn.orderListTitle = _navTitle;
        
    }else{
        
        _lefBtn.orderListTitle = @"全部分类";
    }
    [_lefBtn setNeedsLayout];
    _lefBtn.orderListImageName = @"下拉三角";
    
    _rightBtn.orderListTitle = @"智能排序";
    [_rightBtn setNeedsLayout];
    _rightBtn.orderListImageName = @"下拉三角";
    
    [self _requestData];
    
    [self _getMoreDatas];
}

#pragma mark - segment点击方法
- (void)segmentAction:(UISegmentedControl *)segment{
    
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD show];
            
            NSString *code = _segmentCodeArr[0];
            // 保存当前的状态
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:kSEGMENTKEY];
            
            NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kLEFTCATEGORYKEY];
            NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:kRIGHTCATEGORYKEY];
            [WDNearStoreManager requestNearStoreWithStoreclasses:str1 storeorder:str2 storesate:code currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
               
                [SVProgressHUD dismiss];
                
                _page = 1;
                self.nearStoreArr = array[3];
                [self.tableView reloadData];
            }];
        }
            break;
        case 1:
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD show];
            
            NSString *code = _segmentCodeArr[1];
            // 保存当前的状态
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:kSEGMENTKEY];
            NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kLEFTCATEGORYKEY];
            NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:kRIGHTCATEGORYKEY];
            [WDNearStoreManager requestNearStoreWithStoreclasses:str1 storeorder:str2 storesate:code currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
                
                [SVProgressHUD dismiss];
                
                _page = 1;
                self.nearStoreArr = array[3];
                [self.tableView reloadData];
            }];
            
        }
            break;
            
        default:
            break;
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
    self.tableView.mj_footer = footer;
}

- (void)loadMore{
    
    _page ++;
    NSLog(@"_page = %ld",_page);
    
    NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kSEGMENTKEY];
    NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:kLEFTCATEGORYKEY];
    NSString *str3 = [[NSUserDefaults standardUserDefaults] objectForKey:kRIGHTCATEGORYKEY];
    
    [WDNearStoreManager requestNearStoreWithStoreclasses:str2 storeorder:str3 storesate:str1 currentPage:[NSString stringWithFormat:@"%ld",_page] completion:^(NSMutableArray *array, NSString *error) {
       
        
        NSMutableArray *moreArr = array;
        NSMutableArray *moreTableViewArr = moreArr[3];
        
        if (moreTableViewArr.count == 0) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [self.nearStoreArr addObjectsFromArray:moreTableViewArr];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
    }];
}



/** 请求数据*/
- (void)_requestData{
    
    //  第一次请求，参数为空表示默认值
    
    __block NSString *left = [[NSUserDefaults standardUserDefaults] objectForKey:kLEFTCATEGORYKEY];
    
    [WDNearStoreManager requestNearStoreWithStoreclasses:left storeorder:@"" storesate:@"" currentPage:[NSString stringWithFormat:@"%d",_page] completion:^(NSMutableArray *array, NSString *error) {
       
        if (error) {
            
            SHOW_ALERT(error)
            return ;
        }
        
        _allModelsArray = array;
        
        //  1、segment视图数据
        _segmentArray = _allModelsArray[0];
        NSMutableArray *modelArr = [NSMutableArray array];
        for (WDCategoryModel *model in _segmentArray) {
            
            NSString *name = model.name;
            [modelArr addObject:name];
        }
        _segmentCodeArr = [NSMutableArray array];
        for ( WDCategoryModel *model in _segmentArray) {
            
            NSString *code = model.code;
            [_segmentCodeArr addObject:code];
        }
        
        for (int i = 0; i < modelArr.count; i ++) {
            
            [self.segmented setTitle:modelArr[i] forSegmentAtIndex:i];
        }
        
        //  存储默认值
        NSString *defaultSugmentValue = _segmentCodeArr[0];
        [[NSUserDefaults standardUserDefaults] setObject:defaultSugmentValue forKey:kSEGMENTKEY];
        
        // 2、左边分类
        _leftArray = _allModelsArray[1];
        _leftNameArray = [NSMutableArray array];
        _leftCodeArray = [NSMutableArray array];
        for (WDCategoryModel *model in _leftArray) {
            
            NSString *code = model.code;
            [_leftCodeArray addObject:code];
        }
        for (WDCategoryModel *model in _leftArray) {
            
            NSString *name = model.name;
            [_leftNameArray addObject:name];
        }
        
        if (left == nil) {
            
            //  存储默认值
            NSString *defaultLeftTVName = _leftCodeArray[0];
            [[NSUserDefaults standardUserDefaults] setObject:defaultLeftTVName forKey:kLEFTCATEGORYKEY];
        }

        [_leftTV reloadData];
        
        // 3、右边分类
        _rightArray = _allModelsArray[2];
        _rightNameArray = [NSMutableArray array];
        _rightCodeArray = [NSMutableArray array];
        for (WDCategoryModel *model in _leftArray) {
            
            NSString *code = model.code;
            [_rightCodeArray addObject:code];
        }
        for (WDCategoryModel *model in _rightArray) {
            
            NSString *name = model.name;
            [_rightNameArray addObject:name];
        }
        
        //  存储默认值
        NSString *defaultRightTVName = _rightCodeArray[0];
        [[NSUserDefaults standardUserDefaults] setObject:defaultRightTVName forKey:kRIGHTCATEGORYKEY];
        
        [_rightTV reloadData];
        
        // 4、店铺列表
        self.nearStoreArr = _allModelsArray[3];
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    }];
    
}

//  自定义导航栏返回按钮
- (void)_setupNavigation
{
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
      [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12,45)];
    [btn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)_setupData{
    
//    _leftArray = @[@"全部分类",@"分类1",@"分类2",@"分类3",@"分类4",@"分类5",@"分类6",@"分类7",@"分类8",@"分类9"];
//    _rightArray = @[@"智能排序",@"排序1",@"排序2",@"排序3",@"排序4",@"排序5"];
}

//  设置左右两个下拉列表按钮
- (void)_setLeftAndRightOrderList{
    
    _leftControl = [[UIControl alloc]initWithFrame:_lefBtn.frame];
    _leftControl.backgroundColor = [UIColor clearColor];
    [_leftControl addTarget:self action:@selector(leftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    _leftControl.selected = YES;
    [self.view addSubview:_leftControl];
    
    _rightControl = [[UIControl alloc]initWithFrame:_rightBtn.frame];
    _rightControl.backgroundColor = [UIColor clearColor];
    [_rightControl addTarget:self action:@selector(rightControlAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightControl.selected = YES;
    [self.view addSubview:_rightControl];
    
}

//  左按钮
- (void)leftControlAction:(UIControl *)sender {
    //  改变按钮的选中状态
    _leftSelect = !_leftSelect;
    //  根据按钮的选中状态设置下拉列表的收与合
    if (_leftSelect == YES) {
        
        [UIView animateWithDuration:0.5 animations:^
        {  // 动画可要可不要
            
            _lefBtn.orderListImageName = @"上拉三角";
            
            _leftTV = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lefBtn.frame), CGRectGetMaxY(_lefBtn.frame), _lefBtn.bounds.size.width, 44*_leftArray.count) style:UITableViewStylePlain];
            _leftTV.layer.borderWidth = 1.5;
            _leftTV.layer.borderColor = kViewControllerBackgroundColor.CGColor;
            _leftTV.tag = 150;  // 这里根据tag值来获取不同的tableview
            _leftTV.delegate = self;
            _leftTV.dataSource = self;
            _leftTV.showsVerticalScrollIndicator = NO;
            [self.view addSubview:_leftTV];
        }];
        
        if (_rightTV)
        {
            _rightBtn.orderListImageName = @"下拉三角";
            [_rightTV removeFromSuperview];
            _rightSelect = NO;
        }
    }else{
        
        _lefBtn.orderListImageName = @"下拉三角";
        [_leftTV removeFromSuperview];
    }
    
    
}

//  右按钮
- (void)rightControlAction:(UIControl *)sender {
    
    _rightSelect = !_rightSelect;
    if (_rightSelect == YES) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _rightBtn.orderListImageName = @"上拉三角";
            
            _rightTV = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_rightBtn.frame), CGRectGetMaxY(_rightBtn.frame), _rightBtn.bounds.size.width, 44*_rightArray.count) style:UITableViewStylePlain];
            _rightTV.layer.borderWidth = 1.5;
            _rightTV.layer.borderColor = kViewControllerBackgroundColor.CGColor;
            _rightTV.tag = 250;
            _rightTV.delegate = self;
            _rightTV.dataSource = self;
            _rightTV.showsVerticalScrollIndicator = NO;
            [self.view addSubview:_rightTV];
            
        }];
        if (_leftTV)
        {
            _lefBtn.orderListImageName = @"下拉三角";
            [_leftTV removeFromSuperview];
            _leftSelect = NO;
        }
    }else{
        
        _rightBtn.orderListImageName = @"下拉三角";
        [_rightTV removeFromSuperview];
    }
    
    
}

#pragma mark - tableview协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 350) {
        
        return 80;
    }else
        
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 150) {
        
        return _leftArray.count;
    }
    if (tableView.tag == 250) {
        
        return _rightArray.count;
    }else
    
    return self.nearStoreArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 350)
    {
        
        WDNearStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.nearStoreArr.count > 0)
        {
            WDNearbyStoreModel * nearStore = self.nearStoreArr[indexPath.row];
            cell.storeName.text = nearStore.name;
            cell.qisongPrice.text = [NSString stringWithFormat:@"¥%@",nearStore.startvalue];
            cell.peisongPrice.text = [NSString stringWithFormat:@"¥%@",nearStore.startfee];
            [cell.storeImageView sd_setImageWithURL:[NSURL URLWithString:nearStore.img]];
            cell.distanceLabel.text = nearStore.distance;
            cell.sellCount.text = [NSString stringWithFormat:@"月售%@份",nearStore.monthlysales];
            if ([nearStore.isown isEqualToString:@"1"])
            {
                cell.pingtaiImageView.hidden = NO;
            }
            else
            {
                cell.pingtaiImageView.hidden = YES;
            }
        }
        return cell;
    }
    else
    {
        
        static NSString *near = @"near";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:near];
        if (cell == nil)
        {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:near];
        }
        if (tableView.tag == 150)
        {
            
            cell.textLabel.text = _leftNameArray[indexPath.row];
            
        }if (tableView.tag == 250)
        {
            
            cell.textLabel.text = _rightNameArray[indexPath.row];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 150)
    {
        _lefBtn.orderListTitle = _leftNameArray[indexPath.row]; // 重新给按钮的title赋值
        _lefBtn.orderListImageName = @"下拉三角";
        [_lefBtn setNeedsLayout];
        _leftSelect = !_leftSelect;  //  注意这里需要改变按钮的选中状态
        [_leftTV removeFromSuperview];
        
        // 这里刷新单元格数据
        // 显示指示器
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kSEGMENTKEY];
        NSString *str3 = [[NSUserDefaults standardUserDefaults] objectForKey:kRIGHTCATEGORYKEY];
        NSString *codeStr = _leftCodeArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:codeStr forKey:kLEFTCATEGORYKEY];
        
        [WDNearStoreManager requestNearStoreWithStoreclasses:codeStr storeorder:str3 storesate:str1 currentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
           
            [SVProgressHUD dismiss];
            
            _page = 1;
            self.nearStoreArr = array[3];
            [self.tableView reloadData];
        }];
        
    }
    if (tableView.tag == 250)
    {
        _rightBtn.orderListTitle = _rightNameArray[indexPath.row]; // 重新给按钮的title赋值
        _rightBtn.orderListImageName = @"下拉三角";
        [_rightBtn setNeedsLayout];
        _rightSelect = !_rightSelect;  //  注意这里需要改变按钮的选中状态
        [_rightTV removeFromSuperview];
        
        // 这里刷新单元格数据
        // 显示指示器
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kSEGMENTKEY];
        NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:kLEFTCATEGORYKEY];
        NSString *codeStr = _rightCodeArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:codeStr forKey:kRIGHTCATEGORYKEY];
        
        [WDNearStoreManager requestNearStoreWithStoreclasses:str2 storeorder:codeStr storesate:str1 currentPage:nil completion:^(NSMutableArray *array, NSString *error) {
            
            [SVProgressHUD dismiss];
            
            _page = 1;
            self.nearStoreArr = array[3];
            [self.tableView reloadData];
        }];
    }
    if (tableView.tag == 350)
    {
//        WDNearDetailsViewController *detailsVC = [[WDNearDetailsViewController alloc]init];
        WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
        nearVC.type = 1;
        WDStoreInfosModel * nearStore =  self.nearStoreArr[indexPath.row];
        [WDAppInitManeger saveStrData:nearStore.storeid withStr:@"shopID"];
        [self.navigationController pushViewController:nearVC animated:YES];
    }
}

- (void)goBackAction
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
