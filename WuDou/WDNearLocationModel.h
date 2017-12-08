//
//  WDNearLocationModel.h
//  WuDou
//
//  Created by huahua on 16/10/21.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDNearLocationModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *name, *address, *addressinfo;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
