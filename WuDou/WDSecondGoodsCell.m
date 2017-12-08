//
//  WDSecondGoodsCell.m
//  WuDou
//
//  Created by huahua on 16/8/24.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDSecondGoodsCell.h"


@implementation WDSecondGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsCheck:(NSString *)isCheck{
    
    _isCheck = isCheck;
    
    if ([_isCheck isEqualToString:@"0"]) {
        
        self.isChecked.text = @"已审核";
    }
    else if ([_isCheck isEqualToString:@"1"]){
        
        self.isChecked.text = @"未审核";
    }
}

@end
