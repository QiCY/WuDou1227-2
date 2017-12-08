//
//  WDLoadAddressModel.m
//  WuDou
//
//  Created by huahua on 16/9/19.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDLoadAddressModel.h"

@implementation WDLoadAddressModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _said = [userDic[@"said"]copy];
        _consignee = [userDic[@"consignee"]copy];
        _mobile = [userDic[@"mobile"]copy];
        _address = [userDic[@"address"]copy];
        _addressmark = [userDic[@"addressmark"]copy];
    }
    return self ;
}

@end
