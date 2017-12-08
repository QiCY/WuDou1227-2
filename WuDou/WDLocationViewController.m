//
//  WDLocationViewController.m
//  WuDou
//
//  Created by huahua on 16/8/16.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDLocationViewController.h"
#import "CCLocationManager.h"
#import "WDLoctionTableViewCell.h"
#import "WDAddressTableViewCell.h"
#import "WDAreaTableViewController.h"
#import "WDCurrentAdressViewController.h"
#import "WDAddressTableVController.h"
#import "Single.h"

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

@interface WDLocationViewController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    CLLocationManager *locationmanager;
    UIView * _navView;
}

@end

@implementation WDLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.searchBar.barTintColor = kViewControllerBackgroundColor;
    self.searchBar.delegate = self;
    [self.locTableView registerNib:[UINib nibWithNibName:@"WDLoctionTableViewCell" bundle:nil] forCellReuseIdentifier:@"Lcell"];
    self.locTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.addressTableView registerNib:[UINib nibWithNibName:@"WDAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"Acell"];
    //去掉多余的分割线
    self.addressTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
//    if (self.mytitle != nil) {
//        
//        Single *single = [Single shareSingle];
//        if (single.str != nil) {
//            
//            self.mytitle = single.str;
//        }
//    }
    
    NSLog(@"%@",self.mytitle);
    [self setNavTabUI];
}
-(void)setNavTabUI
{
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navView.backgroundColor =KSYSTEM_COLOR;
    [[UIApplication sharedApplication].keyWindow addSubview:_navView];
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 31, 15, 20)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIButton * bigBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 35, 44)];
    [bigBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backBtn];
    [_navView addSubview:bigBtn];
    
    NSString * title;
    if (self.mytitle == nil)
    {
        title = @"南京市";
    }
    else
    {
        title = self.mytitle;
    }
    //设置label的字体  HelveticaNeue  Courier
    UIFont * font = [UIFont systemFontOfSize:17.0];
    //根据字体得到nsstring的尺寸
    CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    //名字的宽
    CGFloat nameW = size.width;
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - (nameW + 20)/2, 31, nameW, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.font = font;
    [_navView addSubview:titleLabel];
    
    UIImageView * shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 + (nameW + 20)/2 - 15, 37.5, 10, 9)];
    shareImage.image = [UIImage imageNamed:@"下拉三角-1"];
    [_navView addSubview:shareImage];
    
    UIButton * locBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2 - (nameW + 20)/2, 26, nameW + 20, 30)];
    [locBtn addTarget:self action:@selector(locClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:locBtn];
    
}

-(void)locClick
{
    WDAreaTableViewController * areaVC = [[WDAreaTableViewController alloc]init];
    areaVC.loctionVC = self;
    [self.navigationController pushViewController:areaVC animated:YES];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_navView removeFromSuperview];
}

#pragma mark - tableview协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.locTableView)
    {
        return 40;
    }
    else
    {
        return 60;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.locTableView)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.locTableView)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.locTableView)
    {
        return 0;
    }
    else
    {
        return 40;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.locTableView)
    {
        WDLoctionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Lcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else
    {
        WDAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Acell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.locTableView) {
        
        WDCurrentAdressViewController *currentVC = [[WDCurrentAdressViewController alloc]init];
        [self.navigationController pushViewController:currentVC animated:YES];
        
    }else{
        
        WDAddressTableVController *addTV = [[WDAddressTableVController alloc]init];
        [self.navigationController pushViewController:addTV animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    label.text = @"我的收货地址";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:label];
    
    return view;
}

#pragma mark - UISearchBarDelegate
//  点击键盘上的 search 按钮时触发
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (![searchBar.text isEqualToString:@""]) {
        
        NSLog(@"跳转至 搜索页");
    }
    
    [searchBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
