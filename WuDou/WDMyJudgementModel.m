//
//  WDMyJudgementModel.m
//  WuDou
//
//  Created by huahua on 16/12/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMyJudgementModel.h"

@implementation WDMyJudgementModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _username = [userDic[@"username"]copy];
        _pname = [userDic[@"pname"]copy];
        _pid = [userDic[@"pid"]copy];
        _time = [userDic[@"time"]copy];
        _percentage = [userDic[@"percentage"]copy];
        _message = [userDic[@"message"]copy];
        _imgs = [userDic[@"imgs"]copy];
    }
    return self ;
}

@end
