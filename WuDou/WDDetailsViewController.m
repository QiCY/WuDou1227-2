//
//  WDDetailsViewController.m
//  WuDou
//
//  Created by huahua on 16/8/8.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDDetailsViewController.h"
#import "WDDetailsTableViewCell.h"
#import "WDNearDetailsViewController.h"
#import "WDGoodsInfoViewController.h"
#import "WDStoreDetailViewController.h"

@interface WDDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,WDDetailsTableViewCellDelegate,UISearchBarDelegate>
{
    NSMutableArray *_bigDatasArray;
    NSMutableArray *_storeMsgArray;
    NSMutableArray * _bigGoodArr;
    
    NSMutableArray * _shopArray;
    NSMutableArray * _imageArray;
    NSMutableArray * _nameArray;
    NSMutableArray * _moneyArray;
    NSMutableArray * _bigArr;
    
    NSString *count1;
    NSString *count2;
}
@property(nonatomic,strong)NSMutableArray *goodsMsgArray;
@end

static NSString *const strID = @"cell";
@implementation WDDetailsViewController

- (NSMutableArray *)goodsMsgArray
{
    
    if (!_goodsMsgArray) {
        
        _goodsMsgArray = [NSMutableArray array];
    }
    
    return _goodsMsgArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    //关闭导航条
    self.navigationController.navigationBarHidden = NO;
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 60, 40);
     [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12,45)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestManger
{
    if (self.isCategories) {  //产品搜索
        
        [WDMainRequestManager requestSearchProductsWithSearchKey:self.searchMsg completion:^(NSMutableArray *array, NSString *error) {
            
            if (error) {
                [SVProgressHUD dismiss];
                [self _createNodatasIconWithRrror:error];
                return ;
            }
            _bigDatasArray = array;
            
            count1 = _bigDatasArray[0];
            count2 = _bigDatasArray[1];
            _storeMsgArray = _bigDatasArray[2];
            _bigGoodArr = _bigDatasArray[3];
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
            
        }];
    }
    else{
        
        [WDSpeakCategoriesManager requestCategorySearchWithCatenumber:self.numberId completion:^(NSMutableArray *array, NSString *error) {
            
            if (error) {
                
                [SVProgressHUD dismiss];
                [self _createNodatasIconWithRrror:error];
                return ;
            }
            _bigDatasArray = array;
            
            count1 = _bigDatasArray[0];
            count2 = _bigDatasArray[1];
            _storeMsgArray = _bigDatasArray[2];
            _bigGoodArr = _bigDatasArray[3];
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
            
        }];
    }
}
/** 提示暂时数据*/
- (void)_createNodatasIconWithRrror:(NSString *)error{
    
    [self.tableView removeFromSuperview];
    
    UIView *noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    noticeView.centerY = self.view.center.y;
    [self.view addSubview:noticeView];
    
    UIImageView *noticeImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-30)*0.5, 0, 30, 33)];
    noticeImage.image = [UIImage imageNamed:@"noData"];
    [noticeView addSubview:noticeImage];
    
    UILabel *noticeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 20)];
    noticeText.text = error;
    noticeText.font = [UIFont systemFontOfSize:15.0];
    noticeText.textAlignment = NSTextAlignmentCenter;
    noticeText.textColor = [UIColor lightGrayColor];
    [noticeView addSubview:noticeText];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.navtitle;
    //  设置导航栏标题颜色 @"搜索列表"
    _storeMsgArray = [[NSMutableArray alloc]init];
    _bigGoodArr = [[NSMutableArray alloc]init];
    _bigDatasArray = [[NSMutableArray alloc]init];
    
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setupNavigation];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    [self.tableView registerNib:[UINib nibWithNibName:@"WDDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:strID];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [self requestManger];
}

#pragma mark - tableview协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_storeMsgArray.count > 0)
    {
        return _storeMsgArray.count;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WDDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strID forIndexPath:indexPath];
    
    if (_storeMsgArray.count > 0)
    {
        WDSearchResultModel *goods = _storeMsgArray[indexPath.row];
        cell.shopName.text = goods.name;
        cell.maney.text = [NSString stringWithFormat:@"配送费¥%@ | 起送价¥%@",goods.startfee,goods.startvalue];
        [cell.shopLogoImage sd_setImageWithURL:[NSURL URLWithString:goods.img]];
        if (_bigGoodArr.count > 0)
        {
            NSMutableArray * dataArr = _bigGoodArr[indexPath.row];
            if (dataArr.count > 0)
            {
                cell.scroll.hidden = NO;
                cell.delegate = self;
                [cell countOfButtonwithData:dataArr];
            }
            else
            {
                cell.scroll.hidden = YES;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    WDNearDetailsViewController * detailsVC = [[WDNearDetailsViewController alloc]init];
    WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
    nearVC.type = 1;
    
    WDSearchResultModel * shop = _storeMsgArray[indexPath.row];
    NSString * shopID = shop.storeid;
    nearVC.storeId = shop.storeid;
    [WDAppInitManeger saveStrData:shopID withStr:@"shopID"];
    [self.navigationController pushViewController:nearVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen ].bounds.size.width, 20)];
    view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    if (section == 0)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 200, 20)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12.0];
        
        if (count1) {
            
            label.text = [NSString stringWithFormat:@"%@个商品%@个门店",count1,count2];
        }else{
            
            label.text = @"0个商品0个门店";
        }
        
        [view addSubview:label];
    }
    return view;
}

-(void)WDDetails:(WDDetailsTableViewCell *)cell didClickWDBtnTag:(NSInteger)WDBtnTag currentWDBtn:(UIButton *)sender
{
    WDDetailsTableViewCell * WDCell = (WDDetailsTableViewCell *)[[[sender superview]superview]superview];
    NSIndexPath * indexPathAll = [self.tableView indexPathForCell:WDCell];
    NSLog(@"你点击了第%ld行的第%ld个",(long)indexPathAll.row,(long)WDBtnTag - 10);
    if (_bigGoodArr.count > 0)
    {
        NSMutableArray * dataArr = _bigGoodArr[indexPathAll.row];
        WDSpecialPriceModel * infosModel = dataArr[WDBtnTag - 10];
        NSString * goodID = infosModel.pid;
        [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
        WDGoodsInfoViewController * goodsInfoVC = [[WDGoodsInfoViewController alloc]init];
        goodsInfoVC.goodsImage = infosModel.img;
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
}




@end
