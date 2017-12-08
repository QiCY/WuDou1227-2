//
//  WDNewsModel.h
//  WuDou
//
//  Created by huahua on 16/12/7.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDNewsModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *title, *newsid;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
