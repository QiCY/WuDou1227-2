//
//  WDNearbyStoreModel.h
//  WuDou
//
//  Created by huahua on 16/9/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDNearbyStoreModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *storeid, *name, *distance, *img, *monthlysales, *startvalue, *startfee, *isown,*discounttitle,*isdiscount,*isDistributioning,*isDistributioningMsg,*storemodel,*isopen;
@property(nonatomic,strong)NSDictionary *storesproducts;
@property(nonatomic,assign)int star;
@property(nonatomic,assign)BOOL isCloseDis;


+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;


@end
