//
//  DataBaseUtil.m
//  FMDB封装
//
//  Created by ZY on 15/8/12.
//  Copyright (c) 2015年 ZY. All rights reserved.
//

#import "DataBaseUtil.h"

@implementation DataBaseUtil

static FMDatabase * _db;
+(FMDatabase *)getDateBase
{
    if (_db==nil)
    {
        NSString * filePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/people.sqlite"];
        _db=[[FMDatabase alloc]initWithPath:filePath];
    }
    return _db;
}
@end




