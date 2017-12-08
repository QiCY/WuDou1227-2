
//
//  WDLeaderboardModel.m
//  WuDou
//
//  Created by huahua on 16/10/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDLeaderboardModel.h"

@implementation WDLeaderboardModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _name = [userDic[@"name"]copy];
        _code = [userDic[@"code"]copy];
        _creditvalue = [userDic[@"creditvalue"]copy];
        
    }
    return self ;
}

@end
