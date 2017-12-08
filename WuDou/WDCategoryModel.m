//
//  WDCategoryModel.m
//  WuDou
//
//  Created by huahua on 16/9/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDCategoryModel.h"

@implementation WDCategoryModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _code = [userDic[@"code"]copy];
        _name = [userDic[@"name"]copy];
    
    }
    return self;
}

@end
