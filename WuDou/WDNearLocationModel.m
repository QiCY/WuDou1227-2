//
//  WDNearLocationModel.m
//  WuDou
//
//  Created by huahua on 16/10/21.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDNearLocationModel.h"

@implementation WDNearLocationModel


+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _name = [userDic[@"name"]copy];
        _address = [userDic[@"address"]copy];
        _addressinfo = [userDic[@"addressinfo"]copy];
    }
    return self ;
}

@end
