//
//  WDMyJudgementModel.h
//  WuDou
//
//  Created by huahua on 16/12/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDMyJudgementModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *username, *pname, *pid, *time, *percentage, *message;

@property(nonatomic, strong)NSArray *imgs;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
