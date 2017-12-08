//
//  WDMainViewController.h
//  WuDou
//
//  Created by huahua on 16/8/4.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "ViewController.h"
#import "WDAppInitManeger.h"
#import "WDMainRequestManager.h"
#import "WDMineManager.h"

@interface WDMainViewController : ViewController

/** 滑动视图*/
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
/** 定位按钮*/
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
/** 搜索框*/
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
/** 扫码按钮*/
//@property (weak, nonatomic) IBOutlet UIButton *scanCode;
/** 聊天按钮*/
//@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chatImage;
/** 顶部视图*/
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 消息图标*/
@property (weak, nonatomic) IBOutlet UIImageView *msgImageView;
/** 定位按钮*/
- (IBAction)locationClick:(UIButton *)sender;
- (IBAction)searchBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *loctionLab;

@property(nonatomic, copy)NSString *mytitle;

/** 模型数据*/
//@property(nonatomic,strong)WDAppInit *appModel;

/** 所有模型数组*/
@property(nonatomic, strong)NSMutableArray *allModelArr;
/** 所有广告数组*/
@property(nonatomic, strong)NSMutableArray *allAdverArr;
//第一个轮播数据数组
@property(nonatomic, strong)NSMutableArray * oneLunArr;
//第二个轮播数据数组
@property(nonatomic, strong)NSMutableArray * twoLunArr;
//特价商品数组
@property(nonatomic, strong)NSMutableArray * teJiaArr;
//第三个轮播数据数组
@property(nonatomic, strong)NSMutableArray * threeLunArr;
/** 附近店铺列表数组*/
@property(nonatomic, strong)NSMutableArray *nearStoreArr;
//第四个轮播数据数组
@property(nonatomic, strong)NSMutableArray * fourLunArr;
//优选商品
@property(nonatomic, strong)NSMutableArray * youXuanArr;
/** 总热点数组*/
@property(nonatomic, strong)NSMutableArray *allNewsArr;
/** 热点数组*/
@property(nonatomic, strong)NSMutableArray *newsArr;

@end
