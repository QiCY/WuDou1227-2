//
//  WDMyCouponModel.h
//  WuDou
//
//  Created by huahua on 16/9/23.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDMyCouponModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *couponid, *couponsn, *money, *orderamountlower, *usestarttime, *useendtime, *sate;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
