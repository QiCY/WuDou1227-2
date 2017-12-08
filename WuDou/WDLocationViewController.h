//
//  WDLocationViewController.h
//  WuDou
//
//  Created by huahua on 16/8/16.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDLocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *locTableView;
@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic, copy)NSString * mytitle;

@end
