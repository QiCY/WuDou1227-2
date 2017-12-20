//
//  WDStoreInfoCatesModel.m
//  WuDou
//
//  Created by huahua on 16/9/13.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDStoreInfoCatesModel.h"
#import "WDSearchInfosModel.h"
@implementation WDStoreInfoCatesModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _cateid = [userDic[@"cateid"]copy];
        _name = [userDic[@"name"]copy];
        _catenumber = [userDic[@"catenumber"]copy];
        _tag = userDic[@"tag"];
        id obj = userDic[@"products"];
         NSMutableArray *productList = [[NSMutableArray alloc] init];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *productsDic = userDic[@"products"];
            if (productsDic) {
                NSArray *goodsList =productsDic[@"data"];
                for (NSDictionary *data in goodsList) {
                    WDSearchInfosModel *model = [WDSearchInfosModel userWithDictionary:data];
                    [productList addObject:model];
                }
            }
        }
        
        
       
      
      
        _productsList = productList;
    }
    return self;
}

@end
