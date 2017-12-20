//
//  WDStoreInfosModel.h
//  WuDou
//
//  Created by huahua on 16/9/13.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDStoreInfosModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *storeid, *name, *img, *startvalue, *startfee, *monthlysales, *productscount, *hasfavorite, *hascoupons;
@property(nonatomic,strong)NSString *isopen,*isDistributioning,*isDistributioningMsg,*storemodel;//店铺是否营业（0营业,1歇业），配送范围（0，1，2）店铺类型
+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
