//
//  WDSearchViewController.m
//  WuDou
//
//  Created by huahua on 16/8/8.
//  Copyright © 2016年 os1. All rights reserved.
//  首页 -- 搜索页面

#import "WDSearchViewController.h"
#import "WDDetailsViewController.h"
#import "WDNavigationController.h"
#import "KeyboardToolBar.h"

@interface WDSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_rememberArray;  //从本地读取的数组
}
@property(nonatomic,strong)NSMutableArray *historyArray;  //搜索历史存储数组

@end

@implementation WDSearchViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    //  视图加载完成成为第一响应者，调出系统键盘
    [KeyboardToolBar registerKeyboardToolBar:_searchShops];
//    [_searchShops becomeFirstResponder];
    
    _rememberArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"HISTORY"];
    if (_rememberArray.count == 0) {
        
        [self _createNodatasIcon];
    }
}

/** 提示暂时数据*/
- (void)_createNodatasIcon{
    
    [_historyTableView removeFromSuperview];
    
    UIView *noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
    noticeView.centerY = self.view.center.y+30;
    [self.view addSubview:noticeView];
    
    UIImageView *noticeImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-30)*0.5, 0, 30, 33)];
    noticeImage.image = [UIImage imageNamed:@"noData"];
    [noticeView addSubview:noticeImage];
    
    UILabel *noticeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 20)];
    noticeText.text = @"暂无搜索记录";
    noticeText.font = [UIFont systemFontOfSize:15.0];
    noticeText.textAlignment = NSTextAlignmentCenter;
    noticeText.textColor = [UIColor lightGrayColor];
    [noticeView addSubview:noticeText];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_searchShops resignFirstResponder];  //首先要收回键盘
    
    //  保存本地
    [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:@"HISTORY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  lazy -- 懒加载
- (NSMutableArray *)historyArray{
    
    if (!_historyArray) {
        
        _historyArray = [[NSMutableArray alloc] initWithArray:_rememberArray];
    }
    
    return _historyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    _searchShops.delegate = self;
    
    _searchView.backgroundColor = KSYSTEM_COLOR;
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    
//    self.historyTableView.frame = CGRectMake(0, 110, kScreenWidth, self.historyArray.count * self.historyTableView.rowHeight + self.historyTableView.tableFooterView.height);
    
}

/* 点击取消的方法 **/
- (IBAction)cancelAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //点击return，保存搜索记录
    NSString * textFieldStr = textField.text;
    NSString * searchStr = [textFieldStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![searchStr isEqualToString:@""]) {
        
        [self.historyArray addObject:searchStr];
        //  保存本地
        [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:@"HISTORY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //进入搜索页面
        WDDetailsViewController *detailsVC = [[WDDetailsViewController alloc] init];
        detailsVC.searchMsg = searchStr;
        detailsVC.navtitle = @"搜索列表";
        detailsVC.isCategories = 1;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    //失去第一响应者，收回键盘
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.historyArray.count == 0) {
        return 0;
    }
    
    return self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        
        cell.textLabel.text = self.historyArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //进入搜索页面
    WDDetailsViewController *detailsVC = [[WDDetailsViewController alloc] init];
    NSString *string = self.historyArray[indexPath.row];
    detailsVC.searchMsg = string;
    detailsVC.isCategories = 1;
    detailsVC.navtitle = @"搜索列表";
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.historyArray.count == 0) {
        return 0;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerV;
    
    if (self.historyArray.count == 0) {
        
        footerV = nil;
        
    }else{
    
    footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    UIButton *cleanHistory = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 50, 10, 100, 30)];
    [cleanHistory setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    [cleanHistory setTitleColor:KSYSTEM_COLOR forState:UIControlStateNormal];
    cleanHistory.titleLabel.font = [UIFont systemFontOfSize:15.0];
    cleanHistory.layer.borderWidth = 1;
    cleanHistory.layer.cornerRadius = 5;
    cleanHistory.layer.borderColor = KSYSTEM_COLOR.CGColor;
    [cleanHistory addTarget:self action:@selector(cleanHistoryAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerV addSubview:cleanHistory];
    }
    
    return footerV;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

/* 清除搜索记录 **/
- (void)cleanHistoryAction:(UIButton *)btn{
    
    [self.historyArray removeAllObjects];
    
    [self _createNodatasIcon];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end
