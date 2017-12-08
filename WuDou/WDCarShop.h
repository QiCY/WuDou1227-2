//
//  WDCarShop.h
//  WuDou
//
//  Created by huahua on 16/9/23.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDCarShop : NSObject

@property(nonatomic,copy)NSString * shopID, * shopName, * shopImage,*startFee;
@property(nonatomic,strong)NSMutableArray *goodsList;
@property(nonatomic,assign)BOOL isSelectAll;
@end
