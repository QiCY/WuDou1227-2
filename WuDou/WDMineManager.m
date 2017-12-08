//
//  WDMineManager.m
//  WuDou
//
//  Created by huahua on 16/9/19.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMineManager.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation WDMineManager

#pragma mark - 加载配送地址
+ (void)requestSendAddressWithCompletion:(void(^)(NSMutableArray *array,NSString *resultRet, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/shipaddresses/Load?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSMutableArray *dataArr = [NSMutableArray array];
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *modelDic in data) {
                
                WDLoadAddressModel *model = [[WDLoadAddressModel alloc]initWithDictionary:modelDic];
                [dataArr addObject:model];
            }
            
            if (complete) {
                
                complete(dataArr,nil,nil);
            }
            
        }else if ([ret isEqualToString:@"1"]){
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,nil,error);
            }
            
        }else{
            
            //等于2就是用户没有登录要跳转到登录页面
            complete(nil,ret,nil);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

#pragma mark - 添加配送地址
+ (void)requestAddAddressWithIsdefault:(NSString *)isdefault consignee:(NSString *)name mobile:(NSString *)number address:(NSString *)address addressMark:(NSString *)addressmark completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/shipaddresses/Add?access_token=%@&isdefault=%@&consignee=%@&mobile=%@&address=%@&addressmark=%@",API_PORT,token,isdefault,name,number,address,addressmark];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = [responseObject objectForKey:@"msg"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 编辑配送地址
+ (void)requestEditAddressWithSaid:(NSString *)said isdefault:(NSString *)isdefault consignee:(NSString *)name mobile:(NSString *)number address:(NSString *)address addressMark:(NSString *)addressmark completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/shipaddresses/Update?access_token=%@&said=%@&isdefault=%@&consignee=%@&mobile=%@&address=%@&addressmark=%@",API_PORT,token,said,isdefault,name,number,address,addressmark];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = [responseObject objectForKey:@"msg"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 删除配送地址
+ (void)requestDeleteAddressWithSaid:(NSString *)said completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/shipaddresses/Delete?access_token=%@&said=%@",API_PORT,token,said];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = [responseObject objectForKey:@"msg"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载我的收藏
+ (void)requestMyCollectionWithCompletion:(void(^)(NSMutableArray *array,NSString *resultRet, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
#warning - 接口出错
    NSString *urlStr = [NSString stringWithFormat:@"%@api/favorite/Load?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSMutableArray *dataArr = [NSMutableArray array];
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *modelDic in data) {
                
                WDMyCollectModel *model = [[WDMyCollectModel alloc]initWithDictionary:modelDic];
                [dataArr addObject:model];
            }
            
            if (complete) {
                
                complete(dataArr,nil,nil);
            }
            
        }else if ([ret isEqualToString:@"1"]){
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,nil,error);
            }
            
        }else{
            
            //等于2就是用户没有登录要跳转到登录页面
            complete(nil,ret,nil);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 取消我的收藏
+ (void)requestCancelMyCollectWithRecordId:(NSString *)recordid completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/favorite/Delete?recordid=%@&access_token=%@",API_PORT,recordid,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = [responseObject objectForKey:@"msg"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 是否登陆
+ (void)requestLoginEnabledWithCompletion:(void(^)(NSString *resultRet))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/HasLogin?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if (complete) {
            
            complete(ret);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

#pragma mark - 退出登陆
+ (void)requestExitLoginWithCompletion:(void(^)(WDAppInit *appInit, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/LoginOut?access_token=%@",API_PORT,token];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            // 保存token
            NSString *token1 = responseObject[@"access_token"];
            NSLog(@"退出后token = %@",token1);
            
            [[NSUserDefaults standardUserDefaults] setObject:token1 forKey:@"APP_ACCESS_TOKEN"];
            
            WDAppInit *model = [[WDAppInit alloc]initWithDictionary:responseObject];
            
            if (complete) {
                
                complete(model,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

#pragma mark - 获取用户详细信息
+ (void)requestUserMsgWithInformation:(NSString *)info Completion:(void(^)(WDUserMsgModel *userMsg, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/Information%@?access_token=%@",API_PORT,info,token];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            WDUserMsgModel *model = [[WDUserMsgModel alloc]initWithDictionary:responseObject];
            
            if (complete) {
                
                complete(model,nil);
            }
            
        }else{
         
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 修改用户密码
+ (void)requestFixPasswordWithOldPassword:(NSString *)oldpassword newPassword:(NSString *)newpassword completion:(void(^)(NSString *result, NSString *error))complete{
    
//    NSString * MD5old = [self md5HexDigest:oldpassword];
//    NSString * MD5new = [self md5HexDigest:newpassword];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/UpdatePassword?access_token=%@&oldpassword=%@&newpassword=%@",API_PORT,token,oldpassword,newpassword];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = [responseObject objectForKey:@"msg"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - MD5加密
+(NSString *)md5HexDigest:(NSString*)Des_str
{
    const char *original_str = [Des_str UTF8String];
    //unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
    {
        //x表示十六进制，X  意思是不足两位将用0补齐，如果多余两位则不影响
        [hash appendFormat:@"%02x", result[i]];
        
    }
    
    NSString *mdfiveString = [hash lowercaseString];
    
    // //NNSLog(@"md5加密输出：Encryption Result = %@",mdfiveString);
    
    return mdfiveString;
    
}

#pragma mark - 加载我的优惠券
+ (void)requestMyCouponWithSate:(NSString *)sate completion:(void(^)(NSMutableArray *array,NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/coupons/Load?access_token=%@&sate=%@",API_PORT,token,sate];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSMutableArray *modelArr = [NSMutableArray array];
            NSArray *data = responseObject[@"data"];
            
            for (NSDictionary *dic in data) {
                
                WDMyCouponModel *model = [[WDMyCouponModel alloc] initWithDictionary:dic];
                [modelArr addObject:model];
            }
            
            if (complete) {
                
                complete(modelArr,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         NSLog(@"error = %@", error);
    }];
}

#pragma mark - 删除我的优惠券
+ (void)requestDeletCouponWithCouponId:(NSString *)couponid completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/coupons/Delete?access_token=%@&couponid=%@",API_PORT,token,couponid];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = [responseObject objectForKey:@"msg"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];

}

#pragma mark - 加载我的订单列表
+ (void)requestOrderListWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/orders/Load?access_token=%@&currentpage=%@",API_PORT,token,currentpage];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *dataArr = [NSMutableArray array];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *modelDic in data) {
                
                WDOrderListModel *model = [[WDOrderListModel alloc]initWithDictionary:modelDic];
                [dataArr addObject:model];
            }
            
            if (complete) {
                
                complete(dataArr,nil);
            }
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载订单详情
+ (void)requestOrderMsgWithOid:(NSString *)oid completion:(void(^)(WDOrderMsgModel *model, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/orders/LoadInfo?access_token=%@&oid=%@",API_PORT,token,oid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
         
            WDOrderMsgModel *msgModel = [[WDOrderMsgModel alloc]initWithDictionary:responseObject];
            if (complete) {
                
                complete(msgModel,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 取消我的订单
+ (void)requestCancelMyOrderwithOid:(NSString *)oid completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/orders/Cancel?access_token=%@&oid=%@",API_PORT,token,oid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = [responseObject objectForKey:@"msg"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 删除我的订单 
+ (void)requestDeleteMyOrderWithOid:(NSString *)oid completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/orders/Delete?access_token=%@&oid=%@",API_PORT,token,oid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = [responseObject objectForKey:@"msg"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载我的商户订单
+ (void)requestStoresOrdersWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/storesorders/Load?access_token=%@&currentpage=%@",API_PORT,token,currentpage];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *dataArr = [NSMutableArray array];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *modelDic in data) {
                
                WDOrderListModel *model = [[WDOrderListModel alloc]initWithDictionary:modelDic];
                [dataArr addObject:model];
            }
            
            if (complete) {
                
                complete(dataArr,nil);
            }
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 个人中心-商户订单-按钮编辑
+ (void)requestStoreOrderHaveEditBtnWithOid:(NSString *)oid completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/storesorders/EditOrder?access_token=%@&oid=%@",API_PORT,token,oid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = [responseObject objectForKey:@"msg"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

#pragma mark - 加载商户订单单个订单信息
+ (void)requestStoreOrderMsgWithOid:(NSString *)oid completion:(void(^)(WDOrderMsgModel *model, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/orders/LoadInfo?access_token=%@&oid=%@",API_PORT,token,oid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            WDOrderMsgModel *msgModel = [[WDOrderMsgModel alloc]initWithDictionary:responseObject];
            if (complete) {
                
                complete(msgModel,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载配送员订单
+ (void)requestSenderOrderWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/storesorders/LoadDistribution?access_token=%@&currentpage=%@",API_PORT,token,currentpage];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *dataArr = [NSMutableArray array];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *modelDic in data) {
                
                WDOrderListModel *model = [[WDOrderListModel alloc]initWithDictionary:modelDic];
                [dataArr addObject:model];
            }
            
            if (complete) {
                
                complete(dataArr,nil);
            }
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 个人中心-配送员订单-编辑按钮
+ (void)requestSenderOrderHavaEditBtnWithOid:(NSString *)oid completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/storesorders/EditOrderDistribution?access_token=%@&oid=%@",API_PORT,token,oid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = [responseObject objectForKey:@"msg"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载我的二手品页面
+ (void)requestLoadMySecondGoodsWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array,NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/mysecondhand/Loadproduct?access_token=%@&currentpage=%@",API_PORT,token,currentpage];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSDictionary *products = responseObject[@"products"];
            NSString *productsRet = products[@"ret"];
            NSMutableArray *modelArray = [NSMutableArray array];
            
            if ([productsRet isEqualToString:@"0"]) {
                
                NSArray *data = products[@"data"];
                for (NSDictionary *dic in data) {
                    
                    WDSearchInfosModel *model = [[WDSearchInfosModel alloc] initWithDictionary:dic];
                    [modelArray addObject:model];
                }
                
                if (complete) {
                    
                    complete(modelArray,nil);
                }
            }else{
                
                NSString * error = [products objectForKey:@"msg"];
                if (complete)
                {
                    complete(nil,error);
                }
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载二手品详情
+ (void)requestMySecondGoodsMsgWithPid:(NSString *)pid completion:(void(^)(WDCreditProductsModel *model, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/mysecondhand/Loadinfo?access_token=%@&pid=%@",API_PORT,token,pid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSDictionary *productsinfo = responseObject[@"productsinfo"];
            WDCreditProductsModel *infosModel = [[WDCreditProductsModel alloc]initWithDictionary:productsinfo];
            if (complete) {
                
                complete(infosModel,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 删除二手品
+ (void)requestDeleteMySecondGoodsWithPid:(NSString *)pid completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/mysecondhand/Delete?access_token=%@&pid=%@",API_PORT,token,pid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *msg = responseObject[@"mag"];
            if (complete) {
                
                complete(msg,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载我的便民服务
+ (void)requestLoadMyServiceWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array,NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/usersmyservice/Loadnews?access_token=%@&currentpage=%@",API_PORT,token,currentpage];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSDictionary *products = responseObject[@"news"];
            NSString *productsRet = products[@"ret"];
            NSMutableArray *modelArray = [NSMutableArray array];
            
            if ([productsRet isEqualToString:@"0"]) {
                
                NSArray *data = products[@"data"];
                for (NSDictionary *dic in data) {
                    
                    WDSearchInfosModel *model = [[WDSearchInfosModel alloc] initWithDictionary:dic];
                    [modelArray addObject:model];
                }
                
                if (complete) {
                    
                    complete(modelArray,nil);
                }
            }
            else{
                
                NSString * error = [products objectForKey:@"msg"];
                if (complete)
                {
                    complete(nil,error);
                }
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载便民服务详情
+ (void)requestLoadMyServiceMsgWithNewsid:(NSString *)newsid completion:(void(^)(WDCreditProductsModel *model, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/usersmyservice/Loadinfo?access_token=%@&newsid=%@",API_PORT,token,newsid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSDictionary *productsinfo = responseObject[@"newsinfo"];
            WDCreditProductsModel *infosModel = [[WDCreditProductsModel alloc]initWithDictionary:productsinfo];
            if (complete) {
                
                complete(infosModel,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

#pragma mark - 删除我的便民服务
+ (void)requestDeleteMySericeWithNewsId:(NSString *)newsid completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/usersmyservice/Delete?access_token=%@&newsid=%@",API_PORT,token,newsid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *msg = responseObject[@"mag"];
            if (complete) {
                
                complete(msg,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载用户评论的订单数据
+ (void)requestUserJudgementOrderDataWithOid:(NSString *)oid completion:(void(^)(NSMutableArray *array,NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/orders/LoadreViewsInfo?access_token=%@&oid=%@",API_PORT,token,oid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            NSMutableArray *modelArray = [NSMutableArray array];
            
            for (NSDictionary *dic in data) {
                
                WDSpecialPriceModel *model = [[WDSpecialPriceModel alloc] initWithDictionary:dic];
                [modelArray addObject:model];
            }
            
            if (complete) {
                complete(modelArray,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 个人中心-我的评论 
+ (void)requestMyJudgementsWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array,NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/productreviews/LoadByuid?access_token=%@&currentpage=%@",API_PORT,token,currentpage];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            NSMutableArray *layoutArray = [NSMutableArray array];
            
            for (NSDictionary *dic in data) {
                
                WDMyJudgementModel *model = [[WDMyJudgementModel alloc] initWithDictionary:dic];
                WDMyJudgementsLayout *layout = [[WDMyJudgementsLayout alloc] init];
                layout.judgesModel = model;
                [layoutArray addObject:layout];
            }
            
            if (complete) {
                complete(layoutArray,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 产品详情页面-更多评论
+(void)requestGoodsInfoMoreJudgementsWithPid:(NSString *)pid currentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array,NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/productreviews/LoadBypid?access_token=%@&pid=%@&currentpage=%@",API_PORT,token,pid,currentpage];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            NSMutableArray *layoutArray = [NSMutableArray array];
            
            for (NSDictionary *dic in data) {
                
                WDMyJudgementModel *model = [[WDMyJudgementModel alloc] initWithDictionary:dic];
                WDMyJudgementsLayout *layout = [[WDMyJudgementsLayout alloc] init];
                layout.judgesModel = model;
                [layoutArray addObject:layout];
            }
            
            if (complete) {
                complete(layoutArray,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 我的账户-全部订单-去评价
+ (void)requestGotoCommentWithOid:(NSString *)oid star1:(NSString *)star1 star2:(NSString *)star2 star3:(NSString *)star3 message:(NSString *)message media_ids:(NSString *)media_ids completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/productreviews/Add?access_token=%@&oid=%@&star1=%@&star2=%@&star3=%@&message=%@&media_ids=%@",API_PORT,token,oid,star1,star2,star3,message,media_ids];
    
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *msg = responseObject[@"msg"];
            if (complete) {
                
                complete(msg,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 根据用户令牌判断商户订单是否显示
+ (void)requestShowStoreOrderWithCompletion:(void(^)(NSString *isShow, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/menu/Show?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *show = responseObject[@"show"];
            if (complete) {
                
                complete(show,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 根据用户令牌获取周边位置
+ (void)requestNearRegionWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array,NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/placesearch/Load?access_token=%@&currentpage=%@",API_PORT,token,currentpage];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            NSMutableArray *modelArr = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                
                WDNearLocationModel *model = [[WDNearLocationModel alloc] initWithDictionary:dic];
                [modelArr addObject:model];
            }
            if (complete) {
                
                complete(modelArr,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 退款原因列表
+ (void)requestRefundReasonWithOid:(NSString *)oid completion:(void(^)(NSMutableArray *array,NSString *reason,NSString *mark,NSString *fankui,NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/orders/Refund_reason?access_token=%@&oid=%@",API_PORT,token,oid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            NSString *refund_reason = responseObject[@"refund_reason"];
            NSString *refund_mark = responseObject[@"refund_mark"];
            NSString *refund_feedback = responseObject[@"refund_feedback"];
            
            NSMutableArray *modelArr = [NSMutableArray array];
            
            for (NSDictionary *dic in data) {
                
                NSString *text = dic[@"text"];
                [modelArr addObject:text];
            }
            if (complete) {
                
                complete(modelArr,refund_reason,refund_mark,refund_feedback,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,nil,nil,nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 退款申请
+ (void)requestApplyforMoneyWithOid:(NSString *)oid refundReason:(NSString *)reason refundMark:(NSString *)mark completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/orders/Refund?access_token=%@&oid=%@&refund_reason=%@&refund_mark=%@",API_PORT,token,oid,reason,mark];
    
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = responseObject[@"msg"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

#pragma mark - 普通用户是否有未读消息
+ (void)requestNormalUserhasUnreadNewsWithCompletion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/chatlog/Userisread?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = responseObject[@"isreadcount"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 商户用户普通用户是否有未读消息
+ (void)requestStoreUserhasUnreadNewsWithCompletion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/chatlog/Userisstoreread?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *success = responseObject[@"isreadcount"];
            if (complete) {
                
                complete(success,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 更改用户名
+ (void)requestChangeUserNameWithName:(NSString *)usersname completion:(void(^)(WDAppInit *appInit, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/UpdateUsername?access_token=%@&usersname=%@",API_PORT,token,usersname];
    
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            // 保存token
            NSString *token1 = responseObject[@"access_token"];
            NSLog(@"修改用户名后token = %@",token1);
            
            [[NSUserDefaults standardUserDefaults] setObject:token1 forKey:@"APP_ACCESS_TOKEN"];
            
            WDAppInit *model = [[WDAppInit alloc]initWithDictionary:responseObject];
            
            if (complete) {
                
                complete(model,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 修改用户头像
+ (void)requestChangeUserHeaderImageWithMediaIds:(NSString *)mediaids completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/UpdateAvatar?access_token=%@&media_ids=%@",API_PORT,token,mediaids];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString * msg = [responseObject objectForKey:@"msg"];
            if (complete) {
                
                complete(msg,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

@end
