//
//  WDGetCouponCell.m
//  WuDou
//
//  Created by huahua on 16/9/7.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDGetCouponCell.h"

@implementation WDGetCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsGetCoupon:(BOOL)isGetCoupon{
    
    _isGetCoupon = isGetCoupon;
    
    if (_isGetCoupon) {
        
        [self.getCouponBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [self.getCouponBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.getCouponBtn.enabled = NO;
    }
}


- (IBAction)getCoupons:(UIButton *)sender {
    
    [WDNearStoreManager requestGetCouponWithCouponid:self.couponId completion:^(NSString *result, NSString *error) {
       
        if (error) {
            
            SHOW_ALERT(error)
            return ;
        }
        
        [sender setTitle:@"已领取" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        sender.enabled = NO;
    }];
}

@end
