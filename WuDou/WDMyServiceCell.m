//
//  WDMyServiceCell.m
//  WuDou
//
//  Created by huahua on 16/10/20.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMyServiceCell.h"

@implementation WDMyServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsCheak:(NSString *)isCheak{
    
    _isCheak = isCheak;
    
    if ([_isCheak isEqualToString:@"0"]) {
        
        self.serviceChecked.text = @"已审核";
    }
    else if ([_isCheak isEqualToString:@"1"]){
        
        self.serviceChecked.text = @"未审核";
    }
}

@end
