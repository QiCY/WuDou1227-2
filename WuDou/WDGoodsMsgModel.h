//
//  WDGoodsMsgModel.h
//  WuDou
//
//  Created by huahua on 16/9/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDGoodsMsgModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *pid, *name, *shopprice, *monthlysales;

@property(nonatomic, strong)NSDictionary *images;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
