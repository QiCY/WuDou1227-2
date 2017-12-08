//
//  WDNewsModel.m
//  WuDou
//
//  Created by huahua on 16/12/7.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDNewsModel.h"

@implementation WDNewsModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _title = [userDic[@"title"]copy];
        _newsid = [userDic[@"newsid"]copy];
    }
    return self ;
}

@end
