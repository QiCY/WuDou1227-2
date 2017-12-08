//
//  WDSpeakCategoriesManager.h
//  WuDou
//
//  Created by huahua on 16/9/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDCategoriesModel.h"
#import "WDSearchResultModel.h"
#import "WDSpecialPriceModel.h"

@interface WDSpeakCategoriesManager : NSObject
/** 分类*/
+ (void)requestCategoriesWithCompletion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 分类搜索*/
+ (void)requestCategorySearchWithCatenumber:(NSString *)catenumber completion:(void(^)(NSMutableArray *array, NSString *error))complete;

@end
