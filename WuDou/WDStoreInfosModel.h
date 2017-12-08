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

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
