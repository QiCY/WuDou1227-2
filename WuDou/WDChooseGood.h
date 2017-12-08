//
//  WDChooseGood.h
//  WuDou
//
//  Created by huahua on 16/9/21.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDChooseGood : NSObject

@property(nonatomic,copy)NSString * goodID, * goodNum, * goodName, * goodPrice, * goodStartFee, *goodDistributePrice, * goodImage;
@property(nonatomic,copy)NSString * shopID, * shopName, * shopImage;
@property(nonatomic,assign)BOOL selected;
@end
