//
//  WDMineManager.h
//  WuDou
//
//  Created by huahua on 16/9/19.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDLoadAddressModel.h"
#import "WDMyCollectModel.h"
#import "WDAppInit.h"
#import "WDUserMsgModel.h"
#import "WDMyCouponModel.h"
#import "WDOrderListModel.h"
#import "WDProductsDataModel.h"
#import "WDOrderMsgModel.h"
#import "WDSearchInfosModel.h"
#import "WDCreditProductsModel.h"
#import "WDNearLocationModel.h"
#import "WDSpecialPriceModel.h"
#import "WDMyJudgementModel.h"
#import "WDMyJudgementsLayout.h"

@interface WDMineManager : NSObject

/** 加载配送地址*/
+ (void)requestSendAddressWithCompletion:(void(^)(NSMutableArray *array,NSString *resultRet, NSString *error))complete;

/** 添加配送地址*/
+ (void)requestAddAddressWithIsdefault:(NSString *)isdefault consignee:(NSString *)name mobile:(NSString *)number address:(NSString *)address addressMark:(NSString *)addressmark completion:(void(^)(NSString *result, NSString *error))complete;

/** 编辑配送地址*/
+ (void)requestEditAddressWithSaid:(NSString *)said isdefault:(NSString *)isdefault consignee:(NSString *)name mobile:(NSString *)number address:(NSString *)address addressMark:(NSString *)addressmark completion:(void(^)(NSString *result, NSString *error))complete;

/** 删除配送地址*/
+ (void)requestDeleteAddressWithSaid:(NSString *)said completion:(void(^)(NSString *result, NSString *error))complete;

/** 加载我的收藏*/
+ (void)requestMyCollectionWithCompletion:(void(^)(NSMutableArray *array,NSString *resultRet, NSString *error))complete;

/** 取消我的收藏*/
+ (void)requestCancelMyCollectWithRecordId:(NSString *)recordid completion:(void(^)(NSString *result, NSString *error))complete;

/** 是否登陆*/
+ (void)requestLoginEnabledWithCompletion:(void(^)(NSString *resultRet))complete;

/** 退出登陆*/
+ (void)requestExitLoginWithCompletion:(void(^)(WDAppInit *appInit, NSString *error))complete;

/** 获取用户详细信息*/
+ (void)requestUserMsgWithInformation:(NSString *)info Completion:(void(^)(WDUserMsgModel *userMsg, NSString *error))complete;

/** 修改用户密码*/
+ (void)requestFixPasswordWithOldPassword:(NSString *)oldpassword newPassword:(NSString *)newpassword completion:(void(^)(NSString *result, NSString *error))complete;

/** 加载我的优惠券*/
+ (void)requestMyCouponWithSate:(NSString *)sate completion:(void(^)(NSMutableArray *array,NSString *error))complete;

/** 删除我的优惠券*/
+ (void)requestDeletCouponWithCouponId:(NSString *)couponid completion:(void(^)(NSString *result, NSString *error))complete;

/** 加载我的订单列表*/
+ (void)requestOrderListWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 加载订单详情*/
+ (void)requestOrderMsgWithOid:(NSString *)oid completion:(void(^)(WDOrderMsgModel *model, NSString *error))complete;

/** 取消我的订单*/
+ (void)requestCancelMyOrderwithOid:(NSString *)oid completion:(void(^)(NSString *result, NSString *error))complete;

/** 删除我的订单*/
+ (void)requestDeleteMyOrderWithOid:(NSString *)oid completion:(void(^)(NSString *result, NSString *error))complete;

/** 加载商户订单*/
+ (void)requestStoresOrdersWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 个人中心-商户订单-按钮编辑*/
+ (void)requestStoreOrderHaveEditBtnWithOid:(NSString *)oid completion:(void(^)(NSString *result, NSString *error))complete;

/** 加载商户订单单个订单信息*/
+ (void)requestStoreOrderMsgWithOid:(NSString *)oid completion:(void(^)(WDOrderMsgModel *model, NSString *error))complete;

/** 加载配送员订单*/
+ (void)requestSenderOrderWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete;

/** 个人中心-配送员订单-编辑按钮*/
+ (void)requestSenderOrderHavaEditBtnWithOid:(NSString *)oid completion:(void(^)(NSString *result, NSString *error))complete;

/** 加载我的二手品页面*/
+ (void)requestLoadMySecondGoodsWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array,NSString *error))complete;

/** 加载二手品详情*/
+ (void)requestMySecondGoodsMsgWithPid:(NSString *)pid completion:(void(^)(WDCreditProductsModel *model, NSString *error))complete;

/** 删除二手品*/
+ (void)requestDeleteMySecondGoodsWithPid:(NSString *)pid completion:(void(^)(NSString *result, NSString *error))complete;

/** 加载我的便民服务*/
+ (void)requestLoadMyServiceWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array,NSString *error))complete;

/**加载便民服务详情*/
+ (void)requestLoadMyServiceMsgWithNewsid:(NSString *)newsid completion:(void(^)(WDCreditProductsModel *model, NSString *error))complete;

/** 删除我的便民服务*/
+ (void)requestDeleteMySericeWithNewsId:(NSString *)newsid completion:(void(^)(NSString *result, NSString *error))complete;

/** 加载用户评论的订单数据*/
+ (void)requestUserJudgementOrderDataWithOid:(NSString *)oid completion:(void(^)(NSMutableArray *array,NSString *error))complete;

/** 个人中心-我的评论*/
+ (void)requestMyJudgementsWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array,NSString *error))complete;

/** 产品详情页面-更多评论*/
+(void)requestGoodsInfoMoreJudgementsWithPid:(NSString *)pid currentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array,NSString *error))complete;

/** 我的账户-全部订单-去评价*/
+ (void)requestGotoCommentWithOid:(NSString *)oid star1:(NSString *)star1 star2:(NSString *)star2 star3:(NSString *)star3 message:(NSString *)message media_ids:(NSString *)media_ids completion:(void(^)(NSString *result, NSString *error))complete;

/** 根据用户令牌判断商户订单是否显示*/
+ (void)requestShowStoreOrderWithCompletion:(void(^)(NSString *isShow, NSString *error))complete;

/** 根据用户令牌获取周边位置*/
+ (void)requestNearRegionWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array,NSString *error))complete;

/** 退款原因列表*/
+ (void)requestRefundReasonWithOid:(NSString *)oid completion:(void(^)(NSMutableArray *array,NSString *reason,NSString *mark,NSString *fankui,NSString *error))complete;

/** 退款申请*/
+ (void)requestApplyforMoneyWithOid:(NSString *)oid refundReason:(NSString *)reason refundMark:(NSString *)mark completion:(void(^)(NSString *result, NSString *error))complete;

/** 普通用户是否有未读消息*/
+ (void)requestNormalUserhasUnreadNewsWithCompletion:(void(^)(NSString *result, NSString *error))complete;

/** 商户用户普通用户是否有未读消息*/
+ (void)requestStoreUserhasUnreadNewsWithCompletion:(void(^)(NSString *result, NSString *error))complete;

/** 更改用户名*/
+ (void)requestChangeUserNameWithName:(NSString *)usersname completion:(void(^)(WDAppInit *appInit, NSString *error))complete;

/** 修改用户头像*/
+ (void)requestChangeUserHeaderImageWithMediaIds:(NSString *)mediaids completion:(void(^)(NSString *result, NSString *error))complete;

@end
