//
//  WDLeaderboardModel.h
//  WuDou
//
//  Created by huahua on 16/10/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDLeaderboardModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *code, *name, *creditvalue;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
