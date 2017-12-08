//
//  WDAppInit.m
//  WuDou
//
//  Created by huahua on 16/9/9.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDAppInit.h"

@implementation WDAppInit

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _username = [userDic[@"Username"]copy];
        _regionname = [userDic[@"regionname"]copy];
        _expires_in = [userDic[@"expires_in"]copy];
        _push_alias = [userDic[@"push_alias"]copy];
    }
    return self ;
}

@end
