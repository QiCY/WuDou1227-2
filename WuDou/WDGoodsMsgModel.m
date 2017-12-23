//
//  WDGoodsMsgModel.m
//  WuDou
//
//  Created by huahua on 16/9/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDGoodsMsgModel.h"

@implementation WDGoodsMsgModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _pid = [userDic[@"pid"]copy];
        _name = [userDic[@"name"]copy];
        _shopprice = [userDic[@"shopprice"]copy];
        _monthlysales = [userDic[@"monthlysales"]copy];
        _images = [userDic[@"images"]copy];
        
        
        
    }
    return self ;
}


@end
