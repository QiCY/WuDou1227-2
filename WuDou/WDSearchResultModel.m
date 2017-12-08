//
//  WDSearchResultModel.m
//  WuDou
//
//  Created by huahua on 16/9/13.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDSearchResultModel.h"

@implementation WDSearchResultModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        NSString *imageName = [userDic[@"img"]copy];
        _img = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imageName];
        _storeid = [userDic[@"storeid"]copy];
        _name = [userDic[@"name"]copy];
        _startvalue = [userDic[@"startvalue"]copy];
        _startfee = [userDic[@"startfee"]copy];
        _stores_products = [userDic[@"stores_products"]copy];
        
    }
    return self ;
}

@end
