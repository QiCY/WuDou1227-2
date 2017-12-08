//
//  WDGoodList.h
//  WuDou
//
//  Created by huahua on 16/9/21.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseUtil.h"
#import "WDChooseGood.h"

@interface WDGoodList : NSObject

//创建表
+(void)creatTable;

//获取所有记录
+(NSMutableArray *)getAllGood;

//插入一条数据 根据一个对象
+(void)insertGood:(WDChooseGood *)good;

//根据商品id查询数据
+(NSMutableArray *)getGoodWithGoodID:(NSString *)goodID;
//根据店铺id查询数据
+(NSMutableArray *)getGoodWithStoreID:(NSString *)storeID;

//根据商品id来删除一条记录
+(void)deleteGoodWithGoodsId:(int)peopleID;

//根据店铺id来删除一条记录
+(void)deleteGoodWithStoreId:(int)peopleID;

// 清空数据库所有记录
+ (void)clearAllDatas;

//跟新一条记录
+(void)upDateGood:(WDChooseGood *)good;

@end
