//
//  WDOrderMsgModel.h
//  WuDou
//
//  Created by huahua on 16/9/29.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDOrderMsgModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *oid, *osn, *addtime, *paysystemtype, *consignee, *mobile, *address, *buyerremark, *orderamount, *paysate, *orderstatusdescription, *distributionDesn, *couponmoney, *productamount, *shipfee, *surplusmoney, *ordertype, *creditsvalue;

/** 数组*/
@property(nonatomic, strong)NSArray *data;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
