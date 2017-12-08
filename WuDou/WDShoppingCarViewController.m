//
//  WDShoppingCarViewController.m
//  WuDou
//
//  Created by huahua on 16/7/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDShoppingCarViewController.h"
#import "WDCarTableViewCell.h"
#import "WDNearDetailsViewController.h"
#import "WDGoodsInfoViewController.h"
#import "WDAccountViewController.h"
#import "WDGoodList.h"
#import "WDAppInitManeger.h"
#import "WDLoginViewController.h"
#import "WDShopCell.h"

@interface WDShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,WDShopCellDelegate>
{
    NSMutableArray * arr1;
    NSMutableArray * arr2;
    NSMutableArray * arr3;
    
    NSMutableArray * numArr1;
    NSMutableArray * numArr2;
    NSMutableArray * numArr3;
    
    NSMutableArray * allNumArr;
    
    //表头是否选中
    BOOL _isCellSelect[1000];
    //每个section中cell选择个数
    int cellNum;
    
    NSMutableArray * _shopArr;
    NSMutableArray * _goodArr;
    NSMutableArray * _selectArr;
    NSMutableArray * _shopSelectArr;
    
    //总价格
    float _allPrice;
    
    NSMutableArray * _newDataArray;

}

@property(nonatomic,assign)NSInteger allNumber;  //选中多少商品
@property(nonatomic,assign)BOOL isAllSection;  //是否全选
@property(nonatomic,strong)NSMutableArray * allSelectCommody;  //选中多少商品
@property(nonatomic,strong)UIView *noticeView;  //占位图

@end

@implementation WDShoppingCarViewController

- (UIView *)noticeView{
    
    if (!_noticeView) {
        
        _noticeView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _noticeView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _shopArr = [[NSMutableArray alloc]init];
    [self getAllDataArr];

}

-(void)getAllDataArr
{
    
    [_goodArr removeAllObjects];
    NSMutableArray * dataArr = [WDGoodList getAllGood];
    if (dataArr.count != 0)
    {
        if (self.noticeView) {
            [self editAllData:dataArr];
            [self.noticeView removeFromSuperview];
            _tableView.hidden = NO;
        }
//        获取店铺数组
       
        [_tableView reloadData];
    }
    else
    {
        [_tableView reloadData];
        [self _createNodatasIcon];
    }
}
- (void)editAllData:(NSMutableArray *)dataList{
    [_shopArr removeAllObjects];
    NSMutableArray *shopIdList = [[NSMutableArray alloc] init];
    for (WDChooseGood *good in dataList) {
        NSLog(@"good shop id is %@ good name is %@",good.shopID,good.goodName);
        if (![shopIdList containsObject:good.shopID]) {
            WDCarShop * carShop = [[WDCarShop alloc]init];
            carShop.shopID = good.shopID;
            carShop.startFee = good.goodStartFee;
            carShop.shopName = good.shopName;
            carShop.shopImage = good.shopImage;
            [_shopArr addObject:carShop];
            //                carShop.isSelectAll = NO;
            if (good.shopID) {
                 [shopIdList addObject:good.shopID];
            }
           
            NSLog(@"good shop id is ------- %@",good.shopID);
        }
    }
    
    for (int i = 0; i<shopIdList.count; i++) {
        NSMutableArray *goodsList = [[NSMutableArray alloc] init];
        for (WDChooseGood *good in dataList) {
            NSString *shopId = shopIdList[i];
            if ([good.shopID isEqualToString:shopId]) {
                [goodsList addObject:good];
                //                    good.selected = NO;
            }
        }
        WDCarShop *carshop = _shopArr[i];
        
        carshop.goodsList = goodsList;
    }

}
/** 提示暂时数据*/
- (void)_createNodatasIcon{
    
//    [_tableView removeFromSuperview];
    _tableView.hidden = YES;
    
    self.noticeView.frame = CGRectMake(0, 0, 70, 60);
    self.noticeView.center = self.view.center;
    self.noticeView.centerY = self.view.centerY - 100;
    [self.view addSubview:self.noticeView];
    
    UIImageView *noticeImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 33)];
    noticeImage.image = [UIImage imageNamed:@"noData"];
    [self.noticeView addSubview:noticeImage];
    
    UILabel *noticeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 70, 20)];
    noticeText.text = @"暂无商品";
    noticeText.font = [UIFont systemFontOfSize:15.0];
    noticeText.textAlignment = NSTextAlignmentCenter;
    noticeText.textColor = [UIColor lightGrayColor];
    [self.noticeView addSubview:noticeText];
}



-(void)viewDidDisappear:(BOOL)animated
{
  
    _isAllSection = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _setupNav];
    
    cellNum = 0;
    self.allSelectCommody = [[NSMutableArray alloc]init];
    _allNumber = 1;
//    [self.tableView registerNib:[UINib nibWithNibName:@"WDShopCell" bundle:nil] forCellReuseIdentifier:@"Ccell"];
    [self.tableView registerClass:[WDShopCell class] forCellReuseIdentifier:@"Ccell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.commitClick setBackgroundColor:KSYSTEM_COLOR];
}

- (void)_setupNav{
    
    [self.navigationItem setHidesBackButton:YES];
    
    //  右侧删除按钮
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 20)];
//    [rightBtn setImage:[UIImage imageNamed:@"shanchu2"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(deleteAllClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}
/** 删除购物车选中的商品*/
- (void)deleteAllClick:(UIButton *)btn{
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"删除所选中的商品？  " message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:cancelBtn];
    
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
      
        
       
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (WDCarShop *shop in _shopArr) {
            for (WDChooseGood *good in shop.goodsList) {
                if (good.selected) {
                    [array addObject:good];
                }
                
            }
        }
        
        if (array.count != 0) {
            
            for (int i = 0; i < array.count; i ++) {
                
                WDChooseGood * model = array[i];
                NSString *goodsId = model.goodID;
                [WDGoodList deleteGoodWithGoodsId:[goodsId intValue]];  //根据商品id删除所选商品
                
            }
            
            
            [self getAllDataArr];
            [self getAllMoney];
//            [self _setXuanZhonGoodPrice];
            self.allSelectImage.image = [UIImage imageNamed:@"不打勾"];
            
        }else{
            
            SHOW_ALERT(@"未勾选商品")
        }
    
        
    }];
    [alertView addAction:sureBtn];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - tableview协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    WDCarShop *car = _shopArr[section];
    return _shopArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDShopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Ccell"];
   
    WDCarShop *shop = _shopArr[indexPath.row];
    
    [cell setShop:shop target:self];
    
    if (indexPath.row == _shopArr.count - 1 && _shopArr.count>0) {
        cell.footer.hidden = YES;
    }else{
        cell.footer.hidden = NO;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WDCarShop *shop = _shopArr[indexPath.row];
    WDNearDetailsViewController * detailsVC = [[WDNearDetailsViewController alloc]init];
        
        WDCarShop * carShop = shop;
        detailsVC.storeId = carShop.shopID;
        [WDAppInitManeger saveStrData:carShop.shopID withStr:@"shopID"];

    [self.navigationController pushViewController:detailsVC animated:YES];
    
//    WDGoodsInfoViewController *goodsInfoVC = [[WDGoodsInfoViewController alloc]init];
//    WDCarShop *shop = _shopArr[indexPath.section];
//    WDChooseGood * good = shop.goodsList[indexPath.row];
//    NSString * goodID = good.goodID;
//    [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
//    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

#pragma mark ShopCarCellDelegate
- (void)didClickedGoodBtn:(WDChooseGood *)good
{
    WDGoodsInfoViewController *goodsInfoVC = [[WDGoodsInfoViewController alloc]init];
    NSString * goodID = good.goodID;
    [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}
- (void)didClickedDeleteBtn:(WDCarShop *)shop
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"删除所选中的商品？  " message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:cancelBtn];
    
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        for (int i = 0; i < shop.goodsList.count; i ++) {
            WDChooseGood * model = shop.goodsList[i];
            NSString *goodsId = model.goodID;
            [WDGoodList deleteGoodWithGoodsId:[goodsId intValue]];  //根据商品id删除所选商品
        }
        [_shopArr removeObject:shop];
        [self.tableView reloadData];
        
    }];
    [alertView addAction:sureBtn];
    
    [self presentViewController:alertView animated:YES completion:nil];
    
    
}
- (void)didClickedPayBtn:(WDCarShop *)shop
{
    [self submitOrderWithShop:shop];
}
#pragma mark CarCellDelegate
- (void)selectBtnClicked:(WDChooseGood *)good indexPath:(NSIndexPath *)indexPath
{
    WDCarShop *car = _shopArr[indexPath.section];
   car.isSelectAll = [self shopIsSelectAll:car];
   [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)addBtnClicked:(WDChooseGood *)good indexPath:(NSIndexPath *)indexPath
{
    int num = [good.goodNum intValue];
    num++;
    good.goodNum = [NSString stringWithFormat:@"%d",num];
    [WDGoodList upDateGood:good];
    WDCarShop *car = _shopArr[indexPath.section];
   car.isSelectAll = [self shopIsSelectAll:car];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)deleteBtnClicked:(WDChooseGood *)good indexPath:(NSIndexPath *)indexPath
{
    WDCarShop *car = _shopArr[indexPath.section];
    int num = [good.goodNum intValue];
    num--;
    if (num == 0) {
         [WDGoodList deleteGoodWithGoodsId:[good.goodID intValue]];
        [car.goodsList removeObject:good];
        car.isSelectAll = [self shopIsSelectAll:car];
        [self isAllSelect];
        if (car.goodsList.count == 0) {
            [_shopArr removeObject:car];
            [self.tableView reloadData];
        }else{
            car.isSelectAll = [self shopIsSelectAll:car];
            [self isAllSelect];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else{
       
        good.goodNum = [NSString stringWithFormat:@"%d",num];
        [WDGoodList upDateGood:good];
        car.isSelectAll = [self shopIsSelectAll:car];
        [self isAllSelect];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
}
- (BOOL)shopIsSelectAll:(WDCarShop *)shop{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (WDChooseGood *good in shop.goodsList) {
        if (good.selected) {
            [list addObject:good];
        }
    }
    [self getAllMoney];
    if (list.count == shop.goodsList.count) {
        return YES;
    }else{
        return NO;
    }
}


//section上的选中按钮
-(void)seleClick:(UIButton *)btn
{
    WDCarShop *car = _shopArr[btn.tag];
    car.isSelectAll = !car.isSelectAll;
    for (WDChooseGood *good in car.goodsList) {
        good.selected = car.isSelectAll;
    }
    [self isAllSelect];
    [self getAllMoney];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationNone];
}

//跳转到商店详情
-(void)goShop:(UIButton *)btn
{
    WDNearDetailsViewController * detailsVC = [[WDNearDetailsViewController alloc]init];
    if (_shopArr.count > 0) {
        
        WDCarShop * carShop = _shopArr[btn.tag];
        detailsVC.storeId = carShop.shopID;
        [WDAppInitManeger saveStrData:carShop.shopID withStr:@"shopID"];
    }
    
    [self.navigationController pushViewController:detailsVC animated:YES];
}




//全选按钮
- (IBAction)allSelectClick:(UIButton *)sender
{
    _isAllSection = !_isAllSection;
    [self allSelectOrDisSelect:_isAllSection];
    [self getAllMoney];
}

- (void)allSelectOrDisSelect:(BOOL)all{
    NSMutableArray * dataArr = [WDGoodList getAllGood];
    for (WDChooseGood *good in dataArr) {
        good.selected = all;
    }
    if (all) {
        self.allSelectImage.image = [UIImage imageNamed:@"打钩"];
    }else{
         self.allSelectImage.image = [UIImage imageNamed:@"不打勾"];
    }

    [self editAllData:dataArr];
    for (WDCarShop *shop in _shopArr) {
        shop.isSelectAll = [self shopIsSelectAll:shop];
    }
    
    [self.tableView reloadData];
}

- (void)getAllMoney{
    float totalMoney = 0;
    for (WDCarShop *shop in _shopArr) {
        for (WDChooseGood *good in shop.goodsList) {
            if (good.selected) {
                totalMoney = totalMoney + [good.goodPrice floatValue] * [good.goodNum floatValue];
            }
            
        }
    }
    _allPrice = totalMoney;
    _zonPrice.text = [NSString stringWithFormat:@"¥%.2f",totalMoney];
    _noYunFeiLabel.text = [NSString stringWithFormat:@"¥%.2f(不含运费)",_allPrice];
}
//判断是否全选
-(void)isAllSelect
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (WDCarShop *shop in _shopArr) {
        for (WDChooseGood *good in shop.goodsList) {
            if (good.selected) {
                [array addObject:good];
            }
            
        }
    }
    NSMutableArray * dataArr = [WDGoodList getAllGood];
    if (dataArr.count == array.count) {
        _isAllSection = YES;
        self.allSelectImage.image = [UIImage imageNamed:@"打钩"];
        
    }else{
        _isAllSection = NO;
        self.allSelectImage.image = [UIImage imageNamed:@"不打勾"];
    }
}

- (void)submitOrderWithShop:(WDCarShop *)shop{
    //  判断是否登陆
    [WDMineManager requestLoginEnabledWithCompletion:^(NSString *resultRet) {
        
        if ([resultRet isEqualToString:@"0"])
        {
            WDAccountViewController * accountVC = [[WDAccountViewController alloc]init];
            NSMutableString *orderStr = [NSMutableString string];
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for (WDChooseGood *good in shop.goodsList) {
                NSString *str = [NSString stringWithFormat:@"%@,%@",good.goodID,good.goodNum];
                [orderStr appendFormat:@"%@$",str];
                [dataArray addObject:good];
            }
//            if ([self checkOrderIsCanSubmit:shop]) {
                if (dataArray.count>0) {
                    NSString *orderInfo = [orderStr substringToIndex:orderStr.length - 1];
                    accountVC.orderinfo = orderInfo;
                    accountVC.dataArray = dataArray;
                    [self.navigationController pushViewController:accountVC animated:YES];
                }
//                else
//                {
//
//                    SHOW_ALERT(@"未勾选商品")
//                }
//            }
        }
        else
        {
            WDLoginViewController *loginVC = [[WDLoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        
    }];
}
- (IBAction)commitClick:(UIButton *)sender
{
    //  判断是否登陆
    [WDMineManager requestLoginEnabledWithCompletion:^(NSString *resultRet) {
        
        if ([resultRet isEqualToString:@"0"])
        {
            
            WDAccountViewController * accountVC = [[WDAccountViewController alloc]init];
            NSMutableString *orderStr = [NSMutableString string];
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for (WDCarShop *shop in _shopArr) {
                for (WDChooseGood *good in shop.goodsList) {
                    if (good.selected) {
                        NSString *str = [NSString stringWithFormat:@"%@,%@",good.goodID,good.goodNum];
                        [orderStr appendFormat:@"%@$",str];
                        [dataArray addObject:good];
                    }
                    
                }
            }
            if ([self setQiSonShopWith:_shopArr]) {
                if (dataArray.count>0) {
                    NSString *orderInfo = [orderStr substringToIndex:orderStr.length - 1];
                    accountVC.orderinfo = orderInfo;
                    accountVC.dataArray = dataArray;
                    [self.navigationController pushViewController:accountVC animated:YES];
                }else
                {
                    
                    SHOW_ALERT(@"未勾选商品")
                }
            }
           

        }
        else
        {
            WDLoginViewController *loginVC = [[WDLoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        
    }];
}

- (BOOL)checkOrderIsCanSubmit:(WDCarShop *)shop{
    float price = 0;
    float startFee = 0;
    for (WDChooseGood *good in shop.goodsList) {
       
        price = price + [good.goodPrice floatValue] * [good.goodNum intValue];
        
        startFee = [good.goodStartFee floatValue];
    }
    if (price<startFee) {
        NSString * message = [NSString stringWithFormat:@"商铺“%@”未达到起送价格!",shop.shopName];
        SHOW_ALERT(message);
        return NO;
    }
    return YES;
}
//计算选中店铺是否满足起送价
-(BOOL)setQiSonShopWith:(NSMutableArray *)dataArray
{
    for (WDCarShop *shop in _shopArr) {
        float price = 0;
        float startFee = 0;
        for (WDChooseGood *good in shop.goodsList) {
            if (good.selected) {
                price = price + [good.goodPrice floatValue] * [good.goodNum intValue];
            }
            startFee = [good.goodStartFee floatValue];
        }
        if (price == 0) {
            return YES;
        }
        if (price<startFee) {
            NSString * message = [NSString stringWithFormat:@"商铺“%@”未达到起送价格!",shop.shopName];
            SHOW_ALERT(message);
            return NO;
        }
    }
    return YES;
    
   
}

@end
