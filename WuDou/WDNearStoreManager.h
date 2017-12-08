//
//  WDNearStoreManager.h
//  WuDou
//
//  Created by huahua on 16/9/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDCategoryModel.h"
#import "WDNearbyStoreModel.h"
#import "WDStoreInfosModel.h"
#import "WDStoreInfoCatesModel.h"
#import "WDSearchInfosModel.h"
#import "WDMyCouponModel.h"
#import "WDSendTimeModel.h"

@interface WDNearStoreManager : NSObject

/** 附近店铺列表*/
+ (void)requestNearStoreWithStoreclasses:(NSString *)category storeorder:(NSString *)order storesate:(NSString *)state currentPage:(NSString *)page completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 店铺详情*/
+ (void)requestStoreInfosWithStoreId:(NSString *)storeId completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 店铺详情-净菜区/配送区*/
+ (void)requestStoreInfosWithStoreId:(NSString *)storeId sate:(NSString *)sate completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 加载店铺详情优惠券*/
+ (void)requestStoreInfoCouponsWithStoreId:(NSString *)storeid completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 领取优惠券*/
+ (void)requestGetCouponWithCouponid:(NSString *)couponid completion:(void(^)(NSString *result, NSString *error))complete;
/** 选择优惠券*/
+ (void)requestDiscountWithStoreId:(NSString *)storeId completion:(void(^)(NSMutableArray *array, NSString *error))complete;
/** 店铺产品信息及搜索*/
+ (void)requestProductInfosWithStoreId:(NSString *)storeId cateId:(NSString *)cateId searchKey:(NSString *)searchKey completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 店铺产品信息-净菜区/配送区*/
+ (void)requestProductInfosWithStoreId:(NSString *)storeId cateId:(NSString *)cateId searchKey:(NSString *)searchKey sate:(NSString *)sate completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 选择配送时间*/
+ (void)requestChoiceSendTimeWithStoreId:(NSString *)storeId completion:(void(^)(NSMutableArray *array, NSString *error))complete;

+ (void)requestDiscountWithStoreId:(NSString *)storeId completion:(void(^)(NSMutableArray *array, NSString *error))complete;
/** 提交订单*/
+ (void)requestSubmitOrderWithAddressId:(NSString *)addressid autoTimeId:(NSString *)autotimeid orderInfo:(NSString *)orderinfo buyyerMark:(NSString *)mark completion:(void(^)(NSString *osn,NSString *paysn, NSString *error))complete;

/** 店铺详情编辑收藏*/
+ (void)requestEditCollectWithStoreorId:(NSString *)storeorid completion:(void(^)(NSString *state, NSString *error))complete;

/** 根据订单号获取支付报文签名*/
+ (void)requestSignWordWithPayType:(NSString *)paytype oid:(NSString *)oid signType:(NSString *)sntype completion:(void(^)(NSString *signStr, NSString *error))complete;

@end
