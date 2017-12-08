//
//  WDPayViewController.m
//  WuDou
//
//  Created by huahua on 16/8/11.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDPayViewController.h"
#import "WDPayTableViewCell.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WDMyOrderViewController.h"

#import "WXApi.h"

@interface WDPayViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView * _navView;
    NSString *_signOrderString;
}


@end

@implementation WDPayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"WDPayTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];  //注册xib
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setNavTabUI];
}

-(void)setNavTabUI
{
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navView.backgroundColor = KSYSTEM_COLOR;
    [[UIApplication sharedApplication].keyWindow addSubview:_navView];
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 31, 15, 20)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backBtn];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 100, 31, 200, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"支付方式";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_navView addSubview:titleLabel];
}

-(void)backClick
{
    WDMyOrderViewController *orderVC = [[WDMyOrderViewController alloc]init];
    orderVC.istype = 1;
    [self.navigationController pushViewController:orderVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_navView removeFromSuperview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDPayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0)
    {
        cell.logoImage.image = [UIImage imageNamed:@"支付宝"];
        cell.nameLabel.text = @"支付宝支付";
        cell.introLabel.text = @"支付宝支付快捷安全方便";
    }
    if (indexPath.row == 0)
    {
        cell.logoImage.image = [UIImage imageNamed:@"微信"];
        cell.nameLabel.text = @"微信支付";
        cell.introLabel.text = @"微信支付快捷安全方便";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == 1) {
        
        [WDNearStoreManager requestSignWordWithPayType:@"1" oid:self.orderDic signType:self.snType completion:^(NSString *signStr, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            _signOrderString = signStr;
            [self buyProduct];
        }];
    }
    
    if (indexPath.row == 0) {
        
        [WDNearStoreManager requestSignWordWithPayType:@"2" oid:self.orderDic signType:self.snType completion:^(NSString *signStr, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            _signOrderString = signStr;
            [self weixinPay];
        }];
    }
    
}
#pragma mark - 微信支付
-(void)weixinPay
{
    PayReq *request = [[PayReq alloc] init];
    NSArray * array = [_signOrderString componentsSeparatedByString:@"&"];
    NSString * noncestr = [array[1] componentsSeparatedByString:@"="][1];
    NSString * prepayid = [array[4]componentsSeparatedByString:@"="][1];
    NSString * sign = [array[5]componentsSeparatedByString:@"="][1];
    NSString * timestamp = [array[6]componentsSeparatedByString:@"="][1];
    NSLog(@"no == %@, id == %@, sign == %@, time == %@",noncestr, prepayid,sign,timestamp);
    /** 商家向财付通申请的商家id */
    request.partnerId = @"1448762102";
    /** 预支付订单 */
    request.prepayId= prepayid;
    /** 商家根据财付通文档填写的数据和签名 */
    request.package = @"Sign=WXPay";
    /** 随机串，防重发 */
    request.nonceStr= noncestr;
    /** 时间戳，防重发 */
    request.timeStamp = [timestamp intValue];
    /** 商家根据微信开放平台文档对数据做的签名 */
    request.sign= sign;
    /*! @brief 发送请求到微信，等待微信返回onResp
     *
     * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
     * SendAuthReq、SendMessageToWXReq、PayReq等。
     * @param req 具体的发送请求，在调用函数后，请自己释放。
     * @return 成功返回YES，失败返回NO。
     */
    [WXApi sendReq: request];
    
}


#pragma mark - 重要:购买商品的过程
- (void)buyProduct{
    // 1.签约后获取到的商户ID和账号ID和私钥
    NSString *partner = @"2088221868910638";
    NSString *seller = @"2886855@qq.com";
    NSString *privateKey = @"MIICXQIBAAKBgQDEfVCCBJdZ4aDblsj7zZC5KPBfeBuH6v55eqpeFK3y+yfF2nzIabPs6GNRP+hbl52xpQkEqas2qBiTVSjgBlHwr4mpejoRj8YFzsmoWQFRqATGeRMhuVpAxcBK9C6dlyNKeMScgraqNd3yqz2cqCwoo/Ns/UbAuAna5gRrPQ+OsQIDAQABAoGAe53XW6Ulzz9bIyuPEJP4e/UcnQOEVpNqO+UHcB8UfOyzzg8yOCgAMYjWixRoy87sQAnzTYKtG7rPk0mdaKuxOl76xa/4uHfD4L3+WX8HwVnxSOs3esgyVt/kEVQcfdSZFK/wxI6PGXIYWtWfcNskmGxammhehzeEzuM5pDTJbRECQQD02nA5CBsfv2vYvO9tQFsicl7mJqKqxEF5c9sxeD3mEwfZtesAVLZ53sqyElh84lMmhwIHV+5BNSUcQsRIxDSlAkEAzW88kMwVfdnU+kvIhxyfdlAINtY7K6+203rEI4K1sNvyxKymxaVf7geITHQpiRCtZJ5jgQHEovnmJjELMdO4HQJBAJ4W82I/U5P5+d3kjwoRBUaGZbNfuqNbN5L9NMcKBZ0pKGZuyJ5cE704FdNHeQ6Y6mrzvGGVamV7tMw8Z5M762kCQQDGt40ce21mmWm828WTfIp7hZsMgFooPgZZtu03dF6QP5Ir0N5ZXUjYFQ0w90SeQzWWmOejiLRO+fA4jURI5IW5AkBg0SW2knGmXsv9PrcCVQqsG/CwvocXbUhYQbvTK9dJy5iXYlqtOq2A04xLNFMLDA65YxQvkGCL3QFlC+FaQM6v";
    
    // 2.生成订单
    // 2.1.创建订单对象
    Order *order = [[Order alloc] init];
    // 2.2.设置商户ID和账号ID
    order.partner = partner;
    order.seller = seller;
    // 2.3.设置订单号(公司自己的算法决定)
    order.tradeNO = self.orderDic;
    // 2.4.设置商品相关的信息
    order.productName = _product.name; //商品标题
    order.productDescription = _product.detail; //商品描述
//    order.amount = self.price; //商品价格
    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    // 2.5.设置支付宝服务器回调我们服务器的URL
    order.notifyURL =  @"www.wudoll.com"; //回调URL
    // 2.6.规定写法
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"10m";
    order.showUrl = @"m.alipay.com";
    
    // 3.添加应用程序的URL Scheme
    NSString *urlScheme = @"wudou";
    
    // 4.将定义信息拼接成一个字符串
    NSString *orderString = [order description];
    
    // 5.对订单进行签名加密
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderString];
    
    // 6.将前面后的字符串格式化为固定格式的订单字符串
    NSString *signedOrderString = _signOrderString;
    
    // 7.调用支付宝客户端,让用户进行支付
    // 7.1.如果没有安装支付宝客户端,则会弹出webView让用户输入支付宝的账号和密码进行支付.如果是该情况,则会回调下面的block
    // 7.2.如果用户有安装支付宝客户端,则会跳转支付宝客户端进行支付
    //支付宝网页支付设置，显示UIWindow窗口
    NSArray *array = [[UIApplication sharedApplication] windows];
    UIWindow *win=[array objectAtIndex:0];
    [win setHidden:NO];
    
    [[AlipaySDK defaultService] payOrder:signedOrderString fromScheme:urlScheme callback:^(NSDictionary *resultDic) {
//        NSLog(@"reslut = %@",resultDic);
        
//        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"支付成功，去查看订单" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//            WDMyOrderViewController *orderVC = [[WDMyOrderViewController alloc]init];
//            orderVC.istype = 1;
//            [self.navigationController pushViewController:orderVC animated:YES];
//        }];
//        [alertView addAction:cancelBtn];
//        [self presentViewController:alertView animated:YES completion:nil];
        
        WDMyOrderViewController *orderVC = [[WDMyOrderViewController alloc]init];
        orderVC.istype = 1;
        [self.navigationController pushViewController:orderVC animated:YES];
        
    }];
}

#pragma mark   ==============产生随机订单号==============
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
