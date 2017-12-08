//
//  WDCreditProductsModel.m
//  WuDou
//
//  Created by huahua on 16/10/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDCreditProductsModel.h"

@implementation WDCreditProductsModel

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
        _stock = [userDic[@"stock"]copy];
        _exchangecount = [userDic[@"exchangecount"]copy];
        _time = [userDic[@"time"]copy];
        _sate = [userDic[@"sate"]copy];
        _contacts = [userDic[@"contacts"]copy];
        _mobile = [userDic[@"mobile"]copy];
        _reviewedsate = [userDic[@"reviewedsate"]copy];
        _creditsvalue = [userDic[@"creditsvalue"]copy];
        _images = [userDic[@"images"]copy];
    }
    return self ;
}

@end
