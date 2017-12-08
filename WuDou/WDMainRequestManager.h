//
//  WDMainRequestManager.h
//  WuDou
//
//  Created by huahua on 16/9/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDAdvertisementModel.h"
#import "WDSpecialPriceModel.h"
#import "WDNearbyStoreModel.h"
#import "WDGoodChoiceModel.h"
#import "WDGoodsMsgModel.h"
#import "WDStoreMsgModel.h"
#import "WDSearchResultModel.h"
#import "WDLeaderboardModel.h"
#import "WDCreditProductsModel.h"
#import "WDCategoryModel.h"
#import "WDSearchInfosModel.h"
#import "WDAreaModel.h"
#import "WDCellLayout.h"
#import "WDNewsModel.h"

@interface WDMainRequestManager : NSObject

/** 首页整个请求*/
+ (void)requestMainDatasWithCompletion:(void(^)(NSMutableArray *array, NSString *countDown, NSString *error))complete;

/** 商品详情*/
+ (void)requestGoodsMsgWithGoodsId:(NSString *)goodsId completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 产品详情下面-页面评价*/
+ (void)requestJudgementsWithPid:(NSString *)pid completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 产品搜索*/
+ (void)requestSearchProductsWithSearchKey:(NSString *)searchKey completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 加载果蔬生鲜首页数据*/
+ (void)requestLoadFruitAndVegetableWithCompletion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 加载果蔬生鲜产品列表*/
+ (void)requestLoadFruitAndVegetableWithUrltype:(NSString *)urltype currentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete;
/*首页店铺分类列表*/
+ (void)requestNearByShopMenuWithType:(NSString *)type completion:(void(^)(NSMutableArray *array,NSMutableArray* typeArray, NSString *error))complete;
/*获取首页店铺分类*/
+ (void)requestNearByShopMenuCompletion:(void(^)(NSMutableArray *array, NSString *error))complete;
/*首页获取精品推荐商品*/
+ (void)requestRecommentGoodsCompletion:(void(^)(NSMutableArray *array, NSString *error))complete;

/*首页获取广告接口*/
+ (void)requestAdvertsCompletion:(void(^)(NSMutableArray *array, NSString *error))complete;
/** 签到*/
+ (void)requestSignInWithCompletion:(void(^)(NSString *result, NSString *error))complete;

/** 加载积分商城首页广告*/
+ (void)requestLoadJifenStoreAdsWithCompletion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 加载排行榜*/
+ (void)requestLoadLeaderboardWithType:(NSString *)type currentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 加载积分商城产品数据*/
+ (void)requestLoadJifenStoreProductsWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 加载单个积分产品信息*/
+ (void)requestLoadJifenStoreProductsMsgWithPid:(NSString *)pid completion:(void(^)(WDCreditProductsModel *pmodel, NSString *error))complete;

/** 兑换积分商品*/
+ (void)requestExchangeJIfenGoodsWithAddressId:(NSString *)addressid goodsId:(NSString *)pid completion:(void(^)(NSString *result, NSString *error))complete;

/** 加载二手品首页广告*/
+ (void)requestLoadSecondStoreAdsWithCompletion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 加载二手品首页产品数据*/
+ (void)requestLoadSecondStoreMainDatasWithRegion:(NSString *)region money:(NSString *)money sate:(NSString *)sate keyValue:(NSString *)keyvalue currentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 加载我的二手品详细信息*/
+ (void)requestLoadSecondStoreProductsMsgsWithPid:(NSString *)pid completion:(void(^)(WDCreditProductsModel *pmodel, NSString *error))complete;

/** 加载便民服务首页广告*/
+ (void)requestLoadConvenientAdsWithCompletion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 加载便民服务资讯类列表*/
+ (void)requestLoadConvenientMainDatasWithRegion:(NSString *)region sate:(NSString *)sate cateId:(NSString *)cateid keyValue:(NSString *)keyvalue currentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 获取便民服务详细信息*/
+ (void)requestLoadConvenientProductsMsgsWithNewsId:(NSString *)newsid completion:(void(^)(WDCreditProductsModel *pmodel, NSString *error))complete;

/** 二手商品详细页面查看联系方式*/
+ (void)requestLookSecondGoodsMobileWithPid:(NSString *)pid completion:(void(^)(NSString *mobile, NSString *error))complete;

/** 便民服务详细页面查看联系方式*/
+ (void)requestLookConvenientMobileWithNewsId:(NSString *)newsid completion:(void(^)(NSString *mobile, NSString *error))complete;

/** 获取区域信息*/
+ (void)requestLoadAreaWithCompletion:(void(^)(NSMutableArray * dataArray, NSString *error))complete;

/** 个人中心-便民服务-发布便民服务-类别列表*/
+ (void)requestLoadCategoryListWithCompletion:(void(^)(NSMutableArray * dataArray, NSString *error))complete;

/** 发布我的二手品*/
+ (void)requestPublishMySecondGoodsWithName:(NSString *)name region:(NSString *)region money:(NSString *)money sate:(NSString *)sate contacts:(NSString *)contacts mobile:(NSString *)mobile media_ids:(NSString *)media_ids content:(NSString *)content completion:(void(^)(NSString *result, NSString *error))complete;

/** 发布我的便民服务*/
+ (void)requestPublishMyServerWithName:(NSString *)name region:(NSString *)region sate:(NSString *)sate cateId:(NSString *)cateid contacts:(NSString *)contacts mobile:(NSString *)mobile media_ids:(NSString *)media_ids content:(NSString *)content completion:(void(^)(NSString *result, NSString *error))complete;

/** 首页-特价-更多页面接口*/
+ (void)requestMoreTejiaWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray * dataArray, NSString *error))complete;


@end
