//
//  WDAddJudgementViewController.m
//  WuDou
//
//  Created by huahua on 16/12/3.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDAddJudgementViewController.h"
#import "WDAddJudgementsCell.h"
#import "WDMyJudgementsViewController.h"
#import "WDMyJudgementsCell.h"
#import "WDMyJudgementsLayout.h"

@interface WDAddJudgementViewController ()<UITableViewDelegate,UITableViewDataSource,WDAddJudgementsCellDelegate>
{
    UITableView *_judgeTableView;
    NSMutableArray *_datas;
}

@property(nonatomic,strong)NSMutableArray *upLoadArray;
@property(nonatomic,strong)NSMutableDictionary *upLoadDic;
@end

static NSString *addjudgeId = @"isJudgement";
@implementation WDAddJudgementViewController

- (NSMutableArray *)upLoadArray{
    
    if (!_upLoadArray) {
        
        _upLoadArray = [NSMutableArray array];
        for (int i = 0; i < _datas.count; i ++) {
            
            NSString *str = @"";
            [_upLoadArray addObject:str];
        }
    }
    return _upLoadArray;
}

- (NSMutableDictionary *)upLoadDic{
    
    if (!_upLoadDic) {
        
        _upLoadDic = [[NSMutableDictionary alloc] init];
    }
    return _upLoadDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加评价";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setupNavigation];
    
    [self _loadDatas];
    
    _judgeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _judgeTableView.delegate = self;
    _judgeTableView.dataSource = self;
    _judgeTableView.showsVerticalScrollIndicator = NO;
    _judgeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _judgeTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    [_judgeTableView registerNib:[UINib nibWithNibName:@"WDMyJudgementsCell" bundle:nil] forCellReuseIdentifier:addjudgeId];
    
    [self.view addSubview:_judgeTableView];
}

- (void)_loadDatas{
    
    [WDMineManager requestUserJudgementOrderDataWithOid:self.oid completion:^(NSMutableArray *array, NSString *error) {
       
        if (error) {
            SHOW_ALERT(error)
            _judgeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            [_judgeTableView reloadData];
            return ;
        }
        
        _datas = array;
        [_judgeTableView reloadData];
    }];
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 15, 20);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_datas.count != 0) {
        
        return _datas.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDSpecialPriceModel *model = _datas[indexPath.row];
    if ([model.isreviews isEqualToString:@"1"]) {  //评论过了
        
        WDMyJudgementsCell *cell = [tableView dequeueReusableCellWithIdentifier:addjudgeId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic = model.reviews;
        WDMyJudgementModel *judgeModel = [[WDMyJudgementModel alloc] initWithDictionary:dic];
        WDMyJudgementsLayout *layout = [[WDMyJudgementsLayout alloc] init];
        layout.judgesModel = judgeModel;
        cell.layout = layout;
        cell.cellType = 0;
        cell.judgesName.text = model.name;
        
        return cell;
    }
    else{
        
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];  //以indexPath来唯一确定cell
        
        WDAddJudgementsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[WDAddJudgementsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.superV = self;
        if (_datas.count != 0) {
            
            cell.goodsName.text = model.name;
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
            cell.pid = model.pid;
            cell.currentRow = indexPath.row;
            cell.delegation = self;
        }
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDSpecialPriceModel *model = _datas[indexPath.row];
    if ([model.isreviews isEqualToString:@"1"]) {  //评论过了
        
        NSDictionary *dic = model.reviews;
        WDMyJudgementModel *judgeModel = [[WDMyJudgementModel alloc] initWithDictionary:dic];
        WDMyJudgementsLayout *layout = [[WDMyJudgementsLayout alloc] init];
        layout.judgesModel = judgeModel;
        
        return layout.cellHeight;
    }
    else{
        
        return 405;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if ([self.judgeState isEqualToString:@"查看评论"]) {
        
        return nil;
    }
    else{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-20, 40)];
    bottomBtn.backgroundColor = KSYSTEM_COLOR;
    [bottomBtn setTitle:@"提交评价" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [bottomBtn addTarget:self action:@selector(commitJudgements:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:bottomBtn];
    
        return bottomView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([self.judgeState isEqualToString:@"查看评论"]) {
        
        return 0;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01f;
}

/** 提交评价*/
- (void)commitJudgements:(UIButton *)btn{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    [self.upLoadDic setObject:token forKey:@"access_token"];
    [self.upLoadDic setObject:self.oid forKey:@"oid"];
    [self.upLoadDic setObject:self.upLoadArray forKey:@"data"];
    
    // 判断当前对象是否能够转换成JSON数据.
    BOOL isYes = [NSJSONSerialization isValidJSONObject:self.upLoadDic];
    
    if (isYes) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_upLoadDic options:0 error:NULL];
        
        // 将JSON数据写成文件
        [jsonData writeToFile:@"/Users/os1/Desktop/dict.json" atomically:YES];
        
        NSString *dicstr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        // 添加评论
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *urlStr = [NSString stringWithFormat:@"%@api/productreviews/AddReviews",API_PORT];
        NSDictionary *para = @{@"data":dicstr};
        
        [manager POST:urlStr parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *ret = responseObject[@"ret"];
            NSString *msg = responseObject[@"msg"];
            
            if ([ret isEqualToString:@"0"]) {
        
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    WDMyJudgementsViewController *VC = [[WDMyJudgementsViewController alloc] init];
                    VC.navTitle = @"我的评价";
                    VC.judgeState = @"MyJudgements";
                    VC.cellState = 0;
                    VC.jumpState = @"jumpToMine";
                    [self.navigationController pushViewController:VC animated:YES];
                }];
                
                [alertView addAction:sure];
                [self presentViewController:alertView animated:YES completion:nil];  //用模态的方法显示对话框
            }
            else{
             
                SHOW_ALERT(msg)
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
        }];
        
    } else {
        
        NSLog(@"JSON数据生成失败，请检查数据格式");
    }
}

#pragma mark - WDAddJudgementsCellDelegate
- (void)getUploadDataWithDic:(NSMutableDictionary *)dic currentRow:(NSInteger)row{
    
//    NSLog(@"-----%ld-----%@",row,dic);
    [self.upLoadArray replaceObjectAtIndex:row withObject:dic];
    NSLog(@"-----%@",self.upLoadArray);
}

@end
