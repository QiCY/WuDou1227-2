//
//  WDJudgeModel.m
//  WuDou
//
//  Created by huahua on 16/10/17.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDJudgeModel.h"

@implementation WDJudgeModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _star = [userDic[@"star"]copy];
        _username = [userDic[@"username"]copy];
        _message = [userDic[@"message"]copy];
        _time = [userDic[@"time"]copy];
        
    }
    return self ;
}


@end
