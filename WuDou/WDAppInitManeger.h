//
//  WDAppInitManeger.h
//  WuDou
//
//  Created by huahua on 16/9/9.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import "WDAppInit.h"

@interface WDAppInitManeger : NSObject

/** 初始化用户令牌*/
+ (void)requestAppInitWithType:(NSString *)appType verson:(NSString *)verson model:(NSString *)model iMei:(NSString *)imei completion:(void(^)(WDAppInit *appInit, NSString *error))complete;

#pragma mark - MD5加密
+(NSString *)md5HexDigest:(NSString*)Des_str;

#pragma mark - 保存某个字符
+(void)saveStrData:(NSString *)keyStr withStr:(NSString *)string;

/** 设置用户令牌用户信息（登录）*/
+ (void)requestUserMsgWithUserName:(NSString *)userName passWord:(NSString *)password completion:(void(^)(WDAppInit *appInit, NSString *error))complete;

/** 设置用户令牌区域信息*/
+ (void)requestUserAreaMsgWithRegionname:(NSString *)regionname completion:(void(^)(WDAppInit *appInit, NSString *error))complete;

/** 设置用户令牌位置信息*/
+ (void)requestUserLocationMsgWithCoordinate:(NSString *)coord completion:(void(^)(WDAppInit *appInit, NSString *error))complete;

/** 用户注册*/
+ (void)requestRegistWithMobile:(NSString *)mobile passWord:(NSString *)password verificationCode:(NSString *)verificationcode completion:(void(^)(WDAppInit *appInit, NSString *error))complete;

/** 用户注册获取手机验证码*/
+ (void)requestRegistVerificationCodeWithMobile:(NSString *)mobile completion:(void(^)(NSString *codeModel, NSString *error))complete;

/** 验证手机号*/
+ (BOOL)validateNumber:(NSString *)textString;

/** 找回密码验证码*/
+ (void)requestForgetPasswordVerificationCodeWithMobile:(NSString *)mobile completion:(void(^)(NSString *codeModel, NSString *error))complete;

/** 找回密码*/
+ (void)requestFindPasswordWithMobile:(NSString *)mobile verificationCode:(NSString *)verificationcode newPassword:(NSString *)password completion:(void(^)(NSString *result, WDAppInit *appInit, NSString *error))complete;

@end
