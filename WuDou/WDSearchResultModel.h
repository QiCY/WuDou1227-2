//
//  WDSearchResultModel.h
//  WuDou
//
//  Created by huahua on 16/9/13.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDSearchResultModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *storeid, *name, *img, *startvalue, *startfee;

@property(nonatomic, strong)NSDictionary *stores_products;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
