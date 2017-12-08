//
//  WDGoodList.m
//  WuDou
//
//  Created by huahua on 16/9/21.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDGoodList.h"

@implementation WDGoodList

//创建表
+(void)creatTable
{
    //通过DataBaseUtil 方法获取数据库对象
    FMDatabase * db=[DataBaseUtil getDateBase];
    if (![db open])
    {
        [db close];
        NSLog(@"打开数据库失败");
        return;
    }
    //设置缓存 为了提高效率
    [db setShouldCacheStatements:YES];
    // 创建  更新  删除 插入 upDate 查询 query
    if (![db tableExists:@"peopleTable"])
    {
        [db executeUpdate:@"create table if not exists peopleTable(id integer primary key autoincrement,goodName text,goodID text,goodPrice text,goodNum text,goodStartFee text, goodDistributePrice text,goodImage text,shopID text,shopName text,shopImage text)"];
    }
    //关闭数据库
    [db close];
}

//获取所有记录
+(NSMutableArray *)getAllGood
{
    //获取数据库对象
    FMDatabase * db=[DataBaseUtil getDateBase];
    if (![db open])
    {
        [db close];
        return nil;
    }
    //查询语句 查询的是一个结果集 FMResultSet
    FMResultSet *set=[db executeQuery:@"select * from peopleTable"];
    NSMutableArray * array=[[NSMutableArray alloc]initWithCapacity:0];
    while ([set next])
    {
        WDChooseGood * good=[[WDChooseGood alloc]init];
        good.goodID=[set stringForColumn:@"goodID"];
        good.goodNum=[set stringForColumn:@"goodNum"];
        good.goodName=[set stringForColumn:@"goodName"];
        good.goodPrice = [set stringForColumn:@"goodPrice"];
        good.goodStartFee = [set stringForColumn:@"goodStartFee"];
        good.goodImage = [set stringForColumn:@"goodImage"];
        good.shopID = [set stringForColumn:@"shopID"];
        good.shopName = [set stringForColumn:@"shopName"];
        good.shopImage = [set stringForColumn:@"shopImage"];
        good.goodDistributePrice = [set stringForColumn:@"goodDistributePrice"];
        
        [array addObject:good];
    }
    [set close];
    [db close];
    return array;
}

//根据商品id查询数据
+(NSMutableArray *)getGoodWithGoodID:(NSString *)goodID
{
    //获取数据库对象
    FMDatabase * db=[DataBaseUtil getDateBase];
    if (![db open])
    {
        [db close];
        return nil;
    }
    //查询语句 查询的是一个结果集 FMResultSet
    FMResultSet *set=[db executeQuery:@"select * from peopleTable where goodID=?", goodID];
    NSMutableArray * array=[[NSMutableArray alloc]initWithCapacity:0];
    while ([set next])
    {
        WDChooseGood * good=[[WDChooseGood alloc]init];
        good.goodID=[set stringForColumn:@"goodID"];
        good.goodNum=[set stringForColumn:@"goodNum"];
        good.goodName=[set stringForColumn:@"goodName"];
        good.goodPrice = [set stringForColumn:@"goodPrice"];
        good.goodStartFee = [set stringForColumn:@"goodStartFee"];
        good.goodDistributePrice = [set stringForColumn:@"goodDistributePrice"];
        good.shopID = [set stringForColumn:@"shopID"];
        good.shopName = [set stringForColumn:@"shopName"];
        good.goodImage = [set stringForColumn:@"goodImage"];
        good.shopImage = [set stringForColumn:@"shopImage"];
        [array addObject:good];
    }
    [set close];
    [db close];
    return array;
}

//根据店铺id查询数据
+(NSMutableArray *)getGoodWithStoreID:(NSString *)storeID
{
    //获取数据库对象
    FMDatabase * db=[DataBaseUtil getDateBase];
    if (![db open])
    {
        [db close];
        return nil;
    }
    //查询语句 查询的是一个结果集 FMResultSet
    FMResultSet *set=[db executeQuery:@"select * from peopleTable where shopID=?", storeID];
    NSMutableArray * array=[[NSMutableArray alloc]initWithCapacity:0];
    while ([set next])
    {
        WDChooseGood * good=[[WDChooseGood alloc]init];
        good.goodID=[set stringForColumn:@"goodID"];
        good.goodNum=[set stringForColumn:@"goodNum"];
        good.goodName=[set stringForColumn:@"goodName"];
        good.goodPrice = [set stringForColumn:@"goodPrice"];
        good.goodStartFee = [set stringForColumn:@"goodStartFee"];
        good.goodDistributePrice = [set stringForColumn:@"goodDistributePrice"];
        good.shopID = [set stringForColumn:@"shopID"];
        good.shopName = [set stringForColumn:@"shopName"];
        good.goodImage = [set stringForColumn:@"goodImage"];
        good.shopImage = [set stringForColumn:@"shopImage"];
        
        
        [array addObject:good];
    }
    [set close];
    [db close];
    return array;
}

//插入一条数据 根据一个对象
+(void)insertGood:(WDChooseGood *)good
{
    //获取数据库对象
    FMDatabase * db=[DataBaseUtil getDateBase];
    if (![db open])
    {
        [db close];
        return ;
    }
    [db setShouldCacheStatements:YES];
    [db executeUpdate:@"insert into peopleTable (goodName,goodNum,goodID,goodPrice,goodStartFee,goodDistributePrice,goodImage,shopImage,shopID,shopName) values(?,?,?,?,?,?,?,?,?,?)",good.goodName,good.goodNum,good.goodID,good.goodPrice,good.goodStartFee,good.goodDistributePrice,good.goodImage,good.shopImage,good.shopID,good.shopName];
    [db close];
}

//根据商品id来删除一条记录
+(void)deleteGoodWithGoodsId:(int)peopleID
{
    //获取数据库对象
    FMDatabase * db=[DataBaseUtil getDateBase];
    if (![db open])
    {
        [db close];
        return ;
    }
    [db setShouldCacheStatements:YES];
    [db executeUpdate:@"delete from peopleTable where goodID=?",[NSString stringWithFormat:@"%d",peopleID]];
    [db close];
}



//根据店铺id来删除一条记录
+(void)deleteGoodWithStoreId:(int)peopleID{
    
    //获取数据库对象
    FMDatabase * db=[DataBaseUtil getDateBase];
    if (![db open])
    {
        [db close];
        return ;
    }
    [db setShouldCacheStatements:YES];
    [db executeUpdate:@"delete from peopleTable where shopID=?",[NSString stringWithFormat:@"%d",peopleID]];
    [db close];

}

// 清空数据库所有记录
+ (void)clearAllDatas{
    
    //获取数据库对象
    FMDatabase * db=[DataBaseUtil getDateBase];
    if (![db open])
    {
        [db close];
        return ;
    }
    [db setShouldCacheStatements:YES];
    [db executeUpdate:@"delete from peopleTable"];
    [db close];
}

//跟新一条记录
+(void)upDateGood:(WDChooseGood *)good
{
    //获取数据库对象
    FMDatabase * db=[DataBaseUtil getDateBase];
    if (![db open])
    {
        [db close];
        return ;
    }
    [db setShouldCacheStatements:YES];
    [db executeUpdate:@"update peopleTable set goodNum=? where goodID=?", good.goodNum, good.goodID];
    [db close];
}


@end
