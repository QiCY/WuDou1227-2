//
//  DataBaseUtil.h
//  FMDB封装
//
//  Created by ZY on 15/8/12.
//  Copyright (c) 2015年 ZY. All rights reserved.
//

//这个类用来获取数据库对象
#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
@interface DataBaseUtil : NSObject

//获取FMDB对象 必须在.h声明 用到方法的时候才会有提示
+(FMDatabase *)getDateBase;

@end





