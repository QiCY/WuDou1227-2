//
//  WDAccountViewController.m
//  WuDou
//
//  Created by huahua on 16/8/11.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDAccountViewController.h"
#import "RemarkTableViewCell.h"
#import "PlaceTableViewCell.h"
#import "PayTableViewCell.h"
#import "DetailTableViewCell.h"
#import "WDPeisongTimeCell.h"
#import "DiscountTableViewCell.h"
#import "WDPayViewController.h"
#import "WDAddressTableVController.h"
#import "WDCollectViewController.h"
#import "Product.h"
#import "WDChooseCouponViewController.h"

@interface WDAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView * _navView;
    //全部商店，商品的总价
    float _wholePrice;
    //结算的商品
    NSMutableArray * _newDataArray;
    NSMutableArray *_timeDatas;
    
    NSString *_beizhu;
    NSString *_sendTime;
    
    WDLoadAddressModel *_addressModel;

    UITableView *_choiceTableView;
}
@property(nonatomic,strong)NSMutableArray *discountList;
@property(nonatomic,strong)UIPickerView *choicePickerView;
@property(nonatomic,strong)WDMyCouponModel *coupon;

@end

@implementation WDAccountViewController

- (UIPickerView *)choicePickerView{
    
    if (!_choicePickerView) {
        
        _choicePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 214, kScreenWidth, 150)];
    }
    return _choicePickerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];  //注册xib
    [self.tableView registerNib:[UINib nibWithNibName:@"PayTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell4"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"DiscountTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell5"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WDPeisongTimeCell" bundle:nil] forCellReuseIdentifier:@"cell6"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)setAlldataArray
{
    _newDataArray = [[NSMutableArray alloc]init];
    NSMutableArray * oldDataArr = [NSMutableArray arrayWithArray:self.dataArray];
    NSMutableArray *shopArray = [[NSMutableArray alloc] init];
//    取得所有店铺id
    for (int i = 0; i<self.dataArray.count; i++) {
        WDChooseGood *good = self.dataArray[i];
        if (![shopArray containsObject:good.shopID]) {
            [shopArray addObject:good.shopID];
        }
    }
//    将商品按照店铺分类
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    for (int i = 0; i<shopArray.count; i++) {
        NSMutableArray *shopGoodList = [[NSMutableArray alloc] init];
        for (int j = 0; j<self.dataArray.count; j++) {
            WDChooseGood *good = self.dataArray[j];
            NSString *shopId = shopArray[i];
            if ([shopId isEqualToString:good.shopID]) {
                [shopGoodList addObject:good];
            }
        }
        [dataList addObject:shopGoodList];
    }
    
    _newDataArray = dataList;
    
    
//    for (int i=0; i<self.dataArray.count; i++)
//    {
//        WDChooseGood * good1 = self.dataArray[i];
//        for (int j=i + 1; j<self.dataArray.count; j++)
//        {
//             WDChooseGood * good2 = self.dataArray[j];
//            if ([good1.shopID isEqualToString:good2.shopID])
//            {
//                [self.dataArray removeObjectAtIndex:j];
//                j = j -1;
//            }
//        }
//    }
//    for (int i=0; i<self.dataArray.count; i++)
//    {
//        WDChooseGood * good1 = self.dataArray[i];
//        NSMutableArray * array = [NSMutableArray array];
//        for (int j=0; j<oldDataArr.count; j++)
//        {
//            WDChooseGood * good2 = oldDataArr[j];
//            if ([good1.shopID isEqualToString:good2.shopID])
//            {
//                [array addObject:good2];
//            }
//        }
//        [_newDataArray addObject:array];
//    }
    _wholePrice = 0.0;
//    float _yunFei = 0.0;
//    获取商品总价
//    for (int i = 0; i<self.dataArray.count; i++) {
//        WDChooseGood *good = self.dataArray[i];
//        _wholePrice = _wholePrice + [good.goodPrice floatValue] * [good.goodNum intValue];
//    }
    for (NSMutableArray *array in _newDataArray) {
        for (int i = 0; i<array.count; i++) {
            WDChooseGood *good = array[i];
            _wholePrice = _wholePrice + [good.goodPrice floatValue] * [good.goodNum intValue];
            if (i==array.count-1) {
                if (_wholePrice<[good.goodStartFee floatValue]) {
                    _wholePrice = _wholePrice+[good.goodDistributePrice floatValue];
                }
                
            }
        }
    }
    NSLog(@"total price is %f",_wholePrice);
     self.allcount.text = [NSString stringWithFormat:@"¥%.2f",_wholePrice ];
    
//    for (int i=0; i<_newDataArray.count; i++)
//    {
//        NSMutableArray * array = _newDataArray[i];
//        for (int j=0; j<array.count; j++)
//        {
//            WDChooseGood * goodModel = array[j];
//            _wholePrice = _wholePrice + [goodModel.goodPrice floatValue] * [goodModel.goodNum floatValue];
//        }
//        WDChooseGood * goodModel1 = array[0];
//        _yunFei = _yunFei + [goodModel1.goodDistributePrice floatValue];
//    }
//    _wholePrice = _wholePrice + _yunFei;
//    self.allcount.text = [NSString stringWithFormat:@"¥%.2f",_wholePrice ];
}

- (NSMutableDictionary *)_createOrderWithToken:(NSString *)token{
    
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
    
    NSString *userName = self.model.consignee;
    NSString *userPhone = self.model.mobile;
    NSString *address = self.model.address;
    
    NSString *state = @"支付宝支付";
    NSString *beizhu = _beizhu;
    
    [orderDic setObject:token forKey:@"access_token"];
    [orderDic setObject:userName forKey:@"name"];
    [orderDic setObject:userPhone forKey:@"mobile"];
    [orderDic setObject:address forKey:@"address"];
    [orderDic setObject:state forKey:@"paystate"];
    [orderDic setObject:beizhu forKey:@"remark"];
    return orderDic;
}


-(void)viewWillAppear:(BOOL)animated
{
    self.discountList = [NSMutableArray new];
    [self setNavTabUI];
    [self.bottomView setHidden:NO];
    [self _loadSendTime];
    [self setAlldataArray];
    [self _loadNormalAddress];
    self.payButton.backgroundColor = KSYSTEM_COLOR;
//    [self.tableView reloadData];
    [self getDiscount];
    if (self.model) {
        
        self.addressId = self.model.said;
    }
    
}
/** 加载默认地址*/
- (void)_loadNormalAddress{
    
    [WDMineManager requestSendAddressWithCompletion:^(NSMutableArray *array, NSString *resultRet, NSString *error) {
        
        if (error) {
            
            _addressModel = nil;
            
        }else{
            
            _addressModel = array[0];
            self.addressId = _addressModel.said;
        }
        
        [self.tableView reloadData];
    }];
}

- (void)getDiscount{
    NSString *storeId = @"";
    // 请求数据
    if (_dataArray.count>0) {
        WDChooseGood *good = _dataArray.firstObject;
        storeId = good.shopID;
    }
    [WDNearStoreManager requestStoreInfoCouponsWithStoreId:storeId completion:^(NSMutableArray *array, NSString *error) {
        for (WDMyCouponModel *model in array) {
            float lowMoney = [model.orderamountlower floatValue];
            if (_wholePrice>=lowMoney) {
                [self.discountList addObject:model];
            }
        }
     
        self.coupon = self.discountList.firstObject;
        [self.tableView reloadData];
    }];
}
- (void)_loadSendTime{
    
    NSString *storeId = @"";
    // 请求数据
    if (_dataArray.count>0) {
        WDChooseGood *good = _dataArray.firstObject;
        storeId = good.shopID;
    }
    [WDNearStoreManager requestChoiceSendTimeWithStoreId:storeId  completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            SHOW_ALERT(error)
            return ;
        }
        
        _timeDatas = array;
        WDSendTimeModel *model = _timeDatas[0];
        NSString *time = model.distributionDesn;
        _sendTime = model.autotimeid;
        [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"PEISONGTIME"];
        
        [self.tableView reloadData];
        
        [self.choicePickerView reloadAllComponents];
    }];
}

-(void)setNavTabUI
{
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navView.backgroundColor = KSYSTEM_COLOR;
    [[UIApplication sharedApplication].keyWindow addSubview:_navView];
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 31, 15, 20)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backBtn];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 100, 31, 200, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"订单结算";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_navView addSubview:titleLabel];
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_navView removeFromSuperview];
    [self.bottomView setHidden:YES];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PEISONGTIME"];
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        
        return 10;
    }
    else{
        
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        
        if (section == 4)
        {
            if (_newDataArray.count > 0)
            {
                return _newDataArray.count;
            }
            return 1;
        }
        return 1;
    }
    else{
        
        return _timeDatas.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        
        return 6;
    }
    else{
        
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        
        if (indexPath.section == 0)
        {
            if (!_addressModel) {
                
                return 44;
            }else{
                
                return 60;
            }
        }
        if (indexPath.section == 1)
        {
            return 40;
        }
        if (indexPath.section == 2)
        {
            return 40;
        }
        if (indexPath.section == 3)
        {
            return 80;
        }
        if (indexPath.section == 4)
        {
            return 200;
        }if (indexPath.section == 5) {
            return 44;
        }
    }
    if (tableView == _choiceTableView) {
        
        return 44;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        
        if (indexPath.section == 0)
        {
            PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (!self.model) {
                
                if (_addressModel) {
                    
                    cell.accountName.text = _addressModel.consignee;
                    cell.accountNumber.text = _addressModel.mobile;
                    cell.accountAddress.text = _addressModel.address;
                    
                }else{
                    
                    UITableViewCell *nothingCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nothing"];
                    nothingCell.textLabel.text = @"请选择收货地址";
                    nothingCell.textLabel.font = [UIFont systemFontOfSize:15.0];
                    nothingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return nothingCell;
                }
                
            }
            else{
                
                cell.accountName.text = self.model.consignee;
                cell.accountNumber.text = self.model.mobile;
                cell.accountAddress.text = self.model.address;
                
            }
            
            return cell;
        }
        if (indexPath.section == 1)
        {
            PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
//        if (indexPath.section == 2)
//        {
//            DiscountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
//            if (self.youhuiPrice) {
//                CGFloat youhui = [self.youhuiPrice floatValue];
//                cell.youhuiLabel.text = [NSString stringWithFormat:@"-￥%.2lf",youhui];
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            return cell;
//        }
        if (indexPath.section == 2) {
            
            WDPeisongTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
            NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:@"PEISONGTIME"];
            cell.cellType.text = @"配送时间";
            if (time != nil) {
                
                cell.cellTime.text = time;
                cell.cellTime.textColor = [UIColor blackColor];
            }
            else{
                cell.cellTime.text = @"请选择配送时间";
                cell.cellTime.textColor = [UIColor lightGrayColor];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        
        if (indexPath.section == 3)
        {
            RemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            cell.beizhuTextView.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section == 4)
        {
            DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (_newDataArray.count > 0)
            {
                NSMutableArray * goodArray = _newDataArray[indexPath.row];
                if (goodArray.count > 0)
                {
                    WDChooseGood * model = goodArray[0];
                    cell.shopNameLabel.text = model.shopName;
                    float startPrice = [model.goodStartFee floatValue];
                    
                    int allNum = 0;
                    float price = 0.0;
                    float allPrice = 0.0;
                    
                    NSMutableArray *pics = [NSMutableArray array];
                    for (int i=0; i<goodArray.count; i++)
                    {
                        WDChooseGood * goodModel = goodArray[i];
                        allNum = allNum + [goodModel.goodNum intValue];
                        price = price + [goodModel.goodPrice floatValue] * [goodModel.goodNum floatValue];
                        [pics addObject:goodModel.goodImage];
                       
                    }
                    if (allPrice < startPrice) {
                        allPrice = price + [model.goodDistributePrice floatValue];
                    }
                    allPrice = price;
                    cell.goodPrice.text = [NSString stringWithFormat:@"¥%.2f",price];
                    cell.allPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",allPrice];
                    cell.yunFeiLabel.text = [NSString stringWithFormat:@"¥%@",model.goodDistributePrice];
                    cell.numLabel.text = [NSString stringWithFormat:@"共%d件",allNum];
                    cell.picsArray = pics;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section == 5) {
            WDPeisongTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
            cell.cellType .text = @"优惠券";
            if (_coupon) {
                cell.cellTime.text = [NSString stringWithFormat:@"满%@减%@",_coupon.orderamountlower,_coupon.money];
                cell.cellTime.textColor = [UIColor redColor];
            }else{
                cell.cellTime.text = @"没有可用的优惠券";
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
    if (tableView == _choiceTableView) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"choiceTime"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choiceTime"];
            cell.textLabel.text = _timeDatas[indexPath.row];
        }
        return cell;
    }
    return nil;
}

/** 提交订单*/
- (IBAction)commitClick:(UIButton *)sender
{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    __block NSString *orderId;
    
    WDPayViewController * payVC = [[WDPayViewController alloc]init];
    
    [WDNearStoreManager requestSubmitOrderWithAddressId:self.addressId autoTimeId:_sendTime orderInfo:self.orderinfo buyyerMark:_beizhu completion:^(NSString *osn, NSString *paysn, NSString *error) {
        
        if (error) {
            
            SHOW_ALERT(error)
            [SVProgressHUD dismiss];
            
        }else
        {
            [SVProgressHUD dismiss];
            
            orderId = paysn;
            payVC.orderDic = orderId;
            payVC.price = [NSString stringWithFormat:@"%.2f",_wholePrice];
            payVC.snType = @"2";
            [self.navigationController pushViewController:payVC animated:YES];
            
            // 删除购物车中已选中的商品
            for (int i = 0; i < _newDataArray.count; i ++) {
                
                NSArray *modelArr = _newDataArray[i];
                for (int j = 0; j < modelArr.count; j ++) {
                    
                    WDChooseGood * good = modelArr[j];
                    int goodID = [good.goodID intValue];
                    [WDGoodList deleteGoodWithGoodsId:goodID];
                }
            }
        }
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView) {
        
        if (indexPath.section == 0) {
            
            WDAddressTableVController *addTV = [[WDAddressTableVController alloc]init];
            addTV.sourceType = @"选择收货地址";
            [self.navigationController pushViewController:addTV animated:YES];
        }
//        if (indexPath.section == 2) {
//            
//            WDChooseCouponViewController *unused = [[WDChooseCouponViewController alloc]init];
//            NSString *count = [self.allcount.text substringFromIndex:1];
//            unused.allCount = [count floatValue];
//            
//            [self.navigationController pushViewController:unused animated:YES];
//        }
        if (indexPath.section == 2) {
            
//            [self _popToChoiceView];
            [self _popToPickerView];
            
            
    
//            _choiceTableView.frame = CGRectMake(0, kScreenHeight - (_timeDatas.count+1)*44 - 64, kScreenWidth, (_timeDatas.count+1)*44);
//            [_choiceTableView reloadData];
        }
    }
    if (tableView == _choiceTableView) {
        
        NSString *time = _timeDatas[indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"PEISONGTIME"];
        [_tableView reloadData];
        [_choiceTableView removeFromSuperview];
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView == _choiceTableView) {
        return 44;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == _choiceTableView) {
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        cancelBtn.layer.borderWidth = 0.5;
        cancelBtn.backgroundColor = kViewControllerBackgroundColor;
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cancelBtn;
    }
    else{
        return nil;
    }
}
- (void)cancelBtnClick:(UIButton *)btn{
    
    [_choiceTableView removeFromSuperview];
}

- (void)_popToChoiceView{
    
    _choiceTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _choiceTableView.delegate = self;
    _choiceTableView.dataSource = self;
    _choiceTableView.layer.borderWidth = 0.5;
    _choiceTableView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    
    [self.view addSubview:_choiceTableView];
}

- (void)_popToPickerView{
    
    self.choicePickerView.delegate = self;
    self.choicePickerView.dataSource = self;
    self.choicePickerView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    [self.view addSubview:self.choicePickerView];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _timeDatas.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    if (_timeDatas.count != 0) {
        
        WDSendTimeModel *model = _timeDatas[row];
        NSString *time = model.distributionDesn;
        
        return time;
    }
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_timeDatas.count != 0) {
        
        WDSendTimeModel *model = _timeDatas[row];
        NSString *time = model.distributionDesn;
        _sendTime = model.autotimeid;
        [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"PEISONGTIME"];
        [_tableView reloadData];
        [pickerView removeFromSuperview];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        [textView resignFirstResponder]; //收回键盘
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    _beizhu = textView.text;
    return YES;
}

@end
