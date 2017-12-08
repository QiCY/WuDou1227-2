
//
//  WDOrderListModel.m
//  WuDou
//
//  Created by huahua on 16/9/29.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDOrderListModel.h"

@implementation WDOrderListModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _storeid = [userDic[@"storeid"]copy];
        _storename = [userDic[@"storename"]copy];
        _paysate = [userDic[@"paysate"]copy];
        _oid = [userDic[@"oid"]copy];
        _osn = [userDic[@"osn"]copy];
        _orderamount = [userDic[@"orderamount"]copy];
        _addtime = [userDic[@"addtime"]copy];
        NSString *urlStr = [userDic[@"orderamount"]copy];
        _storeimg = [NSString stringWithFormat:@"%@%@",IMAGE_URL,urlStr];
        _productsdata = [userDic[@"productsdata"]copy];
        _orderstatusdescription = [userDic[@"orderstatusdescription"]copy];
        _isreviews = [userDic[@"isreviews"]copy];
        _reviewstext = [userDic[@"reviewstext"]copy];
        _isEditshow = [userDic[@"isEditshow"]copy];
        _EditshowText = [userDic[@"EditshowText"]copy];
        _surplusmoney = [userDic[@"surplusmoney"]copy];
        _ordertype = [userDic[@"ordertype"]copy];
        _creditsvalue = [userDic[@"creditsvalue"]copy];
        
    }
    return self ;
}

@end
