//
//  WDSendTimeModel.h
//  WuDou
//
//  Created by huahua on 16/12/15.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDSendTimeModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *autotimeid, *distributionDesn;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
