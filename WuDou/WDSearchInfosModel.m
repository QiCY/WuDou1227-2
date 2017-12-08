//
//  WDSearchInfosModel.m
//  WuDou
//
//  Created by huahua on 16/9/13.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDSearchInfosModel.h"

@implementation WDSearchInfosModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _pid = [userDic[@"pid"]copy];
        _name = [userDic[@"name"]copy];
        _shopprice = [userDic[@"shopprice"]copy];
        NSString *imageName = [userDic[@"img"]copy];
        _img = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imageName];
        _time = [userDic[@"time"]copy];
        _region = [userDic[@"region"]copy];
        _newsid = [userDic[@"newsid"]copy];
        _reviewedsate = [userDic[@"reviewedsate"]copy];
    }
    return self;
}

@end
