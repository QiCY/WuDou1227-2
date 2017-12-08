//
//  WDScanViewController.m
//  WuDou
//
//  Created by huahua on 16/8/27.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WDAppInitManeger.h"
#import "WDWebViewController.h"
#import "WDGoodsInfoViewController.h"
#import "WDNearDetailsViewController.h"
#import "WDDetailsViewController.h"
#import "WDMoreTejiaViewController.h"

@interface WDScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    UIView * _navView;
    AVCaptureSession *session;
}

@end

@implementation WDScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // 1.创建捕捉会话
    session = [[AVCaptureSession alloc] init];
    
    // 2.设置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:inputDevice];
    
    // 3.设置输入方式
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 4.添加一个显示的layer
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    layer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view.layer addSublayer:layer];
    
    // 5.开始扫描
    [session startRunning];
    [self.view addSubview:self.imageView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [session startRunning];
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
    
    NSString * title = @"扫描二维码";
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
    [session stopRunning];
    [_navView removeFromSuperview];
}


#pragma mark - 获取扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        NSString * urlStr = object.stringValue;
        NSLog(@"%@   %ld", urlStr,urlStr.length);
        if (![urlStr isEqualToString:@""])
        {
            //  判断
            // 跳转到 产品详情页面
            if ([urlStr hasPrefix:@"http://wudoll.com/wodollewm/Products"])
            {
                NSArray * results = [urlStr componentsSeparatedByString:@"-"];
                NSString * proStr = results[results.count - 1];
                NSArray * proStrArr = [proStr componentsSeparatedByString:@"/"];
                NSString * goodsId = proStrArr[0];
                NSLog(@"%@",goodsId);
                WDGoodsInfoViewController *VC = [[WDGoodsInfoViewController alloc] init];
                VC.goodsID = goodsId;
                [WDAppInitManeger saveStrData:goodsId withStr:@"goodID"];
                [self.navigationController pushViewController:VC animated:YES];
                [session stopRunning];
            }
            // 跳转到 店铺详情页面
            if ([urlStr hasPrefix:@"http://wudoll.com/wodollewm/Stores"])
            {
                NSArray * results = [urlStr componentsSeparatedByString:@"-"];
                NSString * proStr = results[results.count - 1];
                NSArray * proStrArr = [proStr componentsSeparatedByString:@"/"];
                NSString * storeId = proStrArr[0];
                
                WDNearDetailsViewController *VC = [[WDNearDetailsViewController alloc] init];
                VC.storeId = storeId;
                [WDAppInitManeger saveStrData:storeId withStr:@"shopID"];
                [self.navigationController pushViewController:VC animated:YES];
                [session stopRunning];
            }
            // 跳转到 单个类别产品列表
            if ([urlStr hasPrefix:@"http://wudoll.com/wodollewm/CategoriesSearch"]) {
                
                NSArray * results = [urlStr componentsSeparatedByString:@"-"];
                NSString * proStr = results[results.count - 1];
                NSArray * proStrArr = [proStr componentsSeparatedByString:@"/"];
                NSString * catenumber = proStrArr[0];
                
                WDDetailsViewController *VC = [[WDDetailsViewController alloc] init];
                VC.numberId = catenumber;
                VC.navtitle = @"搜索列表";
                VC.isCategories = NO;
                [self.navigationController pushViewController:VC animated:YES];
                [session stopRunning];
            }
            // 跳转到 搜索为关键字的搜索结果页面列表
            if ([urlStr hasPrefix:@"http://wudoll.com/wodollewm/SearchLoad"]) {
                
                NSArray * results = [urlStr componentsSeparatedByString:@"-"];
                NSString * proStr = results[results.count - 1];
                NSArray * proStrArr = [proStr componentsSeparatedByString:@"/"];
                NSString * searchKey = proStrArr[0];
                
                WDDetailsViewController *VC = [[WDDetailsViewController alloc] init];
                VC.searchMsg = searchKey;
                VC.navtitle = @"搜索列表";
                VC.isCategories = YES;
                [self.navigationController pushViewController:VC animated:YES];
                [session stopRunning];
            }
            // 跳转到 产品属性列表页面
            if ([urlStr hasPrefix:@"http://wudoll.com/wodollewm/ProductsAttributes"])
            {
                
                NSArray * results = [urlStr componentsSeparatedByString:@"-"];
                NSString * proStr = results[results.count - 1];
                NSArray * proStrArr = [proStr componentsSeparatedByString:@"/"];
                NSString * attrs = proStrArr[0];
                
                //01跳转到 今日特价更多页
                if ([attrs isEqualToString:@"01"]) {
                    
                    WDMoreTejiaViewController *moreVC = [[WDMoreTejiaViewController alloc] init];
                    [self.navigationController pushViewController:moreVC animated:YES];
                    [session stopRunning];
                }
            }
        }
        else{
            // 跳转到对应的链接
            WDWebViewController *webView = [[WDWebViewController alloc] init];
            webView.urlString = urlStr;
            webView.navTitle = @"产品链接";
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
}
@end
