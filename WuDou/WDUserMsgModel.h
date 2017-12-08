//
//  WDUserMsgModel.h
//  WuDou
//
//  Created by huahua on 16/9/19.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDUserMsgModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *username, *avatar, *credits, *sex;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
