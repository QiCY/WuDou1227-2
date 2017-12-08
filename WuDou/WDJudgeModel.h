//
//  WDJudgeModel.h
//  WuDou
//
//  Created by huahua on 16/10/17.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDJudgeModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *star, *username, *message, *time;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
