//
//  WDProductsDataModel.m
//  WuDou
//
//  Created by huahua on 16/9/29.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDProductsDataModel.h"

@implementation WDProductsDataModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _pid = [userDic[@"pid"]copy];
        
        NSString *urlStr = [userDic[@"img"]copy];
        _img = [NSString stringWithFormat:@"%@%@",IMAGE_URL,urlStr];
    }
    return self ;
}


@end
