//
//  WDProductsDataModel.h
//  WuDou
//
//  Created by huahua on 16/9/29.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDProductsDataModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *pid, *img;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
