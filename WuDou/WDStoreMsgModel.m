//
//  WDStoreMsgModel.m
//  WuDou
//
//  Created by huahua on 16/9/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDStoreMsgModel.h"

@implementation WDStoreMsgModel

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
        _starcount = [userDic[@"starcount"]copy];
        _isopen = [userDic[@"isopen"]copy];
        _isDistributioning = [userDic[@"isDistributioning"]copy];
        _isDistributioningMsg = [userDic[@"isDistributioningMsg"]copy];
        _storemodel = [userDic[@"storemodel"]copy];
        
    }
    return self ;
}


@end
