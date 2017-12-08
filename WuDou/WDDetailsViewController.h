//
//  WDDetailsViewController.h
//  WuDou
//
//  Created by huahua on 16/8/8.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDAppInitManeger.h"
#import "WDSpeakCategoriesManager.h"

@interface WDDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong)NSMutableArray * dataArray;
/** 搜索内容*/
@property(nonatomic, copy)NSString *searchMsg;

/** navTitle*/
@property(nonatomic, copy)NSString *navtitle;

/** numberId*/
@property(nonatomic, copy)NSString *numberId;

/** 是否为产品搜索yes，为no则为分类搜索*/
@property(nonatomic, assign)BOOL isCategories;

@end
