//
//  WDApplyRefundViewController.m
//  WuDou
//
//  Created by huahua on 16/12/29.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDApplyRefundViewController.h"
#import "WDMyOrderViewController.h"

@interface WDApplyRefundViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_orderListTableView;  //下拉列表
}
@property(nonatomic,strong)NSMutableArray *reasonsArray;

@end

@implementation WDApplyRefundViewController

- (NSMutableArray *)reasonsArray{
    
    if (!_reasonsArray) {
        
        _reasonsArray = [NSMutableArray array];
    }
    return _reasonsArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [self _requestDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.title = @"退款";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self _setupNavigation];
    
    //  添加通知，当textView开始输入的时候隐藏 placeholderLabel
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification  object:_tuikuanReason];
    
    _tuikuanReason.delegate = self;
    
    self.fankuiLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.fankuiLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:self.fankuiLabel];
    
    self.commitBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.commitBtn.backgroundColor = KSYSTEM_COLOR;
    [self.commitBtn addTarget:self action:@selector(commitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitBtn];
    
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 15, 20);
    [btn setImageEdgeInsets:UIEdgeInsetsMake(4, 3, 4,3)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState: UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//  通知的方法
- (void)textDidChange{
    
    _placeHolderLabel.hidden = _tuikuanReason.hasText;
}

//  移除通知
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}

/** 请求数据*/
- (void)_requestDatas{
    
    [WDMineManager requestRefundReasonWithOid:self.oid completion:^(NSMutableArray *array,NSString *reason,NSString *mark,NSString *fankui,NSString *error) {
        
        if (error) {
            
            [SVProgressHUD dismiss];
            return ;
        }
        
        if ([fankui isEqualToString:@""] || fankui == nil) {
            
            self.fankuiLabel.frame = CGRectZero;
            self.commitBtn.frame = CGRectMake(20, CGRectGetMaxY(self.tuikuanReason.frame)+20, kScreenWidth-40, 40);
        }else{
            
            //设置label的字体  HelveticaNeue  Courier
            UIFont * font = [UIFont systemFontOfSize:15.0];
            //赋值
            self.fankuiLabel.text = [NSString stringWithFormat:@"商家反馈: %@",fankui];
            //根据字体得到nsstring的尺寸
            CGSize size = [self.fankuiLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
            self.fankuiLabel.frame = CGRectMake(20, CGRectGetMaxY(self.tuikuanReason.frame)+20, kScreenWidth-40, size.height);
            self.commitBtn.frame = CGRectMake(20, CGRectGetMaxY(self.fankuiLabel.frame)+20, kScreenWidth-40, 40);
        }
        
        if ([reason isEqualToString:@""] || reason == nil) {
            
            self.quehuoLabel.text = @"请选择";
        }else{
            
            self.quehuoLabel.text = reason;
        }
        
        if ([mark isEqualToString:@""] || mark == nil) {
            
            self.placeHolderLabel.hidden = NO;
        }else{
            
            self.placeHolderLabel.hidden = YES;
            self.tuikuanReason.text = mark;
        }
        
        self.reasonsArray = array;
        [_orderListTableView reloadData];
        
        [SVProgressHUD dismiss];
    }];
}

/** 弹出下拉列表*/
- (IBAction)orderListClick:(UIButton *)sender {
    
    sender.enabled = NO;
    [self.view endEditing:YES];
    
    //创建tableview
    _orderListTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.orderListView.x, CGRectGetMaxY(self.orderListView.frame), sender.width, 200) style:UITableViewStylePlain];
    _orderListTableView.layer.borderWidth = 1;
    _orderListTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _orderListTableView.delegate = self;
    _orderListTableView.dataSource = self;
    [self.view addSubview:_orderListTableView];
}

/** 提交按钮*/
- (void)commitBtnClick:(UIButton *)sender {
    
    NSString *reason;
    if ([self.quehuoLabel.text isEqualToString:@"请选择"]) {
        
        reason = @"";
    }else{
        
        reason = self.quehuoLabel.text;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定申请退款？" preferredStyle:UIAlertControllerStyleAlert];

    //  取消
    UIAlertAction *canceled = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alert addAction:canceled];

    //  确定
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [WDMineManager requestApplyforMoneyWithOid:self.oid refundReason:reason refundMark:self.tuikuanReason.text completion:^(NSString *result, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            WDMyOrderViewController *orderVC = [[WDMyOrderViewController alloc] init];
            orderVC.istype = 1;
            [self.navigationController pushViewController:orderVC animated:YES];
            
        }];
    }];
    [alert addAction:sure];

    [self presentViewController:alert animated:YES completion:nil];  //用模态的方法显示对话框
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.reasonsArray.count > 0) {
        
        return self.reasonsArray.count;
    }else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reasons"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reasons"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.reasonsArray.count > 0) {
        
        cell.textLabel.text = self.reasonsArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.quehuoLabel.text = self.reasonsArray[indexPath.row];
    [tableView removeFromSuperview];
    self.orderListBtn.enabled = YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里响应return键
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
    if (_orderListTableView) {
        
        self.orderListBtn.enabled = YES;
        [_orderListTableView removeFromSuperview];
    }
}

@end
