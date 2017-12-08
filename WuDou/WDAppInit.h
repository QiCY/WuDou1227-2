//
//  WDAppInit.h
//  WuDou
//
//  Created by huahua on 16/9/9.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDAppInit : NSObject


/** 属性*/
@property(nonatomic, copy)NSString *username, *regionname, *expires_in, *push_alias;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
