//
//  WDAddressTableVController.m
//  WuDou
//
//  Created by huahua on 16/8/24.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDAddressTableVController.h"
#import "WDShoppingAdressCell.h"
#import "WDEditAdressViewController.h"
#import "WDLoginViewController.h"
#import "WDAccountViewController.h"
#import "WDJifenMsgViewController.h"

#define kArchivingDataKey @"archivingDataKey"

@interface WDAddressTableVController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *datasArray;

@end

static NSString *reuseID = @"WDShoppingAdressCell";
@implementation WDAddressTableVController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self _loadDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.title = @"我的收货地址";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WDShoppingAdressCell" bundle:nil] forCellReuseIdentifier:reuseID];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)_loadDatas{
    
    [WDMineManager requestSendAddressWithCompletion:^(NSMutableArray *array, NSString *resultRet, NSString *error) {
       
        if (error) {
            
//            [self _createNodatasIcon];
            return ;
        }
        
        if ([resultRet isEqualToString:@"2"]) {
            
            WDLoginViewController *loginVC = [[WDLoginViewController alloc]init];
            loginVC.popType = @"返回我的地址界面";
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        
        self.datasArray = array;
        [self.tableView reloadData];
    }];
}

/** 提示暂时数据*/
- (void)_createNodatasIcon{
    
    [self.tableView removeFromSuperview];
    
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
    btn.frame = CGRectMake(0, 0, 60, 40);
     [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12,45)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    //  右侧发布信息按钮
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/** 添加新地址*/
- (void)addAddress:(UIButton *)addAds{
    
    WDEditAdressViewController *editAddressVC = [[WDEditAdressViewController alloc]init];
    editAddressVC.uploadType = @"添加新地址";
    [self.navigationController pushViewController:editAddressVC animated:YES];
}

- (NSMutableArray *)datasArray{
    
    if (_datasArray == nil) {
        _datasArray = [NSMutableArray array];
    }
    
    return _datasArray;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.datasArray.count == 0) {
        
    }

    return _datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDShoppingAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.datasArray.count > 0) {
        
        WDLoadAddressModel *model = self.datasArray[indexPath.row];
        cell.userName.text = model.consignee;
        cell.userNumber.text = model.mobile;
        cell.detailAddress.text = model.addressmark;
        if (indexPath.row == 0) {
            
           cell.adressLabel.text = [NSString stringWithFormat:@"%@（默认）",model.address];
//            [[NSUserDefaults standardUserDefaults] setObject:model.address forKey:@"DEFAULTADDRESS"];
//            [[NSUserDefaults standardUserDefaults] setObject:model.consignee forKey:@"DEFAULTNAME"];
//            [[NSUserDefaults standardUserDefaults] setObject:model.mobile forKey:@"DEFAULTNUMBER"];
            
        }else{
            
            cell.adressLabel.text = model.address;
        }
//        cell.adressLabel.text = model.address;
//        cell.userName.text = model.consignee;
//        cell.userNumber.text = model.mobile;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.datasArray.count > 0) {
        
        WDLoadAddressModel * model = self.datasArray[indexPath.row];
        if ([self.sourceType isEqualToString:@"从设置中进入我的地址"]) {
            
            WDEditAdressViewController *editAddressVC = [[WDEditAdressViewController alloc]init];
            editAddressVC.uploadType = @"编辑地址";
            editAddressVC.model = model;
            editAddressVC.said = model.said;
            [self.navigationController pushViewController:editAddressVC animated:YES];
        }
        if ([self.sourceType isEqualToString:@"选择收货地址"]) {
            
           for (UIViewController *controller in self.navigationController.viewControllers) {//遍历
                if ([controller isKindOfClass:[WDAccountViewController class]])
                { //这里判断是否为你想要跳转的页面
                    
                    WDAccountViewController *accountVC = (WDAccountViewController *)controller;
                    accountVC.model = model;
                    [self.navigationController popToViewController:accountVC animated:YES];
                }
               if ([controller isKindOfClass:[WDJifenMsgViewController class]]) {
                   
                   WDJifenMsgViewController *jifenMsgVC = (WDJifenMsgViewController *)controller;
                   jifenMsgVC.model = model;
                   [self.navigationController popToViewController:jifenMsgVC animated:YES];
               }
        
           }
    }
  }

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
        if (indexPath.row<[self.datasArray count]) {
            
            WDLoadAddressModel *model = self.datasArray[indexPath.row];
            [WDMineManager requestDeleteAddressWithSaid:model.said completion:^(NSString *result, NSString *error) {
               
                if (error) {
                    
                    SHOW_ALERT(error)
                    return ;
                }
                
                [self.datasArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
                
                [self.tableView reloadData];
            }];
            
            
        }
    }
}

@end
