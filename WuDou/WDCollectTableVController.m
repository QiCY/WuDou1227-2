//
//  WDCollectTableVController.m
//  WuDou
//
//  Created by huahua on 16/8/24.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDCollectTableVController.h"
#import "WDCollectCell.h"
#import "WDNearDetailsViewController.h"
#import "WDLoginViewController.h"
#import "WDGoodsInfoViewController.h"

@interface WDCollectTableVController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_datasArray;
}
@property(nonatomic,strong)UITableView *tableView;

@end

static NSString *reuseId = @"WDCollectCell";
@implementation WDCollectTableVController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self _loadMoreDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.title = @"我的收藏";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WDCollectCell" bundle:nil] forCellReuseIdentifier:reuseId];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)_loadMoreDatas{
    
    [WDMineManager requestMyCollectionWithCompletion:^(NSMutableArray *array, NSString *resultRet, NSString *error) {
       
        if (error) {
            NSLog(@"%@",error);
            [self _createNodatasIcon];
            return ;
        }
        if ([resultRet isEqualToString:@"2"]) {
            
            WDLoginViewController *loginVC = [[WDLoginViewController alloc]init];
            loginVC.popType = @"返回我的地址界面";
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        
        _datasArray = array;
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
    WDMyCollectModel *model = _datasArray[indexPath.row];
    [cell.storeImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    CGFloat score = [model.starcount floatValue];
    cell.starView.socre = score*10/5;
    cell.storeName.text = model.name;
    cell.commentCounts.text = [NSString stringWithFormat:@"共%@ 件商品 | 月售%@ 单",model.productcount,model.monthlysales];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDMyCollectModel *model = _datasArray[indexPath.row];
    NSString *type = model.urlType;
    if ([type isEqualToString:@"1"]) { //店铺
        
        WDNearDetailsViewController *nearDetailsVC = [[WDNearDetailsViewController alloc]init];
        nearDetailsVC.storeId = model.url;
        [WDAppInitManeger saveStrData:nearDetailsVC.storeId withStr:@"shopID"];
        [self.navigationController pushViewController:nearDetailsVC animated:YES];
        
    }else{  //商品
        
        WDGoodsInfoViewController *infosVC = [[WDGoodsInfoViewController alloc]init];
        NSString *goodID = model.url;
        infosVC.goodsID = goodID;
        [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
        [self.navigationController pushViewController:infosVC animated:YES];
    }
}


////要求委托方的编辑风格在表视图的一个特定的位置。
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
//    if ([tableView isEqual:self.tableView]) {
//        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
//    }
//    return result;
//}
//
////设置是否显示一个可编辑视图的视图控制器。
//-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
//    [super setEditing:editing animated:animated];
//    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
//}
//
////请求数据源提交的插入或删除指定行接收者。
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
//        if (indexPath.row<[_datasArray count]) {
//            
//            WDMyCollectModel *model = _datasArray[indexPath.row];
//            [WDMineManager requestCancelMyCollectWithRecordId:model.recordid completion:^(NSString *result, NSString *error) {
//               
//                if (error) {
//                    SHOW_ALERT(error)
//                }
//                
//                [_datasArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
//                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
//                
//                [self.tableView reloadData];
//            }];
//            
//        }
//    }
//}

@end
