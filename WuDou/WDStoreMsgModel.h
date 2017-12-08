//
//  WDStoreMsgModel.h
//  WuDou
//
//  Created by huahua on 16/9/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDStoreMsgModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *storeid, *name, *img, *startvalue, *startfee, *starcount, *isopen;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
