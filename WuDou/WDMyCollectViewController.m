//
//  WDMyCollectViewController.m
//  WuDou
//
//  Created by huahua on 16/8/24.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMyCollectViewController.h"
#import "WDCollctTableViewCell.h"

@interface WDMyCollectViewController ()
{
    UIView * _runView;
    
    NSMutableArray *_datasArray;
}

@end

@implementation WDMyCollectViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //  默认加载未使用优惠券
    [self _getModelData];
}

/** 解析数据*/
- (void)_getModelData{

    [WDMineManager requestMyCouponWithSate:@"1" completion:^(NSMutableArray *array, NSString *error) {
       
        if (error) {
            
            SHOW_ALERT(error)
            return ;
        }
        
        _datasArray = array;
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSMutableArray * oneArr = [NSMutableArray alloc]initWithObjects:<#(nonnull id), ...#>, nil
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WDCollctTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self setTopUI];
    [self _setupNavigation];
}

//  自定义导航栏返回按钮
- (void)_setupNavigation
{
    self.title = @"我的优惠券";
    [self.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 15, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
}

-(void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTopUI
{
    UILabel * oneLab = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth/3 - 80)/2, 10, 80, 20)];
    oneLab.text = @"未使用";
    oneLab.textColor = [UIColor blackColor];
    oneLab.textAlignment = NSTextAlignmentCenter;
    oneLab.font = [UIFont systemFontOfSize:15.0];
    [self.touView addSubview:oneLab];
    
    UILabel * twoLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 40, 10, 80, 20)];
    twoLab.text = @"已使用";
    twoLab.textColor = [UIColor blackColor];
    twoLab.textAlignment = NSTextAlignmentCenter;
    twoLab.font = [UIFont systemFontOfSize:15.0];
    [self.touView addSubview:twoLab];
    
    UILabel * threeLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - ((kScreenWidth/3 - 80)/2 + 80), 10, 80, 20)];
    threeLab.text = @"已过期";
    threeLab.textColor = [UIColor blackColor];
    threeLab.textAlignment = NSTextAlignmentCenter;
    threeLab.font = [UIFont systemFontOfSize:15.0];
    [self.touView addSubview:threeLab];
    
    UIButton * oneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3, 40)];
    [oneBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.touView addSubview:oneBtn];
    
    UIButton * twoBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/3, 0, kScreenWidth/3, 40)];
    [twoBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.touView addSubview:twoBtn];
    
    UIButton * threeBtn = [[UIButton alloc]initWithFrame:CGRectMake(2 * kScreenWidth/3, 0, kScreenWidth/3, 40)];
    [threeBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.touView addSubview:threeBtn];
    
    oneBtn.tag = 1;
    twoBtn.tag = 2;
    threeBtn.tag = 3;
    
    UIView * oneLin = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/3 - 0.5, 10, 1, 20)];
    oneLin.backgroundColor = [UIColor lightGrayColor];
    [self.touView addSubview:oneLin];
    
    UIView * twoLin = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/3 *2 - 0.5, 10, 1, 20)];
    twoLin.backgroundColor = [UIColor lightGrayColor];
    [self.touView addSubview:twoLin];
    
    //下面移动的线
    _runView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, kScreenWidth/3, 2)];
    _runView.backgroundColor = KSYSTEM_COLOR;
    [self.touView addSubview:_runView];
}

-(void)changeClick:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 1:
        {
            [self _getModelData];
            [UIView animateWithDuration:0.5 animations:^
            {
                _runView.frame = CGRectMake(0, 38, kScreenWidth/3, 2);
            }];
        }
            break;
            
        case 2:
        {
            [self _getModelData];
            [UIView animateWithDuration:0.5 animations:^
             {
                 [UIView animateWithDuration:0.5 animations:^
                  {
                      _runView.frame = CGRectMake(kScreenWidth/3, 38, kScreenWidth/3, 2);
                  }];
             }];
        }
            break;
            
        case 3:
        {
            [self _getModelData];
            [UIView animateWithDuration:0.5 animations:^
             {
                 [UIView animateWithDuration:0.5 animations:^
                  {
                      _runView.frame = CGRectMake(kScreenWidth/3 * 2, 38, kScreenWidth/3, 2);
                  }];
             }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - tableview协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDCollctTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WDMyCouponModel *model = _datasArray[indexPath.row];
    cell.exchangeCode.text = [NSString stringWithFormat:@"兑换码：%@",model.couponsn];
    cell.couponPrice.text = model.money;
    cell.couponMaxMoney.text = [NSString stringWithFormat:@"满%@元可以使用",model.orderamountlower];
    cell.couponStartDate.text = model.usestarttime;
    cell.couponEndDate.text = model.useendtime;
    
    return cell;
}

@end
