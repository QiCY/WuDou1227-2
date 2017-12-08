
//
//  WDOrderMsgModel.m
//  WuDou
//
//  Created by huahua on 16/9/29.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDOrderMsgModel.h"

@implementation WDOrderMsgModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _paysystemtype = [userDic[@"paysystemtype"]copy];
        _consignee = [userDic[@"consignee"]copy];
        _paysate = [userDic[@"paysate"]copy];
        _oid = [userDic[@"oid"]copy];
        _osn = [userDic[@"osn"]copy];
        _orderamount = [userDic[@"orderamount"]copy];
        _addtime = [userDic[@"addtime"]copy];
        _mobile = [userDic[@"mobile"]copy];
        _address = [userDic[@"address"]copy];
        _buyerremark = [userDic[@"buyerremark"]copy];
        _data = [userDic[@"data"]copy];
        _orderstatusdescription = [userDic[@"orderstatusdescription"]copy];
        _distributionDesn = [userDic[@"distributionDesn"]copy];
        _couponmoney = [userDic[@"couponmoney"]copy];
        _productamount = [userDic[@"productamount"]copy];
        _shipfee = [userDic[@"shipfee"]copy];
        _surplusmoney = [userDic[@"surplusmoney"]copy];
        _ordertype = [userDic[@"ordertype"]copy];
        _creditsvalue = [userDic[@"creditsvalue"]copy];
    }
    return self ;
}


@end
