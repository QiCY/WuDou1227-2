//
//  WDMyCollectModel.m
//  WuDou
//
//  Created by huahua on 16/9/19.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMyCollectModel.h"

@implementation WDMyCollectModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _recordid = [userDic[@"recordid"]copy];
        NSString *imageName = [userDic[@"img"]copy];
        _img = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imageName];
        _url = [userDic[@"url"]copy];
        _urlType = [userDic[@"urltype"]copy];
        _name = [userDic[@"name"]copy];
        _starcount = [userDic[@"starcount"]copy];
        _commentcount = [userDic[@"commentcount"]copy];
        _productcount = [userDic[@"productcount"]copy];
        _monthlysales = [userDic[@"monthlysales"]copy];
    }
    return self ;
}

@end
