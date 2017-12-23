//
//  WDNearbyStoreModel.m
//  WuDou
//
//  Created by huahua on 16/9/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDNearbyStoreModel.h"

@implementation WDNearbyStoreModel

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
        _distance = [userDic[@"distance"]copy];
        _monthlysales = [userDic[@"monthlysales"]copy];
        _startvalue = [userDic[@"startvalue"]copy];
        _startfee = [userDic[@"startfee"]copy];
        _isown = [userDic[@"isown"]copy];
        _discounttitle = [userDic[@"discounttitle"] copy];
        NSArray *disList = [_discounttitle componentsSeparatedByString:@","];
        if (disList.count>2) {
            _isCloseDis = YES;
        }else{
            _isCloseDis = NO;
        }
        _isdiscount=[userDic[@"isdiscount"] copy];
        _star = [userDic[@"star"] intValue];
        _isopen = [userDic[@"isopen"]copy];
        _isDistributioning = [userDic[@"isDistributioning"]copy];
        _isDistributioningMsg = [userDic[@"isDistributioningMsg"]copy];
        _storemodel = [userDic[@"storemodel"]copy];
        self.storesproducts = [userDic[@"stores_products"] copy];
    }
    return self ;
}

@end
