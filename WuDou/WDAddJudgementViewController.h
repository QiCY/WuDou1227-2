//
//  WDAddJudgementViewController.h
//  WuDou
//
//  Created by huahua on 16/12/3.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMineManager.h"

@interface WDAddJudgementViewController : UIViewController

/** oid*/
@property(nonatomic, copy)NSString *oid;

/** 添加还是查看评论*/
@property(nonatomic, copy)NSString *judgeState;

@end
