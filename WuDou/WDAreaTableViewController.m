//
//  WDAreaTableViewController.m
//  WuDou
//
//  Created by huahua on 16/8/16.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDAreaTableViewController.h"

@interface WDAreaTableViewController ()
{
    UIView * _navView;
    NSMutableArray * _dataArray;
}

@end

@implementation WDAreaTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    [WDMainRequestManager requestLoadAreaWithCompletion:^(NSMutableArray *dataArray, NSString *error)
     {
         if (error)
         {
             SHOW_ALERT(error);
             return ;
         }
         _dataArray = dataArray;
         //        _dataArray = [[NSMutableArray alloc]initWithObjects:@"崇川区", @"港闸区", @"通州区", @"能达区", @"海岸区", @"如皋区", @"如东区", @"海门区", @"启东区", nil];
         [self setAreaTable];
         
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    
    NSString * title = @"区域列表";
    //设置label的字体  HelveticaNeue  Courier
    UIFont * font = [UIFont systemFontOfSize:17.0];
    //根据字体得到nsstring的尺寸
    CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    //名字的宽
    CGFloat nameW = size.width;
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - nameW/2, 31, nameW, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.font = font;
    [_navView addSubview:titleLabel];
    
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_navView removeFromSuperview];
}

-(void)setAreaTable
{
    if (_dataArray.count>0)
    {
        NSInteger rowCount = _dataArray.count/4;
        NSInteger count = _dataArray.count%4;
        if (rowCount >0)
        {
            for (int i=0; i<rowCount; i++)
            {
                for (int j=0; j<4; j++)
                {
                    CGFloat X = 10 + ((kScreenWidth - 80)/4 + 20)*j;
                    CGFloat Y = 60 + 50*i;
                    NSInteger index = i*4 + j;
                    [self setOneViewWithX:X withY:Y withIndex:index];
                }
            }
            for (int i=0; i<count; i++)
            {
                CGFloat X = 10 + ((kScreenWidth - 80)/4 + 20)*i;
                CGFloat Y = 60 + 50*rowCount;
                NSInteger index = rowCount * 4 + i;
               [self setOneViewWithX:X withY:Y withIndex:index];
            }
        }
        else
        {
            for (int i=0; i<count; i++)
            {
                CGFloat X = 10 + ((kScreenWidth - 80)/4 + 20)*i;
                CGFloat Y = 60;
                NSInteger index = i;
                [self setOneViewWithX:X withY:Y withIndex:index];
            }
        }
    }
}

-(void)setOneViewWithX:(CGFloat)viewX withY:(CGFloat)viewY withIndex:(NSInteger)index
{
    UIView * oneView = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, (kScreenWidth - 80)/4, 40)];
    oneView.layer.borderWidth = 1.0;
    oneView.layer.borderColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1].CGColor;
    oneView.layer.cornerRadius = 4.0;
    oneView.clipsToBounds = YES;
    [self.view addSubview:oneView];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 10, (kScreenWidth - 80)/4 - 2, 20)];
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    WDAreaModel * model = _dataArray[index];
    nameLabel.text = model.name;
    [oneView addSubview:nameLabel];
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth - 80)/4, 40)];
    btn.tag = index + 10;
    [btn addTarget:self action:@selector(setAreaClick:) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:btn];
    
}

-(void)setAreaClick:(UIButton *)btn
{
    WDAreaModel * model = _dataArray[btn.tag - 10];
    NSString * str = model.name;
    self.loctionVC.mytitle = str;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
