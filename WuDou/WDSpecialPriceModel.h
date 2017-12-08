//
//  WDSpecialPriceModel.h
//  WuDou
//
//  Created by huahua on 16/9/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDSpecialPriceModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *pid, *name, *shopprice, *img, *isreviews,*marketprice;

@property(nonatomic, strong)NSDictionary *reviews;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
