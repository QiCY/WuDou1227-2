//
//  WDMyCouponModel.m
//  WuDou
//
//  Created by huahua on 16/9/23.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMyCouponModel.h"

@implementation WDMyCouponModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _couponid = [userDic[@"couponid"]copy];
        _couponsn = [userDic[@"couponsn"]copy];
        _money = [userDic[@"money"]copy];
        _orderamountlower = [userDic[@"orderamountlower"]copy];
        _usestarttime = [userDic[@"usestarttime"]copy];
        _useendtime = [userDic[@"useendtime"]copy];
        _sate = [userDic[@"sate"]copy];
    }
    return self ;
}

@end
