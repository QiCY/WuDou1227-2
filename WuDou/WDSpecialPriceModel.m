//
//  WDSpecialPriceModel.m
//  WuDou
//
//  Created by huahua on 16/9/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDSpecialPriceModel.h"

@implementation WDSpecialPriceModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        NSString *imageName = [userDic[@"img"]copy];
        _img = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imageName];
        _pid = [userDic[@"pid"]copy];
        _name = [userDic[@"name"]copy];
        _shopprice = [userDic[@"shopprice"]copy];
        _isreviews = [userDic[@"isreviews"]copy];
        _reviews = [userDic[@"reviews"]copy];
        _marketprice = [userDic[@"marketprice"]copy];
    }
    return self ;
}

@end
