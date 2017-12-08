//
//  WDCollectCell.h
//  WuDou
//
//  Created by huahua on 16/8/24.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"

@interface WDCollectCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;

@property (weak, nonatomic) IBOutlet UILabel *storeName;

@property (weak, nonatomic) IBOutlet StarView *starView;

@property (weak, nonatomic) IBOutlet UILabel *commentCounts;



@end
