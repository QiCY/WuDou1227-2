//
//  WDSendTimeModel.m
//  WuDou
//
//  Created by huahua on 16/12/15.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDSendTimeModel.h"

@implementation WDSendTimeModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _autotimeid = [userDic[@"autotimeid"]copy];
        _distributionDesn = [userDic[@"distributionDesn"]copy];
    }
    return self;
}

@end
