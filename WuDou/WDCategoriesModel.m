//
//  WDCategoriesModel.m
//  WuDou
//
//  Created by huahua on 16/9/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDCategoriesModel.h"

@implementation WDCategoriesModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _cateid = [userDic[@"cateid"]copy];
        _catenumber = [userDic[@"catenumber"]copy];
        _name = [userDic[@"name"]copy];
        NSString *imageName = [userDic[@"img"]copy];
        _img = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imageName];
    }
    return self ;
}


@end
