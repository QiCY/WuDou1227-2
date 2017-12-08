//
//  WDCountDown.m
//  WuDou
//
//  Created by huahua on 16/12/27.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDCountDown.h"

@interface WDCountDown ()

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation WDCountDown

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)timeChanged{
    
    if (self.second == 0 && self.minute == 0 && self.hour == 0 && self.day == 0) {
        
        self.text = @"0天0时0分";
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    self.second --;
    if (self.second == -1) {
        self.second = 59;
        self.minute --;
        if (self.minute == -1) {
            self.minute = 59;
            self.hour --;
            if (self.hour == -1) {
                self.hour = 23;
                self.day --;
                if (self.day == -1) {
                    
                    self.day = 0;
                }
            }
            
        }
    }
    
    self.text = [NSString stringWithFormat:@"%ld天%ld时%ld分",(long)self.day,(long)self.hour,(long)self.minute];
//    if (self.second == 0 && self.minute == 0 && self.hour == 0 && self.day == 0) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
}

@end
