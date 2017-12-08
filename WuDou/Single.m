//
//  Single.m
//  作业－传值代理版
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "Single.h"

static Single *single = nil;

@implementation Single

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (single == nil) {
        
        single = [super allocWithZone:zone];
    }
    return single;
}

-(instancetype)copy{
    
    return single;
}

+(instancetype)shareSingle{
    
    if (single == nil) {
        
        single = [[Single alloc]init];
    }
    return single;
}

@end
