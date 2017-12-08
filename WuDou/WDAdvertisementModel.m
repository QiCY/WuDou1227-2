//
//  WDAdvertisementModel.m
//  WuDou
//
//  Created by huahua on 16/9/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDAdvertisementModel.h"

@implementation WDAdvertisementModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        NSString *imageName = [userDic[@"img"]copy];
        _img = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imageName];
        _url = [userDic[@"url"]copy];
        _urltype = [userDic[@"urltype"]copy];
        
    }
    return self ;
}

@end
