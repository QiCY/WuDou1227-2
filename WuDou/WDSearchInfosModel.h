//
//  WDSearchInfosModel.h
//  WuDou
//
//  Created by huahua on 16/9/13.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDSearchInfosModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString * pid, * name, * shopprice, * img, * time, *region, *newsid, *reviewedsate;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
