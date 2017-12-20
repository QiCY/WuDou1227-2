//
//  WDStoreInfoCatesModel.h
//  WuDou
//
//  Created by huahua on 16/9/13.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDStoreInfoCatesModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *cateid, *name, *catenumber,*tag;
@property(nonatomic,strong)NSMutableArray *productsList;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
