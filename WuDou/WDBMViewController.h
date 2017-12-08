//
//  WDBMViewController.h
//  WuDou
//
//  Created by DuYang on 2017/7/9.
//  Copyright © 2017年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDBMViewController : UIViewController

/* 便民服务搜索框 **/
@property (weak, nonatomic) IBOutlet UISearchBar *BMSearchBar;
/* 便民服务下拉列表按钮视图 **/
@property (weak, nonatomic) IBOutlet UIView *BMButtonView;
/* 便民服务tableView **/
@property (weak, nonatomic) IBOutlet UITableView *BMTableView;


@end
